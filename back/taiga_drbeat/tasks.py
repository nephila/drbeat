# Copyright (C) 2015 Nephila
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import requests
import logging

from celery.task import PeriodicTask
from datetime import datetime, timedelta
from django.utils import timezone

from django.conf import settings
from django.template import loader, Context
from djmail import template_mail

from taiga.base.api.renderers import UnicodeJSONRenderer
from taiga.projects.issues.models import Issue

from taiga.base.utils.db import get_typename_for_model_instance
from taiga.celery import app

from .models import DrBeat

logger = logging.getLogger(__name__)


class DrBeatTemplateEmail(template_mail.TemplateMail):
    name = "drbeat"


class PeriodicEmergenciesChecker(PeriodicTask):
    run_every = timedelta(
        seconds=3600
    )

    def run(self, **kwargs):
        now = timezone.now()
        drbeats = DrBeat.objects.filter(enabled=True)
        email = DrBeatTemplateEmail()

        for drbeat in drbeats:
            if not drbeat.enabled_priorities:
                continue
            if drbeat.hour <= now.hour <= drbeat.hour + 1 :
                issues = Issue.objects.filter(
                    project=drbeat.project,
                    priority__in=drbeat.enabled_priorities.split(','),
                    status__is_closed=False
                )
                email.send(drbeat.email, {"issues": issues})
