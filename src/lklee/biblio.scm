(define-module (lklee biblio)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-43)
  #:use-module (ice-9 textual-ports)
  #:use-module (haunt post)
  #:use-module (haunt artifact)
  #:use-module (haunt html)
  #:use-module (json)
  #:export (file->biblio))


;; Schema

;; Convert a JSON author record into the simpler bibliography alist used
;; throughout the site.
(define (author:j->biblio expr)
  `((gn . ,(assoc-ref expr "given"))
    (fn . ,(assoc-ref expr "family"))))

;; Convert a single CSL-JSON bibliography entry into the site's internal
;; publication metadata format.
(define (bib-item:json->biblio json-bib-item)
  (let* ((venue (assoc-ref json-bib-item "container-title"))
         (type (if venue (assoc-ref json-bib-item "type") "preprint"))
         ;; Convert the JSON author vector into a plain Scheme list of authors.
         (authors:j->biblio
          (lambda (j-authors)
            (vector->list (vector-map
                           (lambda (_ x) (author:j->biblio x))
                           j-authors))))
         ;; Pull the publication year out of CSL-JSON's nested date-parts field.
         (extract-year
          (lambda (j-bib)
            (vector-ref (vector-ref
                         (assoc-ref (assoc-ref j-bib "issued")
                                    "date-parts") 0) 0))))
    `( (id . ,(assoc-ref json-bib-item "id"))
       (doi . ,(assoc-ref json-bib-item "DOI"))
       (type . ,type)
       (title . ,(assoc-ref json-bib-item "title"))
       (abs . ,(assoc-ref json-bib-item "abstract"))
       (authors . ,(authors:j->biblio
                     (assoc-ref json-bib-item "author")))
       (year . ,(extract-year json-bib-item))
       (venue . ,venue)
       (page . ,(assoc-ref json-bib-item "page"))
       (volume . ,(assoc-ref json-bib-item "volume"))
       (issue . ,(assoc-ref json-bib-item "issue")) )))

;; load
;; Load a bibliography JSON file and convert every entry into the site's
;; internal publication format.
(define (file->biblio file-path)
  (vector->list (vector-map (lambda (_ x) (bib-item:json->biblio x))
              (file->json->scm file-path))))


;; Read FILE-PATH as JSON and return the decoded Scheme representation.
(define* (file->json->scm file-path #:key (encoding "UTF-8"))
  (call-with-input-file file-path
    (lambda (port)
      (set-port-encoding! port encoding)
      (json->scm port))
    ))
