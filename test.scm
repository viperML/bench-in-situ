(use-modules (guix git-download)
             (guix gexp)
             (guix utils))

(define s
  "/home/ayats/Documents/bench-in-situ")

(local-file
  s "source"
  #:recursive? #t
  #:select? (git-predicate s))
