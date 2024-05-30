#! /usr/bin/env bash
set -eux

bindflags=()
for path in /*; do
  if [[ "$path" == /gp* ]]; then
    bindflags+=("--bind" "$path:$path")
  fi
done

exec srun \
    --pty \
    singularity \
    exec \
    "${bindflags[@]}" \
    "$SINGULARITY_ALLOWED_DIR/pack.sif" \
    bash -l
