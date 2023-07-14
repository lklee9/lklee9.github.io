(define-module (lklee cv content)
  #:use-module (lklee utils)
  #:export (cv-content))

(define (cv-content pubs)
  `(cv-body (cv-section "Education")
            (cv-entry "2019--2023"
                      ("Doctor of Philosophy (PhD)")
                      ("Monash University")
                      ("Melbourne") ()
                      )
            (cv-entry "2015--2018"
                      ("Bachelor of Informatics and "
                       "Computation Advanced (Honours)")
                      ("Monash University")
                      ("Melbourne")
                      ("Final Mark - 88/100")
                      "Specialised in Computer Science and Statistics "
                      (amp)
                      " Probability. Graduated with First Class Honours.")
            (cv-section "Doctoral Thesis")
            (cv-item "title" (em "Computing Divergences between "
                                 "High Dimensional Graphical Models"))
            (cv-item "supervisors" "Geoff Webb, "
                     "Daniel Schmidt, Nico Piatkowski")
            (cv-item "year" "2023")
            (cv-item "descripion" "We develop a method for computing "
                     "the joint, marginal, and conditional "
                     (greeksym "alpha" "beta") "-divergences, a family "
                     "of divergences that include the Kullback-Leibler "
                     "divergence and the Hellinger distance. We then "
                     "apply this method to modifying the parameters of "
                     "a decomposable model such that the resulting "
                     "model is some target amount of divergence away "
                     "from the original.")

            (cv-section "Honours thesis")
            (cv-item "title" (em "Generating Concept Drift by "
                                 "Shuffling Instances"))
            (cv-item "supervisors" "Geoff Webb")
            (cv-item "year" "2018")
            (cv-item "description" "We propose a method for shuffling "
                     "the instances in a dataset such that the "
                     "divergence between the empirical distribution of "
                     "the first and second half of the resulting dataset"
                     " reaches some target amount of divergence.")

            (cv-section "Experience")
            (cv-subsection "Academia")
            (cv-entry "2016--2017" ("Undergraduate Research Assistant")
                      ("Monash University") ("Melbourne") ()
                      ("Researched " (bf "Concept Drift")
                       " , specifically how to measure and visualise "
                       "concept drift in both streaming and static data."
                       (newline) "Tasks:"
                       (cv-list
                        (cv-list-item
                         "Developed a system to incrementally measure "
                         "changes to the probability distributions of "
                         "a data set over time, using " (bf "Java")
                         " and the library " (bf "Weka") ".")
                        (cv-list-item
                         "Developed a companion web application for the"
                         " system above using " (bf "Scala") " with the "
                         (bf "Play Framework") ", " (bf "Javascript")
                         ", and " (bf "HTML")".")
                        (cv-list-item
                         "Used " (bf "R") " extensively to visualise "
                         "results and produce reports."))))
            (cv-subsection "Industry")
            (cv-entry "2016" ("Winter Research Project")
                     ("Agilent " (amp) " Monash University")
                     ("Melbourne") ()
                     "Developed application to compare and analyse "
                     "large groups of timeseries data over the same "
                     "domain, using " (bf "R") " and "(bf "Shiny")".")
            (cv-entry "2017" ("Software Tester") ("Carsales")
                     ("Melbourne") () "Tested backend APIs being "
                     "developed to move product from a monolith to a "
                     "microservice architecture. Helped develop a "
                     "prototype model to predict car deprecation."
                     (newline) "Tasks:"
                     (cv-list
                      (cv-list-item "Created automated tests for APIs "
                                    "in CI pipeline using "
                                    (bf "Postman") ", " (bf "Node.js")
                                    ", and " (bf "Jenkins")".")
                      (cv-list-item "Carried out performance testing "
                                    "of APIs using " (bf "Scala") " and "
                                    (bf "Gatling")".")
                      (cv-list-item "Managed communication across "
                                    "multiple teams to track bugs "
                                    "reported by consumers of the "
                                    "backend APIs and bugs I found in "
                                    "systems the APIs depend on.")
                      (cv-list-item "Developed prototype to predict "
                                    "the depreciation of a car using "
                                    (bf "R") ", " (bf "Azure ML Studio")
                                    ", and " (bf "Vue.js")".")))
            (cv-section "Scholarship " (amp) " Awards")
            (cv-item "2015" "Faculty of IT International Merit Scholarship")
            (cv-item "2015" "Dean's Achievement Award")
            (cv-item "2016"
                     ,(smart-dashes "Summer Research Scholarship --- ")
                     "Faculty of IT")
            (cv-item "2016"
                     ,(smart-dashes "Winter Research Scholarship --- ")
                     "Faculty of IT")
            (cv-item "2017" "Information Technology IBL "
                    "(Industry Based Learning) Placement Scholarship")
            (cv-item "2017" "Dean's Achievement Award")
            (cv-item "2019" "Australian Government RTP "
                     "(Research Training Program) Scholarship")

            (cv-section "Publications")
            (cv-pub-list "Loong Kuan Lee" ,pubs)

            )
            )
