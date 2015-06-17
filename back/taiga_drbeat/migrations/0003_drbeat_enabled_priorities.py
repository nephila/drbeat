# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('taiga_drbeat', '0002_auto_20150616_1715'),
    ]

    operations = [
        migrations.AddField(
            model_name='drbeat',
            name='enabled_priorities',
            field=models.CharField(default='', max_length=300, verbose_name='Enabled priorities'),
            preserve_default=True,
        ),
    ]
