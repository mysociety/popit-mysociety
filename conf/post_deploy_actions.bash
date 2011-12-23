#!/bin/bash

# abort on any errors
set -e

# check that we are in the expected directory
cd `dirname $0`/..

# create the virtual environment, install/update required packages
# NOTE: some packages are difficult to install if they are not site packages,
# for example xapian. If using these you might want to remove the
# '--no-site-packages' argument.
virtualenv --no-site-packages ../popit-mysociety-virtualenv

source ../popit-mysociety-virtualenv/bin/activate

pip install \
    --requirement requirements.txt \
    --quiet

# make sure that there is no old code (the .py files may have been git deleted) 
find . -name '*.pyc' -delete

# go to the project directory for local config
cd ./example_popit_project

# get the database up to speed
./manage.py syncdb
./manage.py migrate

# gather all the static files in one place
./manage.py collectstatic --noinput

cd --
