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
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []
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
    profile_picture = models.ImageField(
        upload_to="profile_pics/", null=True, blank=True
    )
    bio = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    premium = models.BooleanField(default=False)

    def __str__(self):
        return self.username

    class Meta:
        verbose_name = "User profile"
        constraints = [
            models.UniqueConstraint(fields=["email"], name="unique_email"),
        ]
