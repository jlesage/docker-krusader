#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export HOME=/config
export SHELL=/bin/sh

exec /usr/bin/krusader

# vim:ft=sh:ts=4:sw=4:et:sts=4
