# Generated by Django 5.1.6 on 2025-02-18 03:50

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("api", "0003_mood"),
    ]

    operations = [
        migrations.AlterField(
            model_name="user",
            name="username",
            field=models.CharField(blank=True, max_length=150, null=True, unique=True),
        ),
    ]
