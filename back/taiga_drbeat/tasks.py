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

from django.conf import settings
from django.template import loader, Context

from taiga.base.api.renderers import UnicodeJSONRenderer
from taiga.base.utils.db import get_typename_for_model_instance
from taiga.celery import app


logger = logging.getLogger(__name__)

from celery.task import PeriodicTask
from datetime import datetime, timedelta

class PeriodicEmergenciesChecker(PeriodicTask):
    run_every = timedelta(
        seconds=5
    )

    def run(self, **kwargs):
        print ('Dr.Beat sends an email!!!')
