# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('projects', '0021_auto_20150504_1524'),
    ]

    operations = [
        migrations.CreateModel(
            name='DrBeat',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('enabled', models.BooleanField(default=False)),
                ('project', models.ForeignKey(to='projects.Project', related_name='drbeat')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
