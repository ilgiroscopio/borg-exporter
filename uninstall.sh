#!/usr/bin/env bash
rm ~/.borgexporterconfig
rm /usr/local/bin/borg-exporter.sh
systemctl disable borg-exporter.timer
systemctl stop borg-exporter.timer
rm /etc/systemd/system/borg-exporter.timer
rm /etc/systemd/system/borg-exporter.service

echo "Uninstalled"