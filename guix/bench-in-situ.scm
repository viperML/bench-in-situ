(define-module (bench-in-situ)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (ice-9 pretty-print))

(define* (selector file stat)
  (begin
    (pretty-print file)
    #f))

(define location
  (let* ((res (string-append (current-source-directory) "/..")))
        (begin
          (pretty-print res)
          res)))

(define selector2
  (lambda (file stat)
    (begin
      (pretty-print file)
      (let* ((res ((git-predicate location) 
                   file stat)))
        (begin
          (pretty-print res)
          res)))))

(define-public local-source
  (local-file ".." "source"
              #:recursive? #t
              #:select? selector2))
              ;; #:select? (git-predicate ".")))

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
