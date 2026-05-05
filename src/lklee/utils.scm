(define-module (lklee utils)
  #:use-module (haunt site)
  #:use-module (ice-9 string-fun)
  #:export (cond-return get-me get-me-cn syms&strs->strs smart-dashes))

;; Return X when it is truthy, otherwise fall back to DEFAULT.
(define (cond-return x default) (if x x default))

;; Extract the primary author name from the site's default metadata.
(define (get-me site) (assoc-ref (site-default-metadata site) 'author))
;; Extract the Chinese author name from the site's default metadata.
(define (get-me-cn site)
  (assoc-ref (site-default-metadata site) 'author-cn))

;; Convert any symbols in a mixed list of symbols and strings into strings.
(define (syms&strs->strs syms&strs)
  (map (lambda (x) (if (symbol? x) (symbol->string x) x)) syms&strs))

;; Replace ASCII double and triple dashes with typographic en and em dashes.
(define (smart-dashes str)
  (string-replace-substring
   (string-replace-substring str "---" "—") "--" "–"))
