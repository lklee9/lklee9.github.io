(define-module (lklee artifact)
  #:use-module (haunt artifact)
  #:export (pdflatex-artifact))

;; Build a PDF artifact by running latexmk in the generated TeX file's
;; output directory and then restoring the original working directory.
(define (pdflatex-artifact tex-file-dir tex-file-name)
  (make-artifact (string-append tex-file-dir "/" tex-file-name)
                 (lambda (output)
                   (define cur-dir (getcwd))
                   (chdir (string-append "../site/" tex-file-dir))
                   (display (string-append "building " (getcwd) "/" tex-file-name "\n"))
                   (system* "latexmk" "-pdf" tex-file-name)
                   (chdir cur-dir)
                   ))
  )
