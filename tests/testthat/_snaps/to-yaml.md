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
      ! Invalid YAML header.
      i Did you forget to separate the YAML header with three hyphens?

