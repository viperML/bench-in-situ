#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd) && cd ${SCRIPT_DIR}
source env.sh
print_env

mkdir -p ${WORKING_DIR}
cd ${WORKING_DIR}

#############
# PYTHON 3.9
#############
# 1) create conda env
conda create -y --name py39 python=3.9.19

# 2) pip download and wheel
conda run -n py39 pip download ../lib/deisa/ -d ${PYTHON_DEPS}
conda run -n py39 pip download wheel versioneer zarr cytools  h5py -d ${PYTHON_DEPS}

cd ${PYTHON_DEPS}
conda run -n py39 pip wheel *.zip
rm *.zip
cd ..

# 4) tar gz -> deisa_${PYTHON_DEPS}_py39.tar.gz
tar -czvf deisa_deps_py39.tar.gz "$(basename "$PYTHON_DEPS")"/*
# 5) cleanup: deactivate conda env, rm conda env, downloaded files
conda remove -y --name py39 --all
rm -r ${PYTHON_DEPS}/*

#############
# PYTHON 3.10
#############
# 1) create conda env
conda create -y --name py310 python=3.10.14

# 2) pip download and wheel
conda run -n py310 pip download ../lib/deisa/ -d ${PYTHON_DEPS}
conda run -n py310 pip download wheel versioneer zarr cytools h5py -d ${PYTHON_DEPS}

cd ${PYTHON_DEPS}
conda run -n py310 pip wheel *.zip
rm *.zip
cd ..

# 4) tar gz -> deisa_${PYTHON_DEPS}_py310.tar.gz
tar -czvf deisa_deps_py310.tar.gz "$(basename "$PYTHON_DEPS")"/*
# 5) cleanup: deactivate conda env, rm conda env, downloaded files
conda remove -y --name py310 --all
rm -r ${PYTHON_DEPS}/*

#############
# PYTHON 3.11
#############
# 1) create conda env
conda create -y --name py311 python=3.11.6

# 2) pip download and wheel
conda run -n py311 pip download ../lib/deisa/ -d ${PYTHON_DEPS}
conda run -n py311 pip download wheel versioneer zarr cytools h5py -d ${PYTHON_DEPS}

cd ${PYTHON_DEPS}
conda run -n py311 pip wheel *.zip
rm *.zip
cd ..

# 4) tar gz -> deisa_${PYTHON_DEPS}_py311.tar.gz
tar -czvf deisa_deps_py311.tar.gz "$(basename "$PYTHON_DEPS")"/*
# 5) cleanup: deactivate conda env, rm conda env, downloaded files
conda remove -y --name py311 --all
rm -r ${PYTHON_DEPS}/*


