#!/bin/bash

set -x

cd /src
cp -Rf * /srv/jekyll/
cat _config.yml |grep -v '^theme:' >/srv/jekyll/_config.yml
cd /srv/jekyll && jekyll build
