#!/usr/bin/env bash

# sync down qwprogs
aws s3 sync --no-sign-request s3://fortressone-dats /updater/dats/

# sync down assets
aws s3 sync --no-sign-request s3://map-repo /updater/map-repo/

# sync up demos
if [ ! -z "${AWS_SECRET_ACCESS_KEY}" ] && [ ! -z "${AWS_ACCESS_KEY_ID}" ] && [ ! -z "${S3_URI}" ]; then
  aws s3 sync /updater/demos/ "${S3_URI}"
fi
