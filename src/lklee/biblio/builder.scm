(define-module (lklee biblio builder)
  #:use-module (srfi srfi-1)
  #:use-module (haunt post)
  #:use-module (haunt builder blog)
  #:use-module (haunt artifact)
  #:use-module (haunt html)
  #:use-module (lklee utils)
  #:use-module (lklee biblio)
  #:use-module (lklee biblio item)
  #:use-module (lklee site theme)
  #:use-module ((lklee site components) #:prefix component:)
  #:export (builder-publications))


;; buider

;; Return a Haunt builder that generates the publications index, optional
;; publication detail pages, and redirect pages for external resources.
(define* (builder-publications #:key
                               (theme theme-publications)
                               (theme-redirect theme-redirect)
                               (collection-home "index.html")
                               (pubs-root-path "/pub/")
                               (bib-db-json "./assets/pubs.json")
                               (pubs '()))
  (lambda (site _)
    ;; Build the URI prefix used for a publication and its related pages.
    (define (pub->path pub) (string-append pubs-root-path
                                           (assoc-ref pub 'path)))
    ;; Wrap a publication metadata alist in a Haunt post record.
    (define (pub->post pub)
      (make-post (pub->path pub)
                 pub (cond-return (assoc-ref pub 'web-page) "")))
    (define posts (map pub->post pubs))
    ;; Render a publication post as its standalone HTML page.
    (define (post->page post)
      (serialized-artifact
       (string-append (post-file-name post) ".html")
       (with-layout theme site (assoc-ref (post-metadata post) 'title)
                    (render-post theme site post))
       sxml->html)
      )
    ;; Build lightweight redirect pages for publication-specific external links.
    (define (pub->redirect pub)
      (map
       (lambda (redirect)
         (serialized-artifact
          (string-append (pub->path pub) (car redirect) ".html")
          (with-layout
           theme site (assoc-ref pub 'title)
           (render-post theme-redirect site
                        (make-post (pub->path pub) pub (cdr redirect))))
          sxml->html))
       (assoc-ref pub 'redirects)))
    ;; Render the top-level publications listing page.
    (define (pubs->page posts)
      (serialized-artifact
       collection-home
       (with-layout theme site "home"
                    (render-collection theme site "home" posts ""))
       sxml->html))
    (append (map post->page
                 (filter (lambda (x)
                           (assoc-ref (post-metadata x) 'web-page))
                         posts))
            (append-map pub->redirect
                 (filter (lambda (x) (assoc-ref x 'redirects))
                         pubs))
            (list (pubs->page posts)))))

