# Generated by Django 5.1.6 on 2025-02-18 07:55

from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("api", "0006_merge_20250218_0710"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="place",
            name="address",
        ),
    ]
