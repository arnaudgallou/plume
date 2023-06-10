# plm_push() inject data to a `.qmd` file.

    Code
      cat(read_file(tmp_file))
    Output
      ---
      title: test
      ---
      # Contributions
      
      <!-- plume contributions: start -->
      
      a: A.X., C.-C.Z. and B.Y.; d: A.X.
      
      <!-- plume contributions: end -->
      
      Lorem ipsum

---

    Code
      cat(read_file(tmp_file))
    Output
      ---
      title: test
      ---
      # Contributions
      
      <!-- plume contributions: start -->
      
      A.X., C.-C.Z. and B.Y. a; A.X. d
      
      <!-- plume contributions: end -->
      
      Lorem ipsum

# plm_push() gives meaningful error messages

    Code
      (expect_error(plm_push("foo", file = tmp_file)))
    Output
      <error/rlang_error>
      Error:
      ! `x` must be a <plm_agt> object.
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

