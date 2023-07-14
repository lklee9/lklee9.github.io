(define-module (lklee cv builder)
  #:use-module (ice-9 hash-table)
  #:use-module (haunt builder blog)
  #:use-module (haunt artifact)
  #:use-module (lklee site theme)
  #:use-module (lklee sxml tex)
  #:use-module (lklee sxml html)
  #:use-module (lklee artifact)
  #:export (builder-cv))

(define* (layout-cv-tex body #:key
              (bib-db-path "../assets/pubs.bib")
                (gn "Loong Kuan")
                (fn "Lee")
                (email "lee@lklee.dev")
                (github "github.com/lklee9")
                (gitlab "gitlab.com/lklee")
                (orcid "orcid.org/0000-0002-9967-1319"))
  `((documentclass (@ "11pt" a4paper sans) moderncv)
    (moderncvstyle classic)
    (moderncvcolor black)
    (usepackage (@ scale=0.75) geometry)
    ;; font loading
    ;; for luatex and xetex, do not use inputenc and fontenc
    ;; see https://tex.stackexchange.com/a/496643
    (ifxetexorluatex) ("\n")
    (usepackage fontspec)
    (usepackage "unicode-math")
    (defaultfontfeatures "Ligatures=TeX")
    (setmainfont "Latin Modern Roman")
    (setsansfont "Latin Modern Sans")
    (setmonofont "Latin Modern Mono")
    (setmathfont "Latin Modern Math")
    (else) ("\n")
    (usepackage (@ "T1") fontenc)
    (usepackage lmodern)
    (fi) ("\n")
    ;; document language
    (usepackage (@ "english") babel)
    ;; Personal Data
    (name ,gn ,fn)
    (email ,email)
    (social (@ github) ,github)
    (social (@ gitlab) ,gitlab)
    (social (@ orcid) ,orcid)
    (renewcommand* (bibliographyitemlabel) "[\\arabic{enumiv}]")
    (renewcommand (refname) Publications)
    (usepackage bibentry)
    ("\\makeatletter\\let\\saved@bibitem\\@bibitem\\makeatother\n")
    (usepackage (@ unicode) hyperref)
    ("\\makeatletter\\let\\@bibitem\\saved@bibitem\\makeatother\n")
    (nobibliography*) ("\n")
    (renewcommand (labelitemi) -)
    (begin document
           ((clearpage) ("\n")
            (makecvtitle) ("\n")
            ,body
            (nobibliography ,bib-db-path)
            (bibliographystyle plain))
           )))

(define (layout-cv-html site title body)
  (layout-main site title `(div (@ (id "content") (class "full-page"))
                                (div (@ (align "center"))
                                     "Download pdf version of this CV "
                                     (a (@ (href "/cv/cv.pdf")) "here"))
                                (br)
                                ,body)) )




(define* (builder-cv #:key
                     (html-layout layout-cv-html)
                     (tex-layout layout-cv-tex)
                     (list-of-symbol-definitions '())
                     (uri-base-path "cv/")
                     (content '(h1))
                     (pubs '()))
  (define html-sym-dict
    (alist->hash-table
     (map (lambda (x) (cons (procedure-name x) (x "html")))
          list-of-symbol-definitions)))
  (define tex-sym-dict
    (alist->hash-table
     (map (lambda (x) (cons (procedure-name x) (x "tex")))
          list-of-symbol-definitions)))
  ;; (display "-------\n")
  ;; (display (map (lambda (x) (cons (procedure-name x) (x "html")))
  ;;         list-of-symbol-definitions))
  ;; (display "\n")
  ;; (display html-sym-dict)
  ;; (display (hash-ref tex-sym-dict 'cvbody))
  ;; (hash-for-each (lambda (key value)
  ;;                  (display key) (display (equal? key 'cvbody))
  ;;                  (display "\n")) tex-sym-dict)
  ;; (display "\n-------")
  (lambda (site posts)
    (define (make-file-path ext) (string-append uri-base-path ext))
    (define cv-html (serialized-artifact
                     (make-file-path "cv.html")
                     (html-layout site "cv" content)
                     (lambda (tree port)
                       (sxml->html tree port html-sym-dict))
                     ))
    (define cv-tex (serialized-artifact
                     (make-file-path "cv.tex")
                     (tex-layout content)
                     (lambda (tree port)
                       (sxml->tex tree port tex-sym-dict))
                     ))
    (list cv-html cv-tex
          (pdflatex-artifact uri-base-path "cv.tex")
          )
    ))
