!#/usr/bin/env bash

docker build --tag=updater .
docker tag updater fortressone/updater:latest
docker push fortressone/updater:latest
