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
          note: a. c
          attributes:
            corresponding: true
          roles:
            - Formal analysis
            - Writing - original draft
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
            - Formal analysis
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
            - Formal analysis
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
            - Formal analysis
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
            - Formal analysis
          affiliations:
            - ref: aff3
        - id: aut3
          name:
            given: Zip
            family: Zap
          email: zipzap@test.com
          phone: '+1234'
          orcid: 0000-0000-0000-0001
          note: a. c
          attributes:
            corresponding: false
          roles:
            - Formal analysis
            - Writing - original draft
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
        - name:
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

# to_yaml() doesn't add the `affiliations` schema if there're no affiliations

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - name:
            given: Zip
            family: Zap
      ---

# to_yaml() pushes data to empty YAML headers

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - name:
            given: Zip
            family: Zap
          metadata:
            meta-foo: bar
      ---

# to_yaml() preserves line breaks preceding `---` (#37)

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - name:
            given: Zip
            family: Zap
      ---
      Lorem ipsum
      ---

# to_yaml() writes in a separate header to preserve strippable data (#56)

    Code
      read_test_file(tmp_file)
    Output
      ---
      author:
        - name:
            given: Zip
            family: Zap
      ---
      ---
      title: test # this is a title
      foo: >
        Lorem ipsum
        Vivamus quis
      ---

# to_yaml() can push data into YAML files

    Code
      read_test_file(tmp_file)
    Output
      title: foo
      author:
        - name:
            given: Zip
            family: Zap

# to_yaml() properly handles authors with no roles (#81)

    Code
      read_test_file(tmp_file)
    Output
      title: foo
      author:
        - id: aut1
          name:
            given: A
            family: A
          roles:
            - Formal analysis
            - Writing - original draft
        - id: aut2
          name:
            given: B
            family: B
          roles: {}

# to_yaml() errors if no YAML headers is found

    Code
      aut$to_yaml()
    Condition
      Error:
      ! No YAML headers found.
      i YAML headers must be at the beginning of the document.
      i YAML headers must start and end with three hyphens.

# to_yaml() errors if an invalid ORCID identifier is found 

    Code
      aut$to_yaml()
    Condition
      Error:
      ! Invalid ORCID identifier found: `0000`.
      i ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.
      i The last character of the identifiers must be a digit or `X`.

