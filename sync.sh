#!/usr/bin/env bash

if [ ! -z "${AWS_SECRET_ACCESS_KEY}" ] && [ ! -z "${AWS_ACCESS_KEY_ID}" ]; then
  # sync up stats and delete stats older than a week
  if [ ! -z "${S3_STATS_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/stats/ "${S3_STATS_URI}" \
		&& find /updater/stats/ -name "*.json" -type f -mtime +6 -delete
  fi

  # sync up demos and delete demos older than a week
  if [ ! -z "${S3_DEMO_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/demos/ "${S3_DEMO_URI}" \
		&& find /updater/demos/ -name "*.mvd" -type f -mtime +6 -delete
  fi
fi

# sync down qwprogs
/usr/local/bin/aws s3 sync \
  --no-sign-request \
  --exact-timestamps \
  --cli-read-timeout 600 \
  --cli-connect-timeout 600 \
  s3://fortressone-dats \
  /updater/dats/

# sync down assets
/usr/local/bin/aws s3 sync \
  --size-only \
  --no-sign-request \
  --cli-read-timeout 600 \
  --cli-connect-timeout 600 \
  s3://fortressone-package \
  /updater/map-repo/fortress/maps/
