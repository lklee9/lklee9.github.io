(define-module (lklee site theme)
  #:use-module (srfi srfi-1)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module ((lklee site components) #:prefix component:)
  #:use-module (lklee biblio item)
  #:use-module (lklee utils)
  #:export (layout-main
            theme-redirect
            theme-publications))


;; Wrap a page body in the site's main HTML shell with shared header and footer.
(define (layout-main site title body)
  `((doctype  "html")
    (html (@ (lang "en"))
          ,(component:html-head
            (string-append (get-me site) " — " title))
          (header
           (h1 ,(get-me site) " (" ,(get-me-cn site) ")")
           ,(component:html-header-nav title)
           )

          (body ,body)
          ,component:html-footer
          )))


;; theme-redirect
;; Render a minimal page that redirects the browser to an external URL.
(define (layout-redirect site title body)
  `((doctype "html")
    (html (@ (lang "en"))
          ,(component:html-head
            (string-append (get-me site) " — " title)
            #:redirect-url body)
          (body "Redirecting to external site: "
                (a (@ (href ,body)) ,body)
                " ......" (br)
                "Click on the link to be redirected manually.")
          ,component:html-footer
          )))

;; Use the post body directly as the redirect target URL.
(define (post-template-redirect post)
  (post-sxml post))


;; Theme used for publication redirect pages.
(define theme-redirect
    (theme #:name "main"
         #:layout layout-redirect
         #:post-template post-template-redirect
         ))

;; theme-publications
;; Render the publications index page grouped by publication status.
(define (collection-template-pub site title posts prefix)
  (define me (assoc-ref (site-default-metadata site) 'author))
  (define pubs (map post-metadata posts))
  (define pubs-coauthor (filter-pubs-by-status pubs "coauthored"))
  (define pubs-first (filter-pubs-by-status pubs "authored"))
  `(,component:html-side-info
    (div (@ (id "content") (class "main-column"))
         (h2 Publications)
         ,@(if (equal? (length+ pubs-first) 0) '()
               (cons* (html-list-items pubs-first me)))
         ,@(if (equal? (length+ pubs-coauthor) 0) '()
               (cons* '(h2 "Coauthored Publications")
                      (html-list-items pubs-coauthor me)
                      ))
         )))

;; Render the full publication detail page with authors, venue, abstract,
;; and any extra post body content.
(define (post-template-pub post)
   (define me (assoc-ref (post-metadata post) 'author))
   `((div (@ (id "content") (class "full-page"))
          (h2 ,(post-ref post 'title))
          (div (@ (class "pub-authors"))
               ,@(list-tail
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

;; Theme used for the publications collection and publication detail pages.
(define theme-publications
  (theme #:name "main"
         #:layout layout-main
         #:post-template post-template-pub
         #:collection-template collection-template-pub
         ))
