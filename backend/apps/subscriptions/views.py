import stripe
from django.conf import settings
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.utils import timezone

from .models import Subscription, Payment, PricingPlan
from .serializers import (
    SubscriptionSerializer, PaymentSerializer, PricingPlanSerializer,
    CreateCheckoutSessionSerializer, CustomerPortalSerializer
)

stripe.api_key = settings.STRIPE_SECRET_KEY


class PricingPlanListView(generics.ListAPIView):
    """List available pricing plans."""
    
    serializer_class = PricingPlanSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        return PricingPlan.objects.filter(is_active=True)


class SubscriptionView(generics.RetrieveAPIView):
    """Get current user's subscription."""
    
    serializer_class = SubscriptionSerializer
    
    def get_object(self):
        subscription, created = Subscription.objects.get_or_create(
            user=self.request.user,
            defaults={'plan': Subscription.Plan.FREE}
        )
        return subscription


class PaymentHistoryView(generics.ListAPIView):
    """Get user's payment history."""
    
    serializer_class = PaymentSerializer
    
    def get_queryset(self):
        return Payment.objects.filter(user=self.request.user)


class CreateCheckoutSessionView(APIView):
    """Create Stripe checkout session."""
    
    def post(self, request):
        serializer = CreateCheckoutSessionSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        plan = serializer.validated_data['plan']
        success_url = serializer.validated_data['success_url']
        cancel_url = serializer.validated_data['cancel_url']
        
        # Get or create Stripe customer
        user = request.user
        if not user.stripe_customer_id:
            customer = stripe.Customer.create(
                email=user.email,
                name=user.full_name,
                metadata={'user_id': str(user.id)}
            )
            user.stripe_customer_id = customer.id
            user.save()
        
        # Get price ID
        try:
            pricing_plan = PricingPlan.objects.get(slug='pro')
            if plan == 'pro_monthly':
                price_id = pricing_plan.stripe_price_id_monthly
            else:
                price_id = pricing_plan.stripe_price_id_yearly
        except PricingPlan.DoesNotExist:
            return Response(
                {'error': 'Pricing plan not found'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not price_id:
            return Response(
                {'error': 'Stripe price not configured'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            checkout_session = stripe.checkout.Session.create(
                customer=user.stripe_customer_id,
                payment_method_types=['card'],
                line_items=[{
                    'price': price_id,
                    'quantity': 1,
                }],
                mode='subscription',
                success_url=success_url,
                cancel_url=cancel_url,
                metadata={'user_id': str(user.id)}
            )
            
            return Response({
                'checkout_url': checkout_session.url,
                'session_id': checkout_session.id
            })
            
        except stripe.error.StripeError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class CustomerPortalView(APIView):
    """Create Stripe customer portal session."""
    
    def post(self, request):
        serializer = CustomerPortalSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = request.user
        
        if not user.stripe_customer_id:
            return Response(
                {'error': 'No subscription found'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            portal_session = stripe.billing_portal.Session.create(
                customer=user.stripe_customer_id,
                return_url=serializer.validated_data['return_url']
            )
            
            return Response({
                'portal_url': portal_session.url
            })
            
        except stripe.error.StripeError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class CancelSubscriptionView(APIView):
    """Cancel subscription at end of period."""
    
    def post(self, request):
        user = request.user
        
        try:
            subscription = Subscription.objects.get(user=user)
        except Subscription.DoesNotExist:
            return Response(
                {'error': 'No subscription found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        if not subscription.stripe_subscription_id:
            return Response(
                {'error': 'No active subscription'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            stripe.Subscription.modify(
                subscription.stripe_subscription_id,
                cancel_at_period_end=True
            )
            
            subscription.cancel_at_period_end = True
            subscription.cancelled_at = timezone.now()
            subscription.save()
            
            return Response({
                'message': 'Subscription will be cancelled at the end of the billing period',
                'subscription': SubscriptionSerializer(subscription).data
            })
            
        except stripe.error.StripeError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class ResumeSubscriptionView(APIView):
    """Resume a cancelled subscription."""
    
    def post(self, request):
        user = request.user
        
        try:
            subscription = Subscription.objects.get(user=user)
        except Subscription.DoesNotExist:
            return Response(
                {'error': 'No subscription found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        if not subscription.stripe_subscription_id:
            return Response(
                {'error': 'No active subscription'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            stripe.Subscription.modify(
                subscription.stripe_subscription_id,
                cancel_at_period_end=False
            )
            
            subscription.cancel_at_period_end = False
            subscription.cancelled_at = None
            subscription.save()
            
            return Response({
                'message': 'Subscription resumed',
                'subscription': SubscriptionSerializer(subscription).data
            })
            
        except stripe.error.StripeError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class StripeWebhookView(APIView):
    """Handle Stripe webhooks."""
    
    permission_classes = [AllowAny]
    
    def post(self, request):
        payload = request.body
        sig_header = request.META.get('HTTP_STRIPE_SIGNATURE')
        
        try:
            event = stripe.Webhook.construct_event(
                payload, sig_header, settings.STRIPE_WEBHOOK_SECRET
            )
        except ValueError:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        except stripe.error.SignatureVerificationError:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
        # Handle events
        if event['type'] == 'checkout.session.completed':
            self.handle_checkout_completed(event['data']['object'])
        elif event['type'] == 'customer.subscription.updated':
            self.handle_subscription_updated(event['data']['object'])
        elif event['type'] == 'customer.subscription.deleted':
            self.handle_subscription_deleted(event['data']['object'])
        elif event['type'] == 'invoice.paid':
            self.handle_invoice_paid(event['data']['object'])
        elif event['type'] == 'invoice.payment_failed':
            self.handle_payment_failed(event['data']['object'])
        
        return Response(status=status.HTTP_200_OK)
    
    def handle_checkout_completed(self, session):
        from apps.users.models import User
        
        user_id = session.get('metadata', {}).get('user_id')
        subscription_id = session.get('subscription')
        
        if user_id and subscription_id:
            try:
                user = User.objects.get(id=user_id)
                stripe_sub = stripe.Subscription.retrieve(subscription_id)
                
                subscription, created = Subscription.objects.get_or_create(user=user)
                subscription.stripe_subscription_id = subscription_id
                subscription.status = Subscription.Status.ACTIVE
                subscription.plan = Subscription.Plan.PRO_MONTHLY  # Determine from price
                subscription.current_period_start = timezone.datetime.fromtimestamp(
                    stripe_sub.current_period_start,
                    tz=timezone.utc
                )
                subscription.current_period_end = timezone.datetime.fromtimestamp(
                    stripe_sub.current_period_end,
                    tz=timezone.utc
                )
                subscription.save()
                
                user.subscription_tier = 'pro'
                user.subscription_expires_at = subscription.current_period_end
                user.save()
                
            except User.DoesNotExist:
                pass
    
    def handle_subscription_updated(self, stripe_sub):
        try:
            subscription = Subscription.objects.get(
                stripe_subscription_id=stripe_sub['id']
            )
            
            subscription.status = stripe_sub['status']
            subscription.current_period_start = timezone.datetime.fromtimestamp(
                stripe_sub['current_period_start'],
                tz=timezone.utc
            )
            subscription.current_period_end = timezone.datetime.fromtimestamp(
                stripe_sub['current_period_end'],
                tz=timezone.utc
            )
            subscription.cancel_at_period_end = stripe_sub.get('cancel_at_period_end', False)
            subscription.save()
            
            subscription.user.subscription_expires_at = subscription.current_period_end
            subscription.user.save()
            
        except Subscription.DoesNotExist:
            pass
    
    def handle_subscription_deleted(self, stripe_sub):
        try:
            subscription = Subscription.objects.get(
                stripe_subscription_id=stripe_sub['id']
            )
            
            subscription.status = Subscription.Status.EXPIRED
            subscription.plan = Subscription.Plan.FREE
            subscription.save()
            
            subscription.user.subscription_tier = 'free'
            subscription.user.subscription_expires_at = None
            subscription.user.save()
            
        except Subscription.DoesNotExist:
            pass
    
    def handle_invoice_paid(self, invoice):
        customer_id = invoice.get('customer')
        
        from apps.users.models import User
        
        try:
            user = User.objects.get(stripe_customer_id=customer_id)
            
            Payment.objects.create(
                user=user,
                stripe_invoice_id=invoice['id'],
                amount=invoice['amount_paid'] / 100,
                currency=invoice['currency'],
                status=Payment.Status.SUCCEEDED,
                description=invoice.get('description', 'Subscription payment'),
                receipt_url=invoice.get('hosted_invoice_url', '')
            )
            
        except User.DoesNotExist:
            pass
    
    def handle_payment_failed(self, invoice):
        customer_id = invoice.get('customer')
        
        from apps.users.models import User
        
        try:
            user = User.objects.get(stripe_customer_id=customer_id)
            
            Payment.objects.create(
                user=user,
                stripe_invoice_id=invoice['id'],
                amount=invoice['amount_due'] / 100,
                currency=invoice['currency'],
                status=Payment.Status.FAILED,
                description='Payment failed'
            )
            
            # Update subscription status
            try:
                subscription = Subscription.objects.get(user=user)
                subscription.status = Subscription.Status.PAST_DUE
                subscription.save()
            except Subscription.DoesNotExist:
                pass
            
        except User.DoesNotExist:
            pass
