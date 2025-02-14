# icn_orcid() makes orcid icon metadata

    Code
      read_rendered_md()
    Output
      ---
      title: test
      ---
      
      ``` r
      str(attributes(icn_orcid()))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 16
       $ filename: chr "orcid.pdf"
       $ style   : chr ""
       $ spacing : chr "\\hspace{3pt}"
      
      ``` r
      str(attributes(icn_orcid(size = 24)))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 24
       $ filename: chr "orcid.pdf"
       $ style   : chr ""
       $ spacing : chr "\\hspace{4pt}"
      
      ``` r
      str(attributes(icn_orcid(bw = TRUE)))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 16
       $ filename: chr "orcid-bw.pdf"
       $ style   : chr ""
       $ spacing : chr "\\hspace{3pt}"

---

    Code
      read_rendered_md()
    Output
      ---
      title: test
      ---
      
      ``` r
      str(attributes(icn_orcid()))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 16
       $ filename: chr "orcid.svg"
       $ style   : chr " style='margin: 0 4px; vertical-align: baseline'"
       $ spacing : chr ""
      
      ``` r
      str(attributes(icn_orcid(size = 24)))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 24
       $ filename: chr "orcid.svg"
       $ style   : chr " style='margin: 0 6px; vertical-align: baseline'"
       $ spacing : chr ""
      
      ``` r
      str(attributes(icn_orcid(bw = TRUE)))
      ```
      
      List of 5
       $ class   : chr "plm_icon"
       $ size    : num 16
       $ filename: chr "orcid-bw.svg"
       $ style   : chr " style='margin: 0 4px; vertical-align: baseline'"
       $ spacing : chr ""

# icn_orcid() gives meaningful error messages

    Code
      (expect_error(icn_orcid(size = NULL)))
    Output
      <error/rlang_error>
      Error in `icn_orcid()`:
      ! `size` must be a numeric vector.
    Code
      (expect_error(icn_orcid(bw = 1)))
    Output
      <error/rlang_error>
      Error in `icn_orcid()`:
      ! `bw` must be `TRUE` or `FALSE`.

