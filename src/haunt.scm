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
  '(;; ("lee2023a" .
    ;;  ((type . "private")
    ;;   (title . "Computing Marginal and Conditional Divergences\
    ;;             between Decomposable Models with Applications")
    ;;   (authors . (((gn . "Loong Kuan") (fn . "Lee"))
    ;;               ((gn . "Geoffrey I.") (fn . "Webb"))
    ;;               ((gn . "Daniel") (fn . "Schmidt"))
    ;;               ((gn . "Nico") (fn . "Piatowski"))))
    ;;   (year . "2023")
    ;;   (status . "accepted")
    ;;   (path . "2023-icdm")
    ;;   (redirects . (("/code" . "https://gitlab.com/lklee/icdm2023")))
    ;;   ;; (links . (("pdf" . "/assets/pdf/lee2023.pdf")
    ;;   ;;           ("code" . "https://gitlab.com/lklee/comp-div-dm")
    ;;   ;;           ("poster" . "/assets/pdf/lee2023-poster.pdf")))
    ;;   (links . (("code" . "https://gitlab.com/lklee/icdm2023")))
    ;;   (comments . "Accepted to ICDM 2023")))
    ("lee2023a" .
     (
      (status . "accepted")
      (path . "2023-icdm")
      (redirects . (("/code" . "https://gitlab.com/lklee/icdm2023")))
      (links . (("code" . "https://gitlab.com/lklee/icdm2023")))
      (comments . "Accepted to ICDM 2023")
      ))
    ("lee2023" .
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

(define (merge-pubs-biblio pubs biblio)
  (let (( merge
          (lambda (pub)
            (let* ((cur-id (car pub))
                   (cur-pub (cdr pub))
                   (cur-meta (find (lambda (meta)
                                     (equal? (assoc-ref meta 'id) cur-id))
                                   biblio)))
            (fold acons cur-meta (map car cur-pub) (map cdr cur-pub)))
          )))
    (map merge pubs)))

(define pubs-full (merge-pubs-biblio
                   pubs (file->biblio bib-db-json)))



(site #:title "lklee"
      #:domain "lklee.dev"
      #:build-directory "../site"
      #:default-metadata
      '((author . "Loong Kuan Lee")
        (author-cn . "李隆宽")
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
