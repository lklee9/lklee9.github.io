(define-module (lklee site components)
  #:use-module (srfi srfi-19)
  #:export (html-head
            html-header-nav
            html-footer
            html-side-info))

(define* (html-head title #:key (redirect-url #f))
  `(head
    (meta (@ (charset "utf-8"))
    (meta (@ (name "viewport")
                  ,(if redirect-url '(http-equiv "refresh")
                       '(http-equiv "content-type"))
                  ,(if redirect-url
                       `(content ,(string-append "0;URL=" redirect-url))
                       '(content
                         "width=device-width, initial-scale=1.0"))
                  (content "width=device-width")
                  ))
         (link (@ (rel "stylesheet")
                  (type "text/css")
                  (href "/assets/styles.css")))
         (title ,title))))


(define (html-header-nav cur-page-title)
  `(nav (a (@ (class ,(if (equal? cur-page-title "home")
                         "current" "not-current"))
             (href "/") (title "Home"))
          "Home")
       (a (@ (class ,(if (equal? cur-page-title "cv")
                         "current" "not-current"))
             (href "/cv/cv.html") (title "CV"))
          "CV"))
  )

(define html-footer
  `(footer (@ (class "full-page"))
          "Made with the static site generator "
          (a (@ (href "https://dthompson.us/projects/haunt.html"))
             "Haunt")
          " written in "
          (a (@ (href "https://gnu.org/software/guile"))
             "Guile Scheme")
          "." (br) (br)
          "Last modified: "
          (a (@ (href "https://github.com/lklee9/lklee9.github.io"))
             ,(date->string (current-date) "~1"))))

(define (ext-link site username link)
  `((dt ,site) (dd (a (@ (rel "me") (href ,link) (align "right"))
                      ,username))))

(define (ext-links . links)
  `(d1 (@ (class "external-links"))
       ,@(apply append (map (lambda (l) (apply ext-link l) ) links))
       ))

(define html-side-info
  `(div (@ (id "sidebar-right"))
        (p "
I am currently a research assistant at Fraunhofer IAIS in Germany
working on Quantum Machine Learning. Prior to that, I did my PhD at
Monash University in Australia where I developed methods for
computing divergences in probabilistic graphical models. My
areas of interest include quantum computing, concept drift, and
probabilistic graphical models.")
        ,(ext-links
          '("email" "mail@lklee.dev" "mailto:mail@lklee.dev")
          '("github" "lklee9" "https://github.com/lklee9")
          '("gitlab" "lklee" "https://gitlab.com/lklee")
          '("mastodon" "@lklee@sigmoid.social" "https://sigmoid.social/@lklee")))
  )
