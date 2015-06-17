# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('taiga_drbeat', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='drbeat',
            name='email',
            field=models.CharField(verbose_name='Email', max_length=200, default=''),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='drbeat',
            name='enabled',
            field=models.BooleanField(default=True),
            preserve_default=True,
        ),
    ]
