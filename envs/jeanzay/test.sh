#! /usr/bin/env bash

set -eux


srun_guix() {
  local slurm_args=()
  local singu_args=()
  local reading=slurm
  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      reading="singularity"
      continue
    fi
    if [[ $reading == slurm ]]; then
      slurm_args+=("$arg")
    else
      singu_args=("$arg")
    fi
  done

  echo "singu_args: ${singu_args[*]}"
  srun \
    "${slurm_args[@]}" \
    singularity \
    exec \
    "${bindflags[@]}" \
    image \
    "${singu_args[@]}" || true
}

srun_guix \
  -N 1 -n 1 -c 1 -r 0 \
  -- \
  dask scheduler --protocol tcp --help
