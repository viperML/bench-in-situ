(use-modules (guix build-system gnu)
             (ice-9 match))

(define stdenv
  (map (lambda* (pkg)
         (match pkg
           ((_ value _ ...)
            value)))
    (standard-packages)))

(concatenate-manifests
  (list
    (specifications->manifest
      (list
        "bash"
        "gcc-toolchain"

        ;; build time deps
        "cmake"
        "openmpi@4"
        "pdi"
        "pdiplugin-mpi"
        "pdiplugin-user-code"
        "pdiplugin-decl-hdf5-parallel"
        "kokkos"
        "paraconf"
        "pkg-config"
        "libyaml"

        ;; runtime deps
        "python-dask"))
    (packages->manifest stdenv)))

