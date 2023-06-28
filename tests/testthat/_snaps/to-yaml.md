# to_yaml() gives meaningful error messages

    Code
      (expect_error(aut$to_yaml(1)))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a character string.
    Code
      (expect_error(aut$to_yaml("")))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a non-empty string.
    Code
      (expect_error(aut$to_yaml("test.pdf")))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a `.qmd` file.

---

    Code
      aut$to_yaml(tmp_file)
    Condition
      Error:
      ! No YAML header found.
      i YAML headers must be at the top of the document.
      i YAML headers must start and end with three hyphens.

