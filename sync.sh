#!/usr/bin/env bash

# update qwprogs from latest github release
aws s3 sync s3://fortressone-dats /updater/dats/

# update maps/progs/sounds/lits etc from amazon s3
aws s3 sync s3://map-repo /updater/map-repo/
