# Register your models here.
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from api.models import User, Mood


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    # Customize the fields displayed in the admin list view
    list_display = ("email", "username", "age", "gender", "premium", "is_staff")
    # Add filters for the admin list view
    list_filter = ("gender", "premium", "is_staff", "is_superuser")
    # Define the fieldsets for the user detail page in the admin
    fieldsets = (
        (None, {"fields": ("email", "username", "password")}),
        ("Personal Info", {"fields": ("age", "gender")}),
        (
            "Permissions",
            {"fields": ("is_staff", "is_superuser", "groups", "user_permissions")},
        ),
        ("Important dates", {"fields": ("last_login", "date_joined")}),
        ("Premium", {"fields": ("premium",)}),
    )
    # Define the fieldsets for adding a new user in the admin
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "username", "password1", "password2"),
            },
        ),
    )
    # Default ordering for the list view
    ordering = ("email",)


@admin.register(Mood)
class MoodAdmin(admin.ModelAdmin):
    # Customize the fields displayed in the admin list view
    list_display = ("label", "id")
    # Enable search functionality
    search_fields = ("label",)
    # Default ordering for the list view
    ordering = ("label",)
