#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from setuptools import setup, find_packages

setup(
    name = 'taiga-drbeat',
    version = "0.0.0",
    description = "The Taiga Dr.Beat plugin",
    long_description = "",
    keywords = 'taiga, emergency, issues',
    author = 'Andrea Stagi',
    author_email = 'a.stagi@nephila.it',
    url = 'https://github.com/',
    license = 'AGPL',
    include_package_data = True,
    packages = find_packages(),
    install_requires=[
        'django >= 1.7',
    ],
    setup_requires = [
        'versiontools >= 1.8',
        'celery-redis-unixsocket == 0.3'
    ],
    classifiers = [
        "Programming Language :: Python",
        'Development Status :: 4 - Beta',
        'Framework :: Django',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU Affero General Public License v3',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP',
    ]
)
