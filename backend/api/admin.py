from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from api.models import (
    User,
    Mood,
    MoodEntry,
    FeelingTag,
    Place,
    VisitedPlace,
    FavouritePlace,
    Category,
    Activity,
    ActivityCategory,
    FavouriteActivity,
)


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ("email", "username", "age", "gender", "premium", "is_staff")
    list_filter = ("gender", "premium", "is_staff", "is_superuser")
    search_fields = ("email", "username")
    ordering = ("email",)

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

    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "username", "password1", "password2"),
            },
        ),
    )


@admin.register(Mood)
class MoodAdmin(admin.ModelAdmin):
    list_display = ("label", "id")
    search_fields = ("label",)
    ordering = ("label",)


@admin.register(MoodEntry)
class MoodEntryAdmin(admin.ModelAdmin):
    list_display = ("user", "mood", "submitted_at")
    list_filter = ("mood", "submitted_at")
    search_fields = ("user__email", "mood__label")
    ordering = ("-submitted_at",)


@admin.register(FeelingTag)
class FeelingTagAdmin(admin.ModelAdmin):
    list_display = ("label", "id")
    search_fields = ("label",)
    ordering = ("label",)


@admin.register(Place)
class PlaceAdmin(admin.ModelAdmin):
    list_display = ("label", "category", "latitude", "longitude")
    list_filter = ("category",)
    search_fields = ("label", "category__verbose_label")
    ordering = ("label",)


@admin.register(VisitedPlace)
class VisitedPlaceAdmin(admin.ModelAdmin):
    list_display = ("user", "place", "visited_time", "mood_feedback")
    list_filter = ("visited_time", "mood_feedback")
    search_fields = ("user__email", "place__label")
    ordering = ("-visited_time",)


@admin.register(FavouritePlace)
class FavouritePlaceAdmin(admin.ModelAdmin):
    list_display = ("user", "place", "added_at")
    list_filter = ("added_at",)
    search_fields = ("user__email", "place__label")
    ordering = ("-added_at",)


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ("verbose_label", "slug")
    search_fields = ("verbose_label", "slug")
    ordering = ("verbose_label",)


@admin.register(Activity)
class ActivityAdmin(admin.ModelAdmin):
    list_display = ("name", "category", "duration")
    list_filter = ("category", "duration")
    search_fields = ("name", "category__verbose_label")
    ordering = ("name",)


@admin.register(ActivityCategory)
class ActivityCategoryAdmin(admin.ModelAdmin):
    list_display = ("verbose_label", "slug")
    search_fields = ("verbose_label", "slug")
    ordering = ("verbose_label",)


@admin.register(FavouriteActivity)
class FavouriteActivityAdmin(admin.ModelAdmin):
    list_display = ("user", "activity", "added_at")
    list_filter = ("added_at",)
    search_fields = ("user__email", "activity__name")
    ordering = ("-added_at",)
