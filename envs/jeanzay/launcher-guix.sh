#! /usr/bin/env bash

#SBATCH --job-name=bench_insitu
#SBATCH --output=%x_%j.out
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --hint=nomultithread

set -eux

IMAGE="$SINGULARITY_ALLOWED_DIR/pack.sif"

run_guix() {
  pushd ~

  singularity \
    exec \
    --bind /gpfswork:/gpfswork \
    "$IMAGE" \
    "$@"

  popd
}

srun_guix() {
  IFS=$'\n' read -d "" -r -a buf <<< "${*//--/$'\n'}" || true
  read -r -a slurm_args <<< "${buf[0]}" || true
  read -r -a singu_args <<< "${buf[1]}" || true
  srun \
    "${slurm_args[@]}" \
    singularity \
    exec \
    --bind /gpfswork:/gpfswork \
    "$IMAGE" \
    "${singu_args[@]}"
}

IFS='=' read -r -a arr <<< "$(scontrol show job "$SLURM_JOB_ID" | grep Command)" || true
SCRIPT="${arr[1]}"
BASE_DIR="$(cd "$(dirname "$SCRIPT")"/../.. && pwd)"
WORKING_DIR="$BASE_DIR/working_dir"


SCHEFILE=scheduler.json
PREFIX=bench_insitu
DASK_WORKER_NODES=1
SIM_NODES=$(($SLURM_NNODES-2-$DASK_WORKER_NODES))
SIM_PROC=$SIM_NODES

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export OMP_PLACES=cores

echo "SLURM_NNODES=$SLURM_NNODES"
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo "SIM_NODES=$SIM_NODES"


# move to working directory
mkdir "$WORKING_DIR"
cd "$WORKING_DIR"

srun_guix \
  -N 1 -n 1 -c 1 -r 0 \
  -- \
  dask scheduler \
    --protocol tcp \
    --scheduler-file=$SCHEFILE \
  >> ${PREFIX}_dask-scheduler.o &

# Wait for the SCHEFILE to be created
while ! [ -f ${SCHEFILE} ]; do
  sleep 3
done

exit 1

# dask workers
srun -N ${DASK_WORKER_NODES} -n ${DASK_WORKER_NODES} -c 1 -r 1 dask worker --protocol tcp --local-directory /tmp --scheduler-file=${SCHEFILE} >> ${PREFIX}_dask-worker.o &

# insitu
srun -N 1 -n 1 -c 1 -r $(($DASK_WORKER_NODES+1)) python -O in-situ/fft_updated.py >> ${PREFIX}_client.o &
client_pid=$!

# simulation
srun -N ${SIM_NODES} -n ${SIM_PROC} -r $(($DASK_WORKER_NODES+2)) build/main ${BASE_DIR}/envs/jeanzay/setup.ini ${BASE_DIR}/envs/jeanzay/io_deisa.yml --kokkos-map-device-id-by=mpi_rank &
simu_pid=$!
wait $simu_pid
