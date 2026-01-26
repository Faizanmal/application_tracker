'use client';

import { useState } from 'react';
import { format, parseISO } from 'date-fns';
import {
  CreditCard,
  Check,
  Zap,
  Loader2,
  Download,
  AlertCircle,
  Crown,
  Sparkles,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import { 
  useSubscription, 
  useCreateCheckoutSession,
  useCreatePortalSession,
  useCancelSubscription,
} from '@/hooks/use-queries';
import { useIsPro, useApplicationLimit } from '@/lib/auth';

const PLANS = [
  {
    id: 'free',
    name: 'Free',
    price: 0,
    billing: 'forever',
    description: 'Get started with job tracking',
    features: [
      '25 active applications',
      '3 resume uploads',
      'Basic analytics',
      'Email reminders',
      'Kanban board',
    ],
    limitations: [
      'No AI features',
      'No priority support',
      'Limited export options',
    ],
  },
  {
    id: 'pro_monthly',
    name: 'Pro',
    price: 9.99,
    billing: 'month',
    description: 'Everything you need to land your dream job',
    features: [
      'Unlimited applications',
      'Unlimited resume uploads',
      'Advanced analytics & insights',
      'AI-powered follow-up emails',
      'AI resume matching',
      'AI interview questions',
      'Export to CSV/JSON',
      'Priority support',
      'Custom tags & categories',
    ],
    popular: true,
  },
  {
    id: 'pro_yearly',
    name: 'Pro (Annual)',
    price: 79.99,
    billing: 'year',
    description: 'Save 33% with annual billing',
    features: [
      'All Pro features',
      '2 months free',
      'Early access to new features',
    ],
    savings: 40,
  },
];

function PlanCard({
  plan,
  isCurrentPlan,
  onSelect,
  isLoading,
}: {
  plan: typeof PLANS[0];
  isCurrentPlan: boolean;
  onSelect: () => void;
  isLoading?: boolean;
}) {
  return (
    <Card className={`relative ${plan.popular ? 'border-primary ring-2 ring-primary' : ''}`}>
      {plan.popular && (
        <div className="absolute -top-3 left-1/2 -translate-x-1/2">
          <Badge className="bg-primary">
            <Sparkles className="mr-1 h-3 w-3" />
            Most Popular
          </Badge>
        </div>
      )}
      {plan.savings && (
        <div className="absolute -top-3 left-1/2 -translate-x-1/2">
          <Badge className="bg-green-600">
            Save ${plan.savings}/year
          </Badge>
        </div>
      )}
      <CardHeader className="pt-8">
        <CardTitle className="flex items-center gap-2">
          {plan.name}
          {plan.id !== 'free' && <Crown className="h-4 w-4 text-yellow-500" />}
        </CardTitle>
        <div className="mt-2">
          <span className="text-3xl font-bold">${plan.price}</span>
          <span className="text-muted-foreground">/{plan.billing}</span>
        </div>
        <CardDescription>{plan.description}</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <ul className="space-y-2">
          {plan.features.map((feature) => (
            <li key={feature} className="flex items-center gap-2 text-sm">
              <Check className="h-4 w-4 text-green-600 flex-shrink-0" />
              {feature}
            </li>
          ))}
        </ul>
        {plan.limitations && (
          <>
            <Separator />
            <ul className="space-y-2">
              {plan.limitations.map((limitation) => (
                <li key={limitation} className="flex items-center gap-2 text-sm text-muted-foreground">
                  <AlertCircle className="h-4 w-4 flex-shrink-0" />
                  {limitation}
                </li>
              ))}
            </ul>
          </>
        )}
      </CardContent>
      <CardFooter>
        <Button 
          className="w-full" 
          variant={isCurrentPlan ? 'outline' : plan.popular ? 'default' : 'secondary'}
          onClick={onSelect}
          disabled={isCurrentPlan || isLoading}
        >
          {isLoading ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : isCurrentPlan ? (
            'Current Plan'
          ) : plan.id === 'free' ? (
            'Downgrade'
          ) : (
            <>
              <Zap className="mr-2 h-4 w-4" />
              Upgrade
            </>
          )}
        </Button>
      </CardFooter>
    </Card>
  );
}

export default function BillingSettingsPage() {
  const [cancelDialogOpen, setCancelDialogOpen] = useState(false);
  const { data: subscription, isLoading: _subscriptionLoading } = useSubscription();
  const createCheckout = useCreateCheckoutSession();
  const createPortal = useCreatePortalSession();
  const cancelSubscription = useCancelSubscription();
  const isPro = useIsPro();
  const { limit, used } = useApplicationLimit();

  const currentPlanId = subscription?.stripe_price_id || 'free';

  const handleSelectPlan = async (planId: string) => {
    if (planId === 'free') {
      setCancelDialogOpen(true);
      return;
    }

    try {
      const { checkout_url: url } = await createCheckout.mutateAsync(planId);
      window.location.assign(url);
    } catch (error) {
      console.error('Failed to create checkout session:', error);
    }
  };

  const handleManageSubscription = async () => {
    try {
      const { portal_url: url } = await createPortal.mutateAsync();
      window.location.href = url;
    } catch (error) {
      console.error('Failed to create portal session:', error);
    }
  };

  const handleCancelSubscription = async () => {
    try {
      await cancelSubscription.mutateAsync();
      setCancelDialogOpen(false);
    } catch (error) {
      console.error('Failed to cancel subscription:', error);
    }
  };

  return (
    <div className="space-y-6">
      {/* Current Subscription */}
      <Card>
        <CardHeader>
          <CardTitle>Current Subscription</CardTitle>
          <CardDescription>
            Manage your subscription and billing details
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex items-center justify-between p-4 rounded-lg bg-muted">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-full bg-primary/10">
                {isPro ? (
                  <Crown className="h-6 w-6 text-primary" />
                ) : (
                  <CreditCard className="h-6 w-6 text-muted-foreground" />
                )}
              </div>
              <div>
                <h3 className="font-semibold text-lg">
                  {isPro ? 'Pro Plan' : 'Free Plan'}
                </h3>
                {subscription?.current_period_end && (
                  <p className="text-sm text-muted-foreground">
                    {subscription.cancel_at_period_end
                      ? `Cancels on ${format(parseISO(subscription.current_period_end), 'MMM d, yyyy')}`
                      : `Renews on ${format(parseISO(subscription.current_period_end), 'MMM d, yyyy')}`
                    }
                  </p>
                )}
              </div>
            </div>
            {isPro && (
              <Button variant="outline" onClick={handleManageSubscription}>
                Manage Subscription
              </Button>
            )}
          </div>

          {/* Usage */}
          <div>
            <h4 className="font-medium mb-3">Current Usage</h4>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="p-4 rounded-lg border">
                <p className="text-sm text-muted-foreground">Applications</p>
                <p className="text-2xl font-bold">
                  {used} <span className="text-lg text-muted-foreground">/ {limit === Infinity ? '∞' : limit}</span>
                </p>
              </div>
              <div className="p-4 rounded-lg border">
                <p className="text-sm text-muted-foreground">AI Credits Used</p>
                <p className="text-2xl font-bold">
                  0 <span className="text-lg text-muted-foreground">/ {isPro ? '∞' : '0'}</span>
                </p>
              </div>
            </div>
          </div>

          {subscription?.cancel_at_period_end && (
            <div className="flex items-center gap-3 p-4 rounded-lg bg-yellow-50 border border-yellow-200">
              <AlertCircle className="h-5 w-5 text-yellow-600" />
              <div className="flex-1">
                <p className="font-medium text-yellow-800">
                  Your subscription is scheduled to cancel
                </p>
                <p className="text-sm text-yellow-700">
                  You&apos;ll lose access to Pro features after {format(parseISO(subscription.current_period_end || ''), 'MMMM d, yyyy')}
                </p>
              </div>
              <Button variant="outline" size="sm" onClick={handleManageSubscription}>
                Resume
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Plans */}
      <div>
        <h2 className="text-xl font-semibold mb-4">Available Plans</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {PLANS.map((plan) => (
            <PlanCard
              key={plan.id}
              plan={plan}
              isCurrentPlan={
                (plan.id === 'free' && !isPro) ||
                (plan.id !== 'free' && isPro && currentPlanId.includes(plan.id.replace('pro_', '')))
              }
              onSelect={() => handleSelectPlan(plan.id)}
              isLoading={createCheckout.isPending}
            />
          ))}
        </div>
      </div>

      {/* Payment History */}
      {isPro && (
        <Card>
          <CardHeader>
            <CardTitle>Payment History</CardTitle>
            <CardDescription>
              View and download your invoices
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {/* Mock payment history - would come from API */}
              <div className="flex items-center justify-between p-4 rounded-lg border">
                <div>
                  <p className="font-medium">Pro Subscription</p>
                  <p className="text-sm text-muted-foreground">
                    {format(new Date(), 'MMM d, yyyy')}
                  </p>
                </div>
                <div className="flex items-center gap-4">
                  <span className="font-medium">$9.99</span>
                  <Badge variant="outline" className="text-green-600">Paid</Badge>
                  <Button variant="ghost" size="icon">
                    <Download className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Cancel Subscription Dialog */}
      <AlertDialog open={cancelDialogOpen} onOpenChange={setCancelDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Cancel Subscription</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to cancel your Pro subscription? You&apos;ll lose access to:
              <ul className="mt-4 space-y-2">
                <li className="flex items-center gap-2">
                  <AlertCircle className="h-4 w-4 text-yellow-500" />
                  Unlimited applications
                </li>
                <li className="flex items-center gap-2">
                  <AlertCircle className="h-4 w-4 text-yellow-500" />
                  AI-powered features
                </li>
                <li className="flex items-center gap-2">
                  <AlertCircle className="h-4 w-4 text-yellow-500" />
                  Advanced analytics
                </li>
              </ul>
              <p className="mt-4">
                Your subscription will remain active until the end of your current billing period.
              </p>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Keep Subscription</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleCancelSubscription}
              className="bg-red-600 hover:bg-red-700"
            >
              {cancelSubscription.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : null}
              Cancel Subscription
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
