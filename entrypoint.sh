#!/usr/bin/env bash

printenv | grep -v "no_proxy" >> /etc/environment
source sync.sh
aws configure set default.s3.max_concurrent_requests 1
aws configure set default.s3.max_bandwidth 100KB/s
cron -f
