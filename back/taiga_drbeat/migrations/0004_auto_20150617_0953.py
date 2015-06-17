# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('taiga_drbeat', '0003_drbeat_enabled_priorities'),
    ]

    operations = [
        migrations.AddField(
            model_name='drbeat',
            name='hour',
            field=models.IntegerField(default=7),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='drbeat',
            name='enabled_priorities',
            field=models.CharField(max_length=300, default='', blank=True, verbose_name='Enabled priorities'),
            preserve_default=True,
        ),
    ]
