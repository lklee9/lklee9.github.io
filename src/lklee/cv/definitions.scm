(define-module (lklee cv definitions)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 curried-definitions)
  #:use-module (ice-9 match)
  #:use-module (lklee biblio item)
  #:use-module (lklee utils)
  #:export (symbol-definitions))



;; Create a renderer for italic text that emits either HTML or TeX markup.
(define ((it ext-target) . entries)
  (match ext-target
    ("html" `(i ,@entries))
    (else `(textit ,entries))))

;; Create a renderer for bold text that emits either HTML or TeX markup.
(define ((bf ext-target) . entries)
  (match ext-target
    ("html" `(b ,@entries))
    (else `(textbf ,entries))))

;; Create a renderer for an explicit line break in HTML or TeX output.
(define ((newline ext-target) )
  (match ext-target
    ("html" '(br))
    (else '("\\newline{}"))))

;; Create a renderer for a literal ampersand in the target output format.
(define ((amp ext-target) )
  (match ext-target
    ("html" "&")
    (else '("\\&"))))

;; Wrap the full CV body in the container expected by the chosen output format.
(define ((cv-body ext-target) . entries)
  (match ext-target
    ("html" `(div (@ (class "cvdiv")) ,@entries))
    (else entries)))

;; Render a top-level CV section heading for HTML or TeX output.
(define ((cv-section ext-target) . entries)
  (match ext-target
    ("html" `((div (@ (class "cvsep")))
                  (h3 (@ (class "cvtitle")) ,@entries)))
    (else `(section ,entries))))

;; Render a subordinate CV heading for HTML or TeX output.
(define ((cv-subsection ext-target) . entries)
  (match ext-target
    ("html" `((div) (h4 (@ (class "cvsubsection")) ,@entries)))
    (else `(subsection ,entries))))

;; Render a two-column CV item with a left margin label and right-hand content.
(define ((cv-item ext-target) marg . entries)
  (match ext-target
    ("html" `((div (@ (class "cvleft")) ,(smart-dashes marg))
              (div (@ (class "cvitem cvright")) ,@entries)))
    (else `(cvitem ,marg ,entries))))


;; Render a bullet list inside a CV entry for the selected output format.
(define ((cv-list ext-target) . items)
  (match ext-target
    ("html" `(ul (@ (class "cvlist")) ,@items))
    (else `(begin "itemize" ,@items))))

;; Render one item within a CV bullet list.
(define ((cv-list-item ext-target) . eles)
  (match ext-target
    ("html" `(li ,@eles))
    (else `((item) ,@eles))))

;; Render the publication section of the CV, optionally filtered by status.
(define* ((cv-pub-list ext-target) me
          #:optional (pubs '()) (status "authored")  )
  (define pubs-with-status (filter-pubs-by-status pubs status))
  (match ext-target
    ("html" `((h4 (@ (class "cvtitle cvleft"))
                  ,(string-capitalize status))
              ,@(list-tail (append-map
                 (lambda (x)
                   (list '(h4 (@ (class "cvleft")) " ")
                         `(div (@ (class "cvright")) ,x)
                         ))
                 (html-list-items pubs-with-status me)) 1)
              )
     )
    (else `((subsection ,(string-capitalize status))
            (begin list "" "\\setlength{\\leftmargin}{6.6em}"
                 ,@(tex-list-items pubs-with-status))))
    )
  )


;; Render a full CV entry with emphasized title fields and optional detail text.
(define ((cv-entry ext-target) marg btxt1 itxt2 txt3 itxt4 . txts5)
  (match ext-target
    ("html" `((div (@ (class "cvleft")) ,(smart-dashes marg))
              (div (@ (class "cventry cvright"))
                   (b ,btxt1)
                   ,(if (null? itxt2) "" `(", " (i ,@itxt2)))
                   ,(if (null? txt3) "" `(", " ,@txt3))
                   ,(if (null? itxt4) "" `(", " (i ,@itxt4)))
                   ,(if (null? txts5) '() '(br))
                   ,@txts5
                   )))
    (else `(cventry ,marg ,btxt1 ,itxt2 ,txt3 ,itxt4
                    ,(syms&strs->strs txts5))
          )
    )
  )

;; Map the supported Greek symbol names to their Unicode equivalents.
(define (greeksym-unicode sym)
  (match sym
    ("alpha" "α")
    ("beta" "β")
  ))

;; Render supported Greek symbols for HTML or TeX output.
(define ((greeksym ext-target) . syms)
  (match ext-target
    ("html" (map greeksym-unicode syms))
    (else `("$" (alpha) (beta) "$"))))


;; Registry of symbolic CV renderers shared by the HTML and TeX serializers.
(define symbol-definitions
  (list it bf newline amp
        cv-body cv-section cv-subsection cv-entry cv-item
        cv-list cv-list-item cv-pub-list
        greeksym))
