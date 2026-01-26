from rest_framework import serializers
from .models import Subscription, Payment, PricingPlan


class SubscriptionSerializer(serializers.ModelSerializer):
    """Serializer for subscription."""
    
    class Meta:
        model = Subscription
        fields = [
            'id', 'plan', 'status', 'current_period_start', 'current_period_end',
            'cancel_at_period_end', 'cancelled_at', 'trial_start', 'trial_end',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class PaymentSerializer(serializers.ModelSerializer):
    """Serializer for payments."""
    
    class Meta:
        model = Payment
        fields = [
            'id', 'amount', 'currency', 'status', 'description',
            'receipt_url', 'created_at'
        ]


class PricingPlanSerializer(serializers.ModelSerializer):
    """Serializer for pricing plans."""
    
    class Meta:
        model = PricingPlan
        fields = [
            'id', 'name', 'slug', 'price_monthly', 'price_yearly',
            'currency', 'features', 'application_limit',
            'is_active', 'is_popular'
        ]


class CreateCheckoutSessionSerializer(serializers.Serializer):
    """Serializer for creating checkout session."""
    
    plan = serializers.ChoiceField(choices=['pro_monthly', 'pro_yearly'])
    success_url = serializers.URLField()
    cancel_url = serializers.URLField()


class CustomerPortalSerializer(serializers.Serializer):
    """Serializer for customer portal."""
    
    return_url = serializers.URLField()
