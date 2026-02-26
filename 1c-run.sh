#!/bin/sh
##
mkdir 1c-lic
mkdir 1c-data
chmod a+w 1c-*
docker-compose up -d
exit 0
