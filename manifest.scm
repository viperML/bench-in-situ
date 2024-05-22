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
    (packages->manifest stdenv)
    (specifications->manifest
      (list
        "bash"
        "gcc-toolchain"

        "cmake"
        "openmpi@4"
        "pdi"
        "pdiplugin-mpi"
        "pdiplugin-user-code"
        "pdiplugin-decl-hdf5-parallel"
        "kokkos"
        "paraconf"
        "pkg-config"
        "libyaml"))))

