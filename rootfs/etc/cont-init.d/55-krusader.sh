#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure some directories are created.
mkdir -p "$XDG_CONFIG_HOME"

# Install default config if needed.
[ -f "$XDG_CONFIG_HOME"/krusaderrc ] || cp -v /defaults/krusaderrc "$XDG_CONFIG_HOME"/

# Upgrade the config file if needed.
if ! grep -q "^unrar=" "$XDG_CONFIG_HOME"/krusaderrc; then
    sed -i '/^unarj=/a unrar=\/usr\/bin\/unrar' "$XDG_CONFIG_HOME"/krusaderrc
fi

# Clear the fstab file.
echo > /etc/fstab

# vim:ft=sh:ts=4:sw=4:et:sts=4
