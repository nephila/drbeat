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

from django.db import models
from django.utils.translation import ugettext_lazy as _


class DrBeat(models.Model):
    project = models.ForeignKey("projects.Project", null=False, blank=False,
                                related_name="drbeat")
    enabled = models.BooleanField(default=True)
    email = models.CharField(null=False, blank=False,
        verbose_name=_("Email"), max_length=200, default='')
    enabled_priorities = models.CharField(null=False, blank=False,
        verbose_name=_("Enabled priorities"), max_length=300, default='')