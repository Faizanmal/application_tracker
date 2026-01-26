from django.urls import path
from . import views

app_name = 'subscriptions'

urlpatterns = [
    path('plans/', views.PricingPlanListView.as_view(), name='plans'),
    path('current/', views.SubscriptionView.as_view(), name='current'),
    path('payments/', views.PaymentHistoryView.as_view(), name='payments'),
    path('checkout/', views.CreateCheckoutSessionView.as_view(), name='checkout'),
    path('portal/', views.CustomerPortalView.as_view(), name='portal'),
    path('cancel/', views.CancelSubscriptionView.as_view(), name='cancel'),
    path('resume/', views.ResumeSubscriptionView.as_view(), name='resume'),
    path('webhook/', views.StripeWebhookView.as_view(), name='webhook'),
]
