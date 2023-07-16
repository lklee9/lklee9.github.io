(define-module (lklee biblio item)
  #:use-module (haunt site)
  #:use-module (srfi srfi-1)
  #:export (filter-pubs-by-status
            tex-list-item
            tex-list-items
            html-list-item
            html-list-items
            html-authors html-venue html-links))

;; functions
(define (filter-pubs-by-status pubs status)
  (filter (lambda (p) (equal? (assoc-ref p 'status) status)) pubs))


;; tex
(define (tex-list-item bib-item) `(bibentry ,(assoc-ref bib-item 'id)))

(define (tex-list-items pubs)
  (map (lambda (p) `("\\item" ,(tex-list-item p) ".")) pubs))

;; html
(define (html-list-items pubs me)
  (map (lambda (pub) (html-list-item pub me)) pubs))

(define (html-list-item pub me)
  `(div (@ (itemscope "")
           (itemtype "http://schema.org/ScholarlyArticle")
           (class "pub-list-item"))
        ,(html-title pub)
        (div (@ (class "pub-authors"))
             ,@(list-tail (fold-right
                           (lambda (ele res) (list ", " ele res))
                           '() (html-authors pub me)) 1) ".")
        ,(html-venue pub)
        ,(html-links pub)
        ))

(define (html-title pub)
  (define title (assoc-ref pub 'title))
  (define pub-page-link
    (string-append "/pub/" (assoc-ref pub 'path) ".html"))
  (if (assoc-ref pub 'web-page)
      `(span (@ (itemprop "name") (class "pub-title"))
             (a (@ (href ,pub-page-link)
                 (style "font-weight:bold")) ,title))
        `(span (@ (itemprop "name") (class "pub-title")) ,title)))

(define (html-authors pub me)
  (let* ((merge-names (lambda (fn-gn)
                        (string-append (assoc-ref fn-gn 'gn) " "
                                       (assoc-ref fn-gn 'fn))))
         (fmt-n (lambda (n)
                  `(span (@ (itemprop "author")
                          (class "pub-author")) ,n)))
         )
    (map (lambda (fn-gn)
           (define tmp-n (merge-names fn-gn))
           (if (equal? tmp-n me) `(b ,(fmt-n tmp-n)) (fmt-n tmp-n)))
         (assoc-ref pub 'authors))
  ))

(define (html-venue pub)
  (let* ((type (assoc-ref pub 'type))
         (comments (if (assoc-ref pub 'comments)
                       (assoc-ref pub 'comments) "")))
    (if (equal? type "preprint")
        `(div (i "Preprint") ", " ,(assoc-ref pub 'year) "." ,@comments)
        `(div "In "
              (span (@ (itemprop "publisher")
                     (itemtype "http://schema.org/Organization"))
                    (i (@ (itemprop "name")) ,(assoc-ref pub 'venue)))
              ", "
              (meta (@ (itemprop "datePublished")
                     (content ,(assoc-ref pub 'year))))
              ,(assoc-ref pub 'volume) "(" ,(assoc-ref pub 'issue) "):"
              ,(assoc-ref pub 'page) ", "
              ,(assoc-ref pub 'year) ". " ,comments)
  )))

(define (html-links pub)
  (define pub-links (if (assoc-ref pub 'links)
                        (assoc-ref pub 'links) '()))
  (define pub-links-with-doi
    (acons (string-append "DOI")
           (string-append "https://doi.org/" (assoc-ref pub 'doi))
           pub-links))
  (define (fmt-link link)
    `((span (a (@ (class "button") (href ,(cdr link))) ,(car link))) (" ")))
  `(div (@ (class "pub-links")) ,@(map fmt-link pub-links-with-doi))
  )

