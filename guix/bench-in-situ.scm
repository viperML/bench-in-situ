(define-module (bench-in-situ)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix utils))

(define vcs-file?
  (or (git-predicate (current-source-directory))
      (const #t)))

(define local-source
  (local-file "../." "source"
              #:recursive? #t
              #:select? (git-predicate (current-source-directory))))

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
    (native-inputs
      (list))
    (inputs (list))
    (synopsis "")
    (description "")
    (home-page "")
    (license license:expat)))
