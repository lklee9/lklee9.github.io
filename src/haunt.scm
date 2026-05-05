(use-modules (srfi srfi-1)
             (srfi srfi-19)
             (haunt asset)
             (haunt post)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
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

(define me "Loong Kuan Lee")
(define bib-db-json "./assets/pubs.json")


;; Hand-curated publication metadata that augments the JSON bibliography.
(define pubs
  '(
    ("muecke2025Quantum" . (
     (status . "coauthored")
     (path . "2025-qce-a")
     ))
    ("lee2025Standardization" . (
     (status . "authored")
     (path . "2025-qce")
     (links . (("code" . "https://gitlab.com/lklee/qubo-standardization")
               ("pdf" . "https://arxiv.org/abs/2504.12419")))
     ))
    ("lee2025Multi" . (
     (status . "authored")
     (path . "2025-dsaa")
     (links . (("code" . "https://gitlab.com/lklee/quantum-power-redispatch")
               ("pdf" . "https://arxiv.org/abs/2409.09857")))
     ))
    ("gerlach2025Hybrid" . (
     (status . "coauthored") 
     (path . "2025-icml")
     (links . (("pdf". "https://proceedings.mlr.press/v267/gerlach25a.html")))
     ))
    ("lee2024Computing" .
     (
      (status . "authored")
      (path . "2024-kais")
      ;; (redirects . (("/code" . "https://gitlab.com/lklee/icdm2023")))
      ;; (links . (("code" . "https://gitlab.com/lklee/icdm2023")
      ;;           ("pdf" . "https://arxiv.org/pdf/2310.09129v1")))
      ))
    ("lee2023Computinga" .
     (
      (status . "authored")
      (path . "2023-icdm")
      (links . (("code" . "https://gitlab.com/lklee/icdm2023")
                ("pdf" . "https://arxiv.org/pdf/2310.09129v1")))
      ))
    ("lee2023Computing" .
     ((status . "authored")
      (path . "2023-aaai")
      (links . (("pdf" . "/assets/pdf/lee2023.pdf")
                ("code" . "https://gitlab.com/lklee/comp-div-dm")
                ("poster" . "/assets/pdf/lee2023-poster.pdf")))
      ;; (comments . "Presentation")
      ))
    ("webb2018Analyzing" .
     ((status . "coauthored")
      (path . "2018-dmkd")
      (links . (("pdf" . "/assets/pdf/webb2018.pdf")
                ("code" . "https://github.com/lklee9/DriftMapper")))))
    ))

;; Earlier merge helper that overlays per-publication metadata onto
;; bibliography entries keyed by id.
(define (merge-pubs-biblio pubs biblio)
  ;; Merge one bibliography record with any matching hand-written metadata.
  (let ((merge (lambda (pub)
                 (let ((cur-meta (assoc-ref pubs (assoc-ref pub 'id))))
                   (fold acons pub (map car cur-meta) (map cdr cur-meta))))))
    (map merge biblio)))

;; Merge each publication entry in PUBS with its matching bibliography
;; record from BIBLIO to produce the complete metadata used by the site.
(define (merge-pubs-biblio pubs biblio)
  ;; Merge one publication metadata pair with its bibliography record.
  (let ((merge
         (lambda (pub)
           (let* ((cur-id (car pub))
                  (cur-pub (cdr pub))
                  (cur-meta (find (lambda (meta)
                                    (equal? (assoc-ref meta 'id) cur-id))
                                  biblio)))
             (fold acons cur-meta (map car cur-pub) (map cdr cur-pub))))))
    (map merge pubs)))

;; Fully merged publication records consumed by the site builders.
(define pubs-full (merge-pubs-biblio
                   pubs (file->biblio bib-db-json)))



(site #:title "lklee"
      #:domain "lklee.dev"
      #:build-directory "../site"
      #:default-metadata
      '((author . "Loong Kuan Lee")
        (author-cn . "李隆宽")
        (email  . "mail@lklee.dev"))
      #:readers (list )
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
