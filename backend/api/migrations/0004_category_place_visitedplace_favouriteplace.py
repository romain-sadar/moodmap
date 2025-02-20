# Generated by Django 5.1.6 on 2025-02-18 07:07

import django.db.models.deletion
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("api", "0003_mood"),
    ]

    operations = [
        migrations.CreateModel(
            name="Category",
            fields=[
                (
                    "id",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="id",
                    ),
                ),
                ("slug", models.SlugField(unique=True)),
                ("verbose_label", models.CharField(max_length=255)),
            ],
            options={
                "verbose_name": "Category",
                "verbose_name_plural": "Categories",
            },
        ),
        migrations.CreateModel(
            name="Place",
            fields=[
                (
                    "id",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="id",
                    ),
                ),
                ("label", models.CharField(max_length=255, verbose_name="Name")),
                ("latitude", models.FloatField()),
                ("longitude", models.FloatField()),
                ("address", models.TextField()),
                ("description", models.TextField(blank=True, null=True)),
                (
                    "photo",
                    models.ImageField(blank=True, null=True, upload_to="place_photos/"),
                ),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                (
                    "category",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="place",
                        to="api.category",
                    ),
                ),
                (
                    "moods",
                    models.ManyToManyField(
                        blank=True, related_name="places", to="api.mood"
                    ),
                ),
            ],
            options={
                "verbose_name": "Place",
                "verbose_name_plural": "Places",
            },
        ),
        migrations.CreateModel(
            name="VisitedPlace",
            fields=[
                (
                    "id",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="id",
                    ),
                ),
                ("visited_time", models.DateTimeField()),
                (
                    "mood_feedback",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="visited_places",
                        to="api.mood",
                    ),
                ),
                (
                    "place",
                    models.ManyToManyField(related_name="visits", to="api.place"),
                ),
                (
                    "user",
                    models.ManyToManyField(
                        related_name="visited_places", to=settings.AUTH_USER_MODEL
                    ),
                ),
            ],
            options={
                "verbose_name": "Visited Place",
                "verbose_name_plural": "Visited Places",
            },
        ),
        migrations.CreateModel(
            name="FavouritePlace",
            fields=[
                (
                    "id",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="id",
                    ),
                ),
                ("added_at", models.DateTimeField(auto_now_add=True)),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="favourite_places",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "place",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="favourites",
                        to="api.place",
                    ),
                ),
            ],
            options={
                "verbose_name": "Favourite Place",
                "verbose_name_plural": "Favourite Places",
                "unique_together": {("user", "place")},
            },
        ),
    ]
