(use-modules (guix git-download)
             (guix gexp)
             (guix utils))

(local-file
  (current-source-directory) "source"
  #:recursive? #t
  #:select? (git-predicate (current-source-directory)))
