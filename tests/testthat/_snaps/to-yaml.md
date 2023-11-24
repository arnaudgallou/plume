# to_yaml() injects authors and affiliations into a `.qmd`

    Code
      read_test_file(tmp_file)
    Output
      ---
      title: test
      author:
        - id: aut1
          name:
            given: Zip
            family: Zap
          email: zipzap@test.com
          phone: '+1234'
          orcid: 0000-0000-0000-0001
          note: a, c
          attributes:
            corresponding: true
          roles:
            - formal analysis
            - writing - original draft
          affiliations:
            - ref: aff1
            - ref: aff2
        - id: aut2
          name:
            given: Ric
            family: Rac
          email: ricrac@test.com
          orcid: 0000-0000-0000-0002
          attributes:
            corresponding: false
          roles:
            - formal analysis
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Pim-Pam
            family: Pom
          email: pimpampom@test.com
          note: b
          attributes:
            corresponding: false
          roles:
            - formal analysis
          affiliations:
            - ref: aff1
            - ref: aff4
      affiliations:
        - id: aff1
          name: a
        - id: aff2
          name: b
        - id: aff3
          name: c
        - id: aff4
          name: d
      ---
      
      ```{r}
      #| echo: false
      x <- 1
      ```

---

    Code
      read_test_file(tmp_file)
    Output
      ---
      title: test
      author:
        - id: aut1
          name:
            given: Pim-Pam
            family: Pom
          email: pimpampom@test.com
          note: b
          attributes:
            corresponding: true
          roles:
            - formal analysis
          affiliations:
            - ref: aff1
            - ref: aff2
        - id: aut2
          name:
            given: Ric
            family: Rac
          email: ricrac@test.com
          orcid: 0000-0000-0000-0002
          attributes:
            corresponding: false
          roles:
            - formal analysis
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Zip
            family: Zap
          email: zipzap@test.com
          phone: '+1234'
          orcid: 0000-0000-0000-0001
          note: a, c
          attributes:
            corresponding: false
          roles:
            - formal analysis
            - writing - original draft
          affiliations:
            - ref: aff2
            - ref: aff4
      affiliations:
        - id: aff1
          name: d
        - id: aff2
          name: a
        - id: aff3
          name: c
        - id: aff4
          name: b
      ---
      
      ```{r}
      #| echo: false
      x <- 1
      ```

---

    Code
      read_test_file(tmp_file)
    Output
      ---
      title: test
      author:
        - id: aut1
          name:
            given: Zip
            family: Zap
          affiliations:
            - ref: aff1
            - ref: aff2
            - ref: aff3
      affiliations:
        - id: aff1
          name: a
          department: b
          city: c
          postal-code: d
        - id: aff2
          name: f
          department: g
          city: e
        - id: aff3
          name: h
      ---
      
      ```{r}
      #| echo: false
      x <- 1
      ```

# to_yaml() pushes data to empty YAML headers

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - id: aut1
          name:
            given: Zip
            family: Zap
          metadata:
            meta-foo: bar
      affiliations: {}
      ---

# to_yaml() preserves line breaks preceding `---` (#37)

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - id: aut1
          name:
            given: Zip
            family: Zap
      affiliations: {}
      ---
      Lorem ipsum
      ---

# to_yaml() gives meaningful error messages

    Code
      (expect_error(PlumeQuarto$new(basic_df, file = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a character string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "")))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a non-empty string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "test.rmd")))
    Output
      <error/rlang_error>
      Error:
      ! `file` must be a `.qmd` file.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "~/test.qmd")))
    Output
      <error/rlang_error>
      Error:
      ! `~/test.qmd` doesn't exist.

---

    Code
      aut$to_yaml()
    Condition
      Error:
      ! No YAML headers found.
      i YAML headers must be at the top of the document.
      i YAML headers must start and end with three hyphens.

