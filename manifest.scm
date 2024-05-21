(concatenate-manifests
  (list
    (specifications->manifest
      (list
        "gcc-toolchain"
        "cmake"
        "make"
        "openmpi"
        "pdi"
        "pdiplugin-mpi"
        "pdiplugin-user-code"
        "pdiplugin-decl-hdf5-parallel"
        "kokkos"
        "paraconf"
        "pkg-config"
        "libyaml"))))

