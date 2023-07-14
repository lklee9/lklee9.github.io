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
  #:use-module ((lklee site-components) #:prefix component:)
  #:export (builder-publications))


;; buider

(define* (builder-publications #:key
                               (theme theme-publications)
                               (theme-redirect theme-redirect)
                               (collection-home "index.html")
                               (pubs-root-path "/pubs/")
                               (bib-db-json "./assets/pubs.json")
                               (pubs '()))
  (lambda (site _)
    (define (pub->path pub) (string-append pubs-root-path
                                           (assoc-ref pub 'id)))
    (define (pub->post pub)
      (make-post (pub->path pub)
                 pub (cond-return (assoc-ref pub 'web-page) "")))
    (define posts (map pub->post pubs))
    (define (post->page post)
      (serialized-artifact (string-append (post-file-name post) ".html")
                           (render-post theme site post)
                           sxml->html)
      )
    (define (pub->redirect pub)
      (map
       (lambda (redirect)
         (serialized-artifact
          (string-append (pub->path pub) (car redirect) ".html")
          (render-post theme-redirect site
                       (make-post (pub->path pub) pub (cdr redirect))
                       )
          sxml->html))
       (assoc-ref pub 'redirects)))
    (define (pubs->page posts)
      (serialized-artifact collection-home
                           (render-collection theme site "home"
                                              posts "")
                           sxml->html))
    (append (map post->page
                 (filter (lambda (x)
                           (assoc-ref (post-metadata x) 'web-page))
                         posts))
            (append-map pub->redirect
                 (filter (lambda (x) (assoc-ref x 'redirects))
                         pubs))
            (list (pubs->page posts)))))

