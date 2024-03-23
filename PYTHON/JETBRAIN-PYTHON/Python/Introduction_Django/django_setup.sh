#bin/bash

mkvirtualenv new_django_env
pip install Django==4.0
django-admin startproject store
cd store
django-admin startapp blog