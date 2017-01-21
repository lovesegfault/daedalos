#!/bin/sh
set -e
. ./config.sh

DESTDIR="$SYSROOT" $MAKE
