#!/usr/bin/env bash

printenv | grep -v "no_proxy" >> /etc/environment
source sync.sh
cron -f
