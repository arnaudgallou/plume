# deprecated functionalities generate informative errors

    Code
      aut <- Plume$new(basic_df)
      aut$set_corresponding_authors(1)
      aut$get_contact_details(format = "{name} {details}")
    Condition
      Warning:
      The `format` argument of `get_contact_details()` is deprecated as of plume 0.2.6.
      i Please use the `template` argument instead.
    Output
      Zip Zap zipzap@test.com
    Code
      orcid()
    Condition
      Warning:
      `orcid()` was deprecated in plume 0.2.6.
      i Please use `icn_orcid()` instead.
    Output
      <orcid icon>

