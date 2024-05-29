#! /usr/bin/env bash
set -eux

cd ~

exec srun \
    --pty \
    --partition prepost \
    singularity \
    exec \
    --bind /gpfswork:/gpfswork \
    "$SINGULARITY_ALLOWED_DIR/pack.sif" \
    bash -l
