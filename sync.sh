#!/usr/bin/env bash
set -e
set -o pipefail

url_encode() {
    local encoded=""
    local char=""
    for (( i = 0; i < ${#1}; i++ )); do
        char="${1:$i:1}"
        if [[ "$char" =~ [a-zA-Z0-9.~_-] ]]; then
            encoded+="$char"
        else
            printf -v hex '%02X' "'$char"
            encoded+="%$hex"
        fi
    done
    echo "$encoded"
}

if [ -n "${AWS_SECRET_ACCESS_KEY}" ] && [ -n "${AWS_ACCESS_KEY_ID}" ] && [ -n "${FO_REGION}" ]; then
  if [ -n "${S3_STATS_URI}" ]; then
    for subdir in /updater/stats/*; do
      if [[ -d "$subdir" ]]; then
        for file in "$subdir"/*.json; do
          [ -e "$file" ] || continue
          filename=$(basename "$file")
          subdir_name=$(basename "$subdir")

          if /usr/local/bin/aws s3 cp "$file" "$S3_STATS_URI/$FO_REGION/$subdir_name/$filename"; then
            rm $file

            # Notify haze stats
            if [ -n "${FO_STATS_FILES_ADDRESS}" ]; then
              curl "$FO_STATS_FILES_ADDRESS/notify/$FO_REGION/$subdir_name/$(url_encode "$filename")"
              echo "$FO_STATS_FILES_ADDRESS/notify/$FO_REGION/$subdir_name/$(url_encode "$filename")" notification sent
            fi
          else
            echo "Error syncing to $S3_STATS_URI/$FO_REGION/$subdir_name/$filename"
          fi
        done
      fi
    done
  fi

  if [ -n "${S3_DEMO_URI}" ]; then
    /usr/local/bin/aws s3 sync /updater/demos/ "${S3_DEMO_URI}/${FO_REGION}/" \
      && find /updater/demos/ \( -name "*.mvd" -o -name "*.gz" \) -type f -mtime +6 -delete 2>/dev/null
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

# sync down maps
/usr/local/bin/aws s3 sync \
  --size-only \
  --no-sign-request \
  --cli-read-timeout 600 \
  --cli-connect-timeout 600 \
  s3://fortressone-package \
  /updater/map-repo/fortress/maps/
