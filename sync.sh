#!/usr/bin/env bash

# sync down qwprogs
aws s3 sync s3://fortressone-dats /updater/dats/

# sync down assets
aws s3 sync s3://map-repo /updater/map-repo/

# sync up demos
aws s3 sync /updater/demos/ s3://fortressone-demos/${FO_REGION}/
