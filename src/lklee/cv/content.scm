(define-module (lklee cv content)
  #:use-module (lklee utils)
  #:export (cv-content))

;; Return the symbolic CV document tree consumed by the HTML and TeX CV
;; renderers.
(define (cv-content pubs)
  `(cv-body (cv-section "Education")
            (cv-entry "2019--2023"
                      ("Doctor of Philosophy (PhD)")
                      ("Monash University")
                      ("Melbourne") ()
                      )
            (cv-item (small "thesis") (em "Computing Divergences between "
                                 "High Dimensional Graphical Models"))
            (cv-item (small "supervisors") "Geoff Webb, "
                     "Daniel Schmidt, Nico Piatkowski")
            ;; (cv-item (small "description")
            ;;          "We develop a method for computing "
            ;;          "the joint, marginal, and conditional "
            ;;          (greeksym "alpha" "beta") "-divergences between "
            ;;          "high-dimensional graphical models. We then "
            ;;          "apply this method to modifying the parameters of "
            ;;          "a decomposable model such that the resulting "
            ;;          "model is some target amount of divergence away "
            ;;          "from the original.")
            (cv-entry "2015--2018"
                      ("Bachelor of Informatics and "
                       "Computation Advanced (Honours)")
                      ("Monash University")
                      ("Melbourne")
                      ("GPA 3.9/4.0, Graduated with First Class Honours.")
                      )
            (cv-item (small "thesis") (em "Generating Concept Drift by Shuffling Instances."))
            (cv-item (small "majors") "Computer Science, Probability " (amp) " Statistics")

           
            (cv-section "Experience")
            (cv-entry "2023--present" ("Research Associate")
                      ("Fraunhofer IAIS") ("Sankt Augustin, Germany") ()
                      "Researching " (bf "quantum optimisation")
                      ", both in self-directed research "
                      "and in applied projects "
                      "delivered jointly with industry partners."
                      (cv-list
                       (cv-list-item
                        "Proposed and developed a framework "
                        "for incorporating inequality constraints into "
                        (bf "QUBO") " formulations without needing "
                        "additional variables or parameter tuning. "
                        "To appear at " (bf "IEEE QCE 2026") ".")
                       (cv-list-item
                        "Proposed and studied how the competing "
                        "objectives of a "
                        "multi-objective problem can be scaled and "
                        "combined so that the resulting " (bf "QUBO")
                        " preserves the intended trade-off. Published "
                        "at " (bf "IEEE QCE 2025") ".")
                       (cv-list-item
                        "Formulated power-system redispatch as a "
                        "multi-objective " (bf "QUBO") " and evaluated "
                        "it on " (bf "quantum annealing") " hardware, "
                        "in a joint project with a "
                        "professional-services firm and a German "
                        "energy utility company. "
                        "Published at " (bf "IEEE DSAA 2025") ".")
                       (cv-list-item
                        "Contributed to a hybrid quantum-classical "
                        "method for multi-agent pathfinding. Published "
                        "at " (bf "ICML 2025") ".")))
            (cv-entry "2016--2017" ("Undergraduate Research Assistant")
                      ("Monash University") ("Melbourne") ()
                      "Researched how to measure and visualise "
                      (bf "concept drift")
                      " in both streaming and static data. Built a "
                      "system to incrementally measure changes to the "
                      "probability distributions of a data set over "
                      "time, along with a companion web application.")
            (cv-entry "2017" ("Quality Assurance Intern") ("Carsales")
                      ("Melbourne") ()
                      "Created automated tests for the backend APIs "
                      "being developed during migration "
                      "to a microservice architecture. "
                      "Liaised between multiple teams "
                      "to ensure sufficient test coverage."
                      )            
            ;; (cv-entry "2016" ("Winter Research Intern")
            ;;           ("Agilent " (amp) " Monash University")
            ;;           ("Melbourne") ()
            ;;           "Developed application to compare and analyse "
            ;;           "large groups of timeseries data over the same "
            ;;           "domain based on specifications gathered from "
            ;;           "stakeholders at Agilent.")

            (cv-section "Skills")
            (cv-item "quantum" "QUBO formulation, multi-objective "
                     "optimisation, quantum annealing (D-Wave Ocean), "
                     "gate-model circuits (Qiskit), classical "
                     "mixed-integer programming solvers")
            (cv-item "ML" "probabilistic graphical models, "
                     "divergence estimation, concept drift")
            (cv-item "languages" "Python, Julia, Rust, C++, "
                     "JavaScript, Guile Scheme")
            (cv-item "tools" "GNU Emacs, Git, LaTeX, Guix, Linux")
            
            (cv-section "Featured Publications")            
            (cv-pub-list "Loong Kuan Lee" ,pubs "feat")

            (cv-section "Other Publications")
            (cv-pub-list "Loong Kuan Lee" ,pubs "norm")


            ;; (cv-section "Scholarship " (amp) " Awards")
            ;; (cv-item "2015" "Faculty of IT International Merit Scholarship")
            ;; (cv-item "2015" "Dean's Achievement Award")
            ;; (cv-item "2016"
            ;;          ,(smart-dashes "Summer Research Scholarship --- ")
            ;;          "Faculty of IT")
            ;; (cv-item "2016"
            ;;          ,(smart-dashes "Winter Research Scholarship --- ")
            ;;          "Faculty of IT")
            ;; (cv-item "2017" "Information Technology IBL "
            ;;         "(Industry Based Learning) Placement Scholarship")
            ;; (cv-item "2017" "Dean's Achievement Award")
            ;; (cv-item "2019" "Australian Government RTP "
            ;;          "(Research Training Program) Scholarship")


            )
            )
