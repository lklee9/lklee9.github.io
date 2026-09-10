(define-module (lklee cv builder)
  #:use-module (ice-9 hash-table)
  #:use-module (haunt builder blog)
  #:use-module (haunt artifact)
  #:use-module (lklee site theme)
  #:use-module (lklee sxml tex)
  #:use-module (lklee sxml html)
  #:use-module (lklee artifact)
  #:export (builder-cv))

;; Build the SXML representation of the TeX document used to typeset the CV.
(define* (layout-cv-tex body #:key
              (bib-db-path "../assets/pubs.bib")
                (gn "Loong Kuan")
                (fn "Lee")
                (email "lee@lklee.dev")
                (homepage "lklee.dev")
                ;; Bare usernames only.  moderncv's \social builds the full
                ;; URL itself, so a value carrying the host doubles it --
                ;; "loongkuan" linked to linkedin.com/in/loongkuan.
                ;; GitHub and GitLab are deliberately absent: the homepage
                ;; above reaches both, and the header has no spare lines.
                (linkedin "loongkuan")
                (orcid "0000-0002-9967-1319"))
  `((documentclass (@ "11pt" a4paper sans) moderncv)
    (moderncvstyle classic)
    (moderncvcolor black)
    ;; 0.75 left ~26mm margins, which is airy for a CV.  0.85 gives ~16mm and
    ;; is the only tighter value that still breaks the page cleanly: 0.78 to
    ;; 0.82 all split a publication entry or orphan the Featured Publications
    ;; heading across the page boundary.
    (usepackage (@ scale=0.85) geometry)
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
    ;; Without this the site appears on the CV only inside the email address,
    ;; so a reader of the printed copy has to infer the domain to reach the
    ;; web version (which carries DOI/code/pdf links the paper cannot).
    (homepage ,homepage)
    (social (@ linkedin) ,linkedin)
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

;; Wrap the CV body in the site's HTML layout and add a download link for
;; the generated PDF version.
(define (layout-cv-html site title body)
  (layout-main site title `(div (@ (id "content") (class "full-page"))
                                (div (@ (align "center"))
                                     "Download pdf version of this CV "
                                     (a (@ (href "/cv/cv.pdf")) "here"))
                                (br)
                                ,body)) )




;; Return a Haunt builder that emits HTML and TeX versions of the CV and
;; then compiles the TeX file into a PDF.
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
    ;; Place each generated CV artifact under the configured URI base path.
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
