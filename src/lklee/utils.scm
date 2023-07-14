(define-module (lklee utils)
  #:use-module (haunt site)
  #:use-module (ice-9 string-fun)
  #:export (cond-return get-me syms&strs->strs smart-dashes))

(define (cond-return x default) (if x x default))

(define (get-me site) (assoc-ref (site-default-metadata site) 'author))

(define (syms&strs->strs syms&strs)
  (map (lambda (x) (if (symbol? x) (symbol->string x) x)) syms&strs))

(define (smart-dashes str)
  (string-replace-substring
   (string-replace-substring str "---" "—") "--" "–"))
