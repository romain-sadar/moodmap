import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser


class UUIDModel(models.Model):
    id = models.UUIDField(
        primary_key=True, default=uuid.uuid4, editable=False, verbose_name="id"
    )

    class Meta:
        abstract = True
        verbose_name = "modèle de base"
        verbose_name_plural = "modèles de base"


class User(UUIDModel, AbstractUser):
    GENDER_CHOICES = [
        ("M", "Male"),
        ("F", "Female"),
        ("O", "Other"),
        ("N", "Prefer not to say"),
    ]
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username"]
    username = models.CharField(max_length=150, unique=True, blank=True, null=True)
    groups = models.ManyToManyField(
        "auth.Group",
        related_name="custom_user_groups",
        blank=True,
    )
    user_permissions = models.ManyToManyField(
        "auth.Permission",
        related_name="custom_user_permissions",
        blank=True,
    )
    age = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    premium = models.BooleanField(default=False)
    gender = models.CharField(
        max_length=1,
        choices=GENDER_CHOICES,
        null=True,
        blank=True,
    )

    def __str__(self):
        return self.username

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        constraints = [
            models.UniqueConstraint(fields=["email"], name="unique_email"),
        ]


class Mood(UUIDModel):
    label = models.CharField(
        max_length=50,
        null=True,
        blank=True,
    )

    def __str__(self):
        return self.label

    class Meta:
        verbose_name = "Mood"
        verbose_name_plural = "Moods"


class MoodEntry(UUIDModel):
    user = models.ForeignKey(
        "User", on_delete=models.CASCADE, related_name="mood_entries"
    )
    mood = models.ForeignKey(
        "Mood", on_delete=models.CASCADE, related_name="mood_entries"
    )
    move_preference = models.CharField(
        max_length=10,
        choices=[("yes", "Yes, why not"), ("no", "No, I prefer not")],
        null=True,
        blank=True,
    )
    feelings = models.ManyToManyField(
        "FeelingTag", blank=True, related_name="mood_entries"
    )
    submitted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} felt {self.mood.label} on {self.submitted_at}"

    class Meta:
        verbose_name = "Mood Entry"
        verbose_name_plural = "Mood Entries"


class FeelingTag(UUIDModel):
    label = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.label


class Place(UUIDModel):
    label = models.CharField(max_length=255, verbose_name="Name")
    latitude = models.FloatField()
    longitude = models.FloatField()
    description = models.TextField(blank=True, null=True)
    category = models.ForeignKey(
        "Category", on_delete=models.CASCADE, related_name="place"
    )
    photo = models.ImageField(upload_to="place_photos/", blank=True, null=True)
    moods = models.ManyToManyField("Mood", related_name="places", blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.label

    class Meta:
        verbose_name = "Place"
        verbose_name_plural = "Places"


class VisitedPlace(UUIDModel):
    user = models.ForeignKey(
        "User",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="visited_places",
    )
    place = models.ForeignKey(
        "Place",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="visits",
    )
    visited_time = models.DateTimeField()
    mood_feedback = models.ForeignKey(
        "Mood",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="visited_places",
    )

    def __str__(self):
        return f"User {self.user.username} visited {self.place.label} at {self.visited_time}"

    class Meta:
        verbose_name = "Visited Place"
        verbose_name_plural = "Visited Places"


class FavouritePlace(UUIDModel):
    user = models.ForeignKey(
        "User", on_delete=models.CASCADE, related_name="favourite_places"
    )
    place = models.ForeignKey(
        "Place", on_delete=models.CASCADE, related_name="favourites"
    )
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username}'s favourite: {self.place.label}"

    class Meta:
        verbose_name = "Favourite Place"
        verbose_name_plural = "Favourite Places"
        unique_together = ("user", "place")


class Category(UUIDModel):
    slug = models.SlugField(unique=True)
    verbose_label = models.CharField(max_length=255)

    def __str__(self):
        return self.verbose_label

    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"
