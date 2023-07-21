# get_orcids() returns authors' ORCID

    Code
      aut$get_orcids()
    Output
      Zip Zap[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0001)<https://orcid.org/0000-0000-0000-0001>
      Ric Rac[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0002)<https://orcid.org/0000-0000-0000-0002>

---

    Code
      aut$get_orcids(sep = " - ")
    Output
      Zip Zap - [\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0001)<https://orcid.org/0000-0000-0000-0001>
      Ric Rac - [\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0002)<https://orcid.org/0000-0000-0000-0002>

---

    Code
      aut$get_orcids(icon = FALSE)
    Output
      Zip Zap<https://orcid.org/0000-0000-0000-0001>
      Ric Rac<https://orcid.org/0000-0000-0000-0002>

---

    Code
      aut$get_orcids(icon = FALSE, compact = TRUE)
    Output
      Zip Zap[0000-0000-0000-0001](https://orcid.org/0000-0000-0000-0001)
      Ric Rac[0000-0000-0000-0002](https://orcid.org/0000-0000-0000-0002)

# get_orcids() gives meaningful error messages

    Code
      (expect_error(aut$get_orcids(compact = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      Caused by error:
      ! `compact` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_orcids(icon = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 2.
      Caused by error:
      ! `icon` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_orcids(sep = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.

