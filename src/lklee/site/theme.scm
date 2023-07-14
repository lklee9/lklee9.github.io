(define-module (lklee site theme)
  #:use-module (srfi srfi-1)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module ((lklee site-components) #:prefix component:)
  #:use-module (lklee biblio item)
  #:use-module (lklee utils)
  #:export (layout-main
            theme-redirect
            theme-publications))


(define (layout-main site title body)
  `((doctype "html")
    ,(component:html-head (string-append (get-me site) " — " title))
     (header
      (h1 ,(get-me site))
      ,(component:html-header-nav title)
      )

     (body ,body)
     ,component:html-footer
    ))


;; theme-redirect
(define (layout-redirect site title body)
  `((doctype "html")
    ,(component:html-head
      (string-append (get-me site) " — " title)
      #:redirect-url body)
    (body "Redirecting to external site: "
          (a (@ (href ,body)) ,body)
          " ......" (br)
          "Click on the link to be redirected manually.")
    ,component:html-footer
    ))

(define (post-template-redirect post)
  (post-sxml post))


(define theme-redirect
    (theme #:name "main"
         #:layout layout-redirect
         #:post-template post-template-redirect
         ))

;; theme-publications
(define (collection-template-pub site title posts prefix)
  (define me (assoc-ref (site-default-metadata site) 'author))
  (define pubs (map post-metadata posts))
  (define pubs-published (filter-pubs-by-status pubs "published"))
  (define pubs-accepted (filter-pubs-by-status pubs "accepted"))
  `(,component:html-side-info
    (div (@ (id "content") (class "main-column"))
         (h2 Publications)
         ,@(if (equal? (length+ pubs-accepted) 0) '()
               (cons* '(h3 Accepted)
                      (html-list-items pubs-accepted me)
                      ))
         ,@(if (equal? (length+ pubs-published) 0) '()
               (cons* '(h3 Published)
                      (html-list-items pubs-published me)
                      ))
         )))

(define (post-template-pub post)
   (define me (assoc-ref (post-metadata post) 'author))
   `((div (@ (id "content") (class "full-page"))
          (h2 ,(post-ref post 'title))
          (div ,@(list-tail
                  (fold-right
                   (lambda (ele res) (list ", " ele res))
                   '() (html-authors
                        (post-metadata post) me)) 1))
          ,(html-venue (post-metadata post))
          (div (@ (class "pub-abs"))
               (hr (@ (size "1") (color "#c8c8c8")))
               (p ,(assoc-ref (post-metadata post) 'abs))
               (hr (@ (size "1") (color "#c8c8c8")))
               )
          ,(html-links (post-metadata post))
          (div ,(post-sxml post)))))

(define theme-publications
  (theme #:name "main"
         #:layout layout-main
         #:post-template post-template-pub
         #:collection-template collection-template-pub
         ))
