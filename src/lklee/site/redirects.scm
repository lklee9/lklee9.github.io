(define-module (lklee site redirects)
  #:use-module (srfi srfi-13)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (lklee site theme)
  #:export (builder-redirects))


;; Turn a redirect path such as "/scholar" into the file that serves it.
;; Paths already naming an HTML file are kept as-is, everything else
;; becomes a directory index so that both "/scholar" and "/scholar/"
;; resolve.
(define (path->file-name path)
  (let ((trimmed (string-trim-both path #\/)))
    (if (string-suffix? ".html" trimmed)
        trimmed
        (string-append trimmed "/index.html"))))

;; Return a Haunt builder that generates one redirect page per entry of
;; REDIRECTS, an alist mapping a site path to the external URL it should
;; send visitors to.
(define* (builder-redirects #:key
                            (theme theme-redirect)
                            (redirects '()))
  (lambda (site _)
    ;; Render a single path/URL pair as a meta-refresh page.
    (define (redirect->page redirect)
      (let ((path (car redirect))
            (url (cdr redirect)))
        (serialized-artifact
         (path->file-name path)
         (with-layout theme site (string-trim-both path #\/) url)
         sxml->html)))
    (map redirect->page redirects)))
