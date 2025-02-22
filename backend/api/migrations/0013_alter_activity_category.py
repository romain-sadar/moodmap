# Generated by Django 5.1.6 on 2025-02-20 06:55

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0012_activitycategory_activity'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activity',
            name='category',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='activities', to='api.activitycategory'),
        ),
    ]
