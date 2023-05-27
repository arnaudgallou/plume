# plm_push() gives meaningful error messages

    Code
      (expect_error(plm_push("foo", file = tmp_file)))
    Output
      <error/rlang_error>
      Error:
      ! `x` must be a <plm> object.
    Code
      (expect_error(plm_push(contributions, file = "file.pdf")))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a `.qmd` file.
    Code
      (expect_error(plm_push(contributions, file = tmp_file, where = TRUE)))
    Output
      <error/rlang_error>
      Error:
      ! `where` must be a character string.
    Code
      (expect_error(plm_push(contributions, file = tmp_file, where = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Can't find line `foo`.
    Code
      (expect_error(plm_push(contributions, file = tmp_file, where = "$", sep = TRUE))
      )
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.

