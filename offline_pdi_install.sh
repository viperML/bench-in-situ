#!/bin/bash

source env.sh
print_env

cd lib/pdi
mkdir -p build
cd build

cmake -DCMAKE_INSTALL_PREFIX=${WORKING_DIR}/install_pdi -DUSE_HDF5=EMBEDDED -DBUILD_HDF5_PARALLEL=OFF  -DUSE_yaml=EMBEDDED -DUSE_paraconf=EMBEDDED -DBUILD_SHARED_LIBS=ON -DBUILD_FORTRAN=OFF -DBUILD_BENCHMARKING=OFF -DBUILD_SET_VALUE_PLUGIN=OFF -DBUILD_TESTING=OFF -DBUILD_DECL_NETCDF_PLUGIN=OFF -DBUILD_USER_CODE_PLUGIN=OFF -DBUILD_PYTHON=ON -DBUILD_DEISA_PLUGIN=ON -DUSE_pybind11=EMBEDDED ..

make -j8
make install

source ${WORKING_DIR}/install_pdi/share/pdi/env.sh

cd --

