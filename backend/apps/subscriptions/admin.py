from django.contrib import admin
from .models import Subscription, Payment, PricingPlan


@admin.register(Subscription)
class SubscriptionAdmin(admin.ModelAdmin):
    list_display = ['user', 'plan', 'status', 'current_period_end', 'cancel_at_period_end']
    list_filter = ['plan', 'status', 'cancel_at_period_end']
    search_fields = ['user__email']


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['user', 'amount', 'currency', 'status', 'created_at']
    list_filter = ['status', 'currency', 'created_at']
    search_fields = ['user__email']
    ordering = ['-created_at']


@admin.register(PricingPlan)
class PricingPlanAdmin(admin.ModelAdmin):
    list_display = ['name', 'price_monthly', 'price_yearly', 'is_active', 'is_popular', 'display_order']
    list_filter = ['is_active', 'is_popular']
    prepopulated_fields = {'slug': ('name',)}
