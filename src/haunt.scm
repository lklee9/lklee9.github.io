(use-modules (srfi srfi-1)
             (srfi srfi-19)
             (haunt asset)
             (haunt post)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader commonmark)
             (haunt site)
             (lklee biblio)
             (lklee site theme)
             ((lklee site components) #:prefix component:)
             (lklee utils)
             (lklee biblio builder)
             (lklee cv builder)
             (lklee cv definitions)
             (lklee cv content)
             )

;;(pub-item-venue pub-tmp )

;; (pub-list-item pub-tmp (site #:default-metadata
;;                              '((author . "Loong Kuan Lee"))))



(define me "Loong Kuan Lee")
(define bib-db-json "./assets/pubs.json")


(define pubs
  '(("lee2023" .
     ((status . "published")
      (path . "2023-aaai")
      (redirects . (("/code" . "https://gitlab.com/lklee/comp-div-dm")))
      (links . (("pdf" . "/assets/pdf/lee2023.pdf")
                ("code" . "https://gitlab.com/lklee/comp-div-dm")
                ("poster" . "/assets/pdf/lee2023-poster.pdf")))
      (web-page . ())))
    ("webb2018" .
     ((status . "published")
      (path . "2018-dmkd")
      (links . (("pdf" . "/assets/pdf/webb2018.pdf")
                ("code" . "https://github.com/lklee9/DriftMapper")))))
    ))

(define (merge-pubs-biblio pubs biblio)
  (let (( merge (lambda (pub)
          (let ((cur-meta (assoc-ref pubs (assoc-ref pub 'id))))
            (fold acons pub (map car cur-meta) (map cdr cur-meta)))
          )))
    (map merge biblio)))

(define pubs-full (merge-pubs-biblio
                   pubs (file->biblio bib-db-json)))



(site #:title "lklee"
      #:domain "example.com"
      #:build-directory "../site"
      #:default-metadata
      '((author . "Loong Kuan Lee")
        (email  . "mail@lklee.dev"))
      #:readers (list commonmark-reader)
      #:builders (list
                  ;; (blog #:theme theme-main
                  ;;            #:collections `(("home" "index.html" ,posts/reverse-chronological)))
                  ;; (static-directory "imgs")
                  (static-directory "assets")
                  (builder-publications
                   #:theme theme-publications
                   #:theme-redirect theme-redirect
                   #:pubs pubs-full)
                  (builder-cv
                   #:content (cv-content pubs-full)
                   #:pubs pubs-full
                   #:list-of-symbol-definitions symbol-definitions)

                  ;; (atom-feed)
                  ;; (atom-feeds-by-tag)
                  ))
