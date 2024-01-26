#!/usr/bin/env bash

source /etc/borg-exporter

ARCHIVES=$(BORG_PASSPHRASE="$BORG_PASSPHRASE" borg list "$BORG_REPO_NAME")
LATEST_ARCHIVE=$(BORG_PASSPHRASE="$BORG_PASSPHRASE" borg list --last 1 "$BORG_REPO_NAME")
INFO=$(BORG_PASSPHRASE="$BORG_PASSPHRASE" borg info "$BORG_REPO_NAME")

ARCHIVES_COUNT=$(echo "$ARCHIVES" | wc -l)

LATEST_ARCHIVE_DATE=$(echo "$LATEST_ARCHIVE" | awk -F ' ' '{print $3, $4}')
if [ "$(uname)" == "Linux" ]; then
    LATEST_ARCHIVE_TIMESTAMP=$(date -d "$LATEST_ARCHIVE_DATE" '+%s')
elif [ "$(uname)" == "Darwin" ] || [ "$(uname)" == "FreeBSD" ] || [ "$(uname)" == "NetBSD" ] || [ "$(uname)" == "OpenBSD" ]; then
    LATEST_ARCHIVE_TIMESTAMP=$(date -jf '%Y-%m-%d %H:%M:%S' "$LATEST_ARCHIVE_DATE" +%s)
else
    echo "Unsupported operating system."
    exit 1
fi

DEDUPLICATED_SIZE=$(echo "$INFO" | awk '/Deduplicated size/ { getline; print $7*1024*1024*1024 }')

{
  echo "borg_backups_total{repository='$BORG_REPO_NAME'} $ARCHIVES_COUNT"
  echo "borg_last_backup_timestamp{repository='$BORG_REPO_NAME'} $LATEST_ARCHIVE_TIMESTAMP"
  echo "borg_deduped_size{repository='$BORG_REPO_NAME'} $DEDUPLICATED_SIZE"
} >> "$COLLECTOR_DIR"/borg.prom