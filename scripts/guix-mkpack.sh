#! /usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

set -x
guix time-machine -q -C "$ROOT/channels.locked.scm" -- \
    pack \
    --format=squashfs \
    -r pack.sif \
    -S /bin=bin \
    -S /etc=etc \
    -m "$ROOT/manifest.scm"
set +x

echo "pack.sif has been created"
