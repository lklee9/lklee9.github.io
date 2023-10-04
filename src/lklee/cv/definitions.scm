(define-module (lklee cv definitions)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 curried-definitions)
  #:use-module (ice-9 match)
  #:use-module (lklee biblio item)
  #:use-module (lklee utils)
  #:export (symbol-definitions))



(define ((it ext-target) . entries)
  (match ext-target
    ("html" `(i ,@entries))
    (else `(textit ,entries))))

(define ((bf ext-target) . entries)
  (match ext-target
    ("html" `(b ,@entries))
    (else `(textbf ,entries))))

(define ((newline ext-target) )
  (match ext-target
    ("html" '(br))
    (else '("\\newline{}"))))

(define ((amp ext-target) )
  (match ext-target
    ("html" "&")
    (else '("\\&"))))

(define ((cv-body ext-target) . entries)
  (match ext-target
    ("html" `(div (@ (class "cvdiv")) ,@entries))
    (else entries)))

(define ((cv-section ext-target) . entries)
  (match ext-target
    ("html" `((div (@ (class "cvsep")))
                  (h3 (@ (class "cvtitle")) ,@entries)))
    (else `(section ,entries))))

(define ((cv-subsection ext-target) . entries)
  (match ext-target
    ("html" `((div) (h4 (@ (class "cvsubsection")) ,@entries)))
    (else `(subsection ,entries))))

(define ((cv-item ext-target) marg . entries)
  (match ext-target
    ("html" `((div (@ (class "cvleft")) ,(smart-dashes marg))
              (div (@ (class "cvitem cvright")) ,@entries)))
    (else `(cvitem ,marg ,entries))))


(define ((cv-list ext-target) . items)
  (match ext-target
    ("html" `(ul (@ (class "cvlist")) ,@items))
    (else `(begin "itemize" ,@items))))

(define ((cv-list-item ext-target) . eles)
  (match ext-target
    ("html" `(li ,@eles))
    (else `((item) ,@eles))))

(define* ((cv-pub-list ext-target) me
          #:optional (pubs '()) (status "published")  )
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

(define (greeksym-unicode sym)
  (match sym
    ("alpha" "α")
    ("beta" "β")
  ))

(define ((greeksym ext-target) . syms)
  (match ext-target
    ("html" (map greeksym-unicode syms))
    (else `("$" (alpha) (beta) "$"))))


(define symbol-definitions
  (list it bf newline amp
        cv-body cv-section cv-subsection cv-entry cv-item
        cv-list cv-list-item cv-pub-list
        greeksym))
