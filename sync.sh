#!/usr/bin/env bash

# sync down qwprogs
/usr/local/bin/aws s3 sync --no-sign-request s3://fortressone-dats /updater/dats/

# sync down assets
/usr/local/bin/aws s3 sync --no-sign-request s3://map-repo /updater/map-repo/

if [ ! -z "${AWS_SECRET_ACCESS_KEY}" ] && [ ! -z "${AWS_ACCESS_KEY_ID}" ]; then
  # sync up demos and delete demos older than 24 hours
  if [ ! -z "${S3_DEMO_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/demos/ "${S3_DEMO_URI}" && find . -name "*.mvd" -type f -mtime +0 -delete
  fi

  # sync up stats and delete stats older than 24 hours
  if [ ! -z "${S3_STATS_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/stats/ "${S3_STATS_URI}" && find . -name "*.json" -type f -mtime +0 -delete
  fi
fi
