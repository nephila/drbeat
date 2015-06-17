# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('taiga_drbeat', '0004_auto_20150617_0953'),
    ]

    operations = [
        migrations.AlterField(
            model_name='drbeat',
            name='hour',
            field=models.IntegerField(blank=True, verbose_name='Scheduled hours interval', default=7),
            preserve_default=True,
        ),
    ]
