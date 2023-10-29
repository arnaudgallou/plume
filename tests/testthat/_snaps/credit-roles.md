# credit_roles() returns CRediT roles

    Code
      credit_roles()
    Output
                 conceptualization                data_curation 
               "Conceptualization"              "Data curation" 
                          analysis                      funding 
                 "Formal analysis"        "Funding acquisition" 
                     investigation                  methodology 
                   "Investigation"                "Methodology" 
                    administration                    resources 
          "Project administration"                  "Resources" 
                          software                  supervision 
                        "Software"                "Supervision" 
                        validation                visualization 
                      "Validation"              "Visualization" 
                           writing                      editing 
        "Writing - original draft" "Writing - review & editing" 

---

    Code
      credit_roles(oxford_spelling = FALSE)
    Output
                 conceptualisation                data_curation 
               "Conceptualisation"              "Data curation" 
                          analysis                      funding 
                 "Formal analysis"        "Funding acquisition" 
                     investigation                  methodology 
                   "Investigation"                "Methodology" 
                    administration                    resources 
          "Project administration"                  "Resources" 
                          software                  supervision 
                        "Software"                "Supervision" 
                        validation                visualisation 
                      "Validation"              "Visualisation" 
                           writing                      editing 
        "Writing - original draft" "Writing - review & editing" 

# credit_roles() gives meaningful error messages

    Code
      credit_roles(oxford_spelling = 1)
    Condition
      Error:
      ! `oxford_spelling` must be `TRUE` or `FALSE`.

