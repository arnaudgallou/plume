# to_yaml() injects authors and affiliations into a `.qmd`

    Code
      read_test_file(tmp_file)
    Output
      ---
      title: test
      author:
        - id: aut1
          name:
            given: Aa
            family: Xx
          email: a@x.foo
          phone: '00'
          note: a
          attribute:
            corresponding: true
          affiliations:
            - ref: aff1
            - ref: aff2
        - id: aut2
          name:
            given: Cc-Ca
            family: Zz
          email: c@z.foo
          attribute:
            corresponding: false
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Bb
            family: Yy
          email: b@y.foo
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
          name: d
        - id: aff3
          name: b
        - id: aff4
          name: c
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
            given: Cc-Ca
            family: Zz
          email: c@z.foo
          attribute:
            corresponding: true
          affiliations:
            - ref: aff1
        - id: aut2
          name:
            given: Bb
            family: Yy
          email: b@y.foo
          note: b
          attribute:
            corresponding: false
          affiliations:
            - ref: aff2
            - ref: aff3
        - id: aut3
          name:
            given: Aa
            family: Xx
          email: a@x.foo
          phone: '00'
          note: a
          attribute:
            corresponding: false
          affiliations:
            - ref: aff3
            - ref: aff4
      affiliations:
        - id: aff1
          name: b
        - id: aff2
          name: c
        - id: aff3
          name: a
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
            given: Cc-Ca
            family: Zz
          email: c@z.foo
          affiliations:
            - ref: aff1
      affiliations:
        - id: aff1
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
          note: a, b
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

