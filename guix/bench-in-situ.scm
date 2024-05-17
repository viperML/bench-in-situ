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
  #:use-module (gnu packages linux)
  #:use-module (guix build-system copy)
  #:use-module (guix-hpc packages pdi)
  #:use-module (guix-hpc packages utils))

(define location
  (current-source-directory))

(define-public local-source
  (local-file ".." "source"
              #:recursive? #t
              #:select? (git-predicate (dirname location))))

(define-public bench-in-situ
  (package
    (name "bench-in-situ")
    (version "0.1.0")
    (source local-source)
    (build-system cmake-build-system)
    (arguments
      `(#:tests? #f
        #:configure-flags ,#~(list "-DSESSION=MPI_SESSION"
                                   "-DKokkos_ENABLE_OPENMP=ON"
                                   "-DEuler_ENABLE_PDI=ON")
        ;; #:validate-runpath? #t
        #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'unvendor
                    (lambda* (#:key outputs inputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (inih (assoc-ref inputs "libinih")))
                        (begin
                          (pk inputs)
                          (pk outputs)
                          (delete-file-recursively "lib/kokkos")
                          (delete-file-recursively "lib/pdi"))))))))
    (native-inputs (list paraconf
                         pkg-config))
    (inputs (list openmpi
                  pdi
                  pdiplugin-mpi
                  pdiplugin-user-code
                  pdiplugin-decl-hdf5-parallel
                  kokkos
                  libyaml
                  libinih))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:expat)))
