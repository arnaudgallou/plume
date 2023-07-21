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
          orcid: 0000-0000-0000-0001
          email: zipzap@test.tst
          phone: '00'
          note: a, c
          attribute:
            corresponding: true
          affiliations:
            - ref: aff1
            - ref: aff2
        - id: aut2
          name:
            given: Ric
            family: Rac
          orcid: 0000-0000-0000-0002
          email: ricrac@test.tst
          attribute:
            corresponding: false
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Pim-Pam
            family: Pom
          email: pimpampom@test.tst
          note: b
          attribute:
            corresponding: false
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
          email: pimpampom@test.tst
          note: b
          attribute:
            corresponding: true
          affiliations:
            - ref: aff1
            - ref: aff2
        - id: aut2
          name:
            given: Ric
            family: Rac
          orcid: 0000-0000-0000-0002
          email: ricrac@test.tst
          attribute:
            corresponding: false
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Zip
            family: Zap
          orcid: 0000-0000-0000-0001
          email: zipzap@test.tst
          phone: '00'
          note: a, c
          attribute:
            corresponding: false
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
            given: X
            family: Z
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

---

    Code
      read_test_file(tmp_file)
    Output
      ---
      title: test
      author:
        - id: aut1
          name:
            given: X
            family: Z
          metadata:
            meta-foo: Bar
      affiliations: {}
      ---
      
      ```{r}
      #| echo: false
      x <- 1
      ```

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

