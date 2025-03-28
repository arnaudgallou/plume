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
      <error/rlang_error>
      Error in `aut$get_orcids()`:
      ! `compact` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_orcids(icon = 1)))
    Output
      <error/rlang_error>
      Error in `aut$get_orcids()`:
      ! `icon` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_orcids(sep = 1)))
    Output
      <error/rlang_error>
      Error in `aut$get_orcids()`:
      ! `sep` must be a character string.

---

    Code
      aut$get_orcids(icon = FALSE)
    Condition
      Error in `aut$get_orcids()`:
      ! Invalid ORCID identifier found: `0000`.
      i ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.
      i The last character of the identifiers must be a digit or `X`.

---

    Code
      aut$get_orcids()
    Condition
      Error in `aut$get_orcids()`:
      ! Column `orcid` doesn't exist.

