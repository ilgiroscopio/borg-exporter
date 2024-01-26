#!/usr/bin/env bash
cp .borgexporterconfig ~/.borgexporterconfig
cp borg-exporter.sh /usr/local/bin
cp borg-exporter.timer /etc/systemd/system
cp borg-exporter.service /etc/systemd/system
systemctl enable borg-exporter.timer
systemctl start borg-exporter.timer

echo "Installed"
echo "Now edit the config file in ~/.borgexporterconfig"