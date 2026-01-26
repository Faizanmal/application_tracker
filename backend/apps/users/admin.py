from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, UserProfile, Resume, PasswordResetToken, EmailVerificationToken


class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'Profile'


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['email', 'first_name', 'last_name', 'subscription_tier', 'is_verified', 'is_active', 'date_joined']
    list_filter = ['subscription_tier', 'is_verified', 'is_active', 'is_staff', 'date_joined']
    search_fields = ['email', 'first_name', 'last_name']
    ordering = ['-date_joined']
    
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Info', {'fields': ('first_name', 'last_name', 'avatar')}),
        ('OAuth', {'fields': ('google_id', 'github_id')}),
        ('Subscription', {'fields': ('subscription_tier', 'stripe_customer_id', 'subscription_expires_at')}),
        ('Preferences', {'fields': ('email_notifications', 'push_notifications', 'user_timezone')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'is_verified', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )
    
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2'),
        }),
    )
    
    inlines = [UserProfileInline]


@admin.register(Resume)
class ResumeAdmin(admin.ModelAdmin):
    list_display = ['name', 'user', 'version', 'is_default', 'created_at']
    list_filter = ['is_default', 'created_at']
    search_fields = ['name', 'user__email']


@admin.register(PasswordResetToken)
class PasswordResetTokenAdmin(admin.ModelAdmin):
    list_display = ['user', 'used', 'expires_at', 'created_at']
    list_filter = ['used', 'created_at']


@admin.register(EmailVerificationToken)
class EmailVerificationTokenAdmin(admin.ModelAdmin):
    list_display = ['user', 'used', 'expires_at', 'created_at']
    list_filter = ['used', 'created_at']
