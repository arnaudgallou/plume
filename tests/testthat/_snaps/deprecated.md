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
      aut$get_contributions(dotted_initials = TRUE)
    Condition
      Warning:
      The `dotted_initials` argument of `get_contributions()` is deprecated as of plume 0.3.0.
      i Please use the `dotted_initials` argument of `Plume$new()` instead.
    Output
      Formal analysis: Z.Z., R.R. and P.-P.P.
      Writing - original draft: Z.Z.
    Code
      invisible(aut$get_roles())
    Condition
      Warning:
      `get_roles()` was deprecated in plume 0.3.0.
      i Please use `roles()` instead.
    Code
      invisible(aut$get_plume())
    Condition
      Warning:
      `get_plume()` was deprecated in plume 0.3.0.
      i Please use `data()` instead.
    Code
      orcid()
    Condition
      Warning:
      `orcid()` was deprecated in plume 0.2.6.
      i Please use `icn_orcid()` instead.
    Output
      <orcid icon>

