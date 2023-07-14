;;; Copyright © 2023 Loong Kuan Lee <mail@lklee.dev>
;;;
;;; This file was adapted from html.scm from Haunt. Below is the
;;; copyright information for Haunt.
;;;
;;; Haunt --- Static site generator for GNU Guile
;;; Copyright © 2015 David Thompson <davet@gnu.org>
;;;
;;; Haunt is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; Haunt is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Haunt.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; SXML to tex conversion.
;;
;;; Code:

(define-module (lklee sxml tex)
  #:use-module (sxml simple)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-26)
  #:use-module (lklee utils)
  #:export (sxml->tex))

(define (opts->tex opts port)
  (define opts-len (length opts))
  (if (> opts-len 0)
      (begin
        (display "[" port)
        (display (string-join (syms&strs->strs opts) ",") port)
        (display "]" port)
        ))
)
(define (args->tex args port symbol-dict)
  (for-each (lambda (arg)
              (display "{" port)
              (sxml->tex arg port symbol-dict)
              (display "}" port))
            args))

(define (macro->tex func opts args port symbol-dict)
  "\\func[opts...]{args[0]}{args[1]}...{args[n]}"
  (if (hash-ref symbol-dict func)
      (if (null? opts)
          (sxml->tex (apply (hash-ref symbol-dict func) args)
                     port symbol-dict)
          (sxml->tex (apply (hash-ref symbol-dict func) `(@ ,opts) args)
                     port symbol-dict)
          )
      (begin
        (format port "\\~a" func)
        (opts->tex opts port)
        (args->tex args port symbol-dict)
        ))
        (format port " ")
  )

(define (env->tex env opts args port sym-dict)
  "\\begin{env}[opts...]{args1}{args2}...{args n-1} args n\\end{env}"
  (format port "\\begin{~a}" env)
  (opts->tex opts port)
  (define arg-len (length args))
  (if (> arg-len 1) (args->tex
                     (list-head args (- arg-len 1)) port sym-dict))
  (sxml->tex (last-pair args) port  sym-dict)
  (format port "\\end{~a}" env)
  )



(define* (sxml->tex tree #:optional (port (current-output-port))
                    (symbol-dict (make-hash-table)))
  "Write the serialized HTML form of TREE to PORT."
  (match tree
    (() *unspecified*)
    (('begin env ('@ opts ...) args ...)
     (env->tex env opts args port symbol-dict))
    (('begin env args ...)
     (env->tex env '() args port symbol-dict))
    (((? symbol? func) ('@ opts ...) args ...)
     (macro->tex func opts args port symbol-dict)
     ;; (display "\n" port)
     )
    (((? symbol? func) ('@ opts ...))
     (macro->tex func opts '() port symbol-dict)
     ;; (display "\n" port)
     )
    (((? symbol? func) args ...)
     (macro->tex func '() args port symbol-dict)
     ;; (if (> (length args) 0) (display "\n" port))
     )
    ((nodes ...)
     (for-each
      (cut sxml->tex <> port  symbol-dict) nodes))
    ((? string? text)
     (display text port))
    ;; Render arbitrary Scheme objects, too.
    (obj
     (display (call-with-output-string (cut display obj <>)) port))))


(define* (sxml->tex-string sxml #:key (symbol-dict (make-hash-table)))
  "Render SXML as an tex string."
  (call-with-output-string
   (lambda (port)
     (sxml->tex sxml #:port port #:symbol-dict symbol-dict))))

;; (define tmp-sym-dict (make-hash-table))

;; (hash-set! tmp-sym-dict 'documentclass
;;             (lambda (opts args) `((test1 (@ ,@opts)) (test2 ,args))))

;; (define cv-tex (layout-cv-tex '()))

;; (display (sxml->tex-string (cv-tex) #:symbol-dict tmp-sym-dict))

;; (call-with-output-file "./lklee/cv/cv.tex"
;;     (lambda (port)
;;       (sxml->tex cv-tex #:port port)))
