#!/usr/bin/env bash

if [ ! -z "${AWS_SECRET_ACCESS_KEY}" ] && [ ! -z "${AWS_ACCESS_KEY_ID}" ]; then
  # sync up stats
  if [ ! -z "${S3_STATS_URI}" ]; then
    # Iterate over the subdirectories within /updater/stats/
    for subdir in /updater/stats/*; do
      if [[ -d "$subdir" ]]; then
        # Iterate over the JSON files in each subdirectory
        for file in "$subdir"/*.json; do
          if [[ -e "$file" ]]; then
            filename=$(basename "$file")
            subdir_name=$(basename "$subdir")

            if /usr/local/bin/aws s3 cp "$file" "$S3_STATS_URI/$FO_REGION/$subdir_name/$filename"; then
              echo "$FO_STATS_FILES_ADDRESS/notify/$FO_REGION/$subdir_name/$filename synced"
              curl "$FO_STATS_FILES_ADDRESS/notify/$FO_REGION/$subdir_name/$filename"
            else
              echo "Error syncing $file"
            fi
          else
            echo "No JSON files found in $subdir/"
            break
          fi
        done
      fi
    done

    # delete stats older than a week
    find /updater/stats/ -name "*.json" -type f -mtime +6 -delete
  fi

  # sync up demos and delete demos older than a week
  if [ ! -z "${S3_DEMO_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/demos/ "${S3_DEMO_URI}/${FO_REGION}/" \
      && find /updater/demos/ \( -name "*.mvd" -o -name "*.gz" \) -type f -mtime +6 -delete
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
