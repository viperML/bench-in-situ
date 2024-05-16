(define-module (bench-in-situ)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix-hpc packages pdi)
  #:use-module (guix-hpc packages utils))

(define location
  (pk 'loc (current-source-directory)))

(define-public local-source
  (local-file ".." "source"
              #:recursive? #t
              #:select? (git-predicate (pk 'l (dirname location)))))

(define-public bench-in-situ
  (package
    (name "bench-in-situ")
    (version "0.1.0")
    (source local-source)
    (build-system cmake-build-system)
    (arguments
      (list
        #:tests? #f
        #:configure-flags #~(list "-DSESSION=MPI_SESSION"
                                  "-DKokkos_ENABLE_OPENMP=ON"
                                  "-DEuler_ENABLE_PDI=ON")))
    (native-inputs (list paraconf
                         pkg-config))
    (inputs (list openmpi
                  pdi
                  pdiplugin-mpi
                  pdiplugin-user-code
                  pdiplugin-decl-hdf5-parallel
                  kokkos
                  libyaml))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:expat)))
