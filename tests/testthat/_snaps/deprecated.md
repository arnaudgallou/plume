# deprecated objects generate informative errors

    Code
      aut <- PlumeQuarto$new(basic_df, temp_file())
      aut$set_equal_contributor(1)
    Condition
      Error:
      ! `set_equal_contributor()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use `set_cofirst_authors()` instead.
    Code
      aut <- Plume$new(basic_df)
      aut$set_corresponding_authors(zip, by = "given_name")
    Condition
      Error:
      ! The `by` argument of `set_corresponding_author()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use the `.by` argument instead.
    Code
      aut$get_author_list(format = "a")
    Condition
      Error:
      ! The `format` argument of `get_author_list()` was deprecated in plume 0.2.1 and is now defunct.
      i Please use the `suffix` argument instead.
    Code
      Plume$new(data.frame(given_name = "X", family_name = "Y", role = "a"))
    Condition
      Error:
      ! Defining explicit roles in the input data was deprecated in plume 0.2.0 and is now defunct.
      i Please use the `roles` argument of `new()` instead.
      i See <https://arnaudgallou.github.io/plume/articles/plume.html#defining-roles-and-contributors>.
    Code
      Plume$new(basic_df, credit_roles = TRUE)
    Condition
      Error:
      ! The `credit_roles` argument of `new()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use `roles = credit_roles()` instead.
    Code
      plm_template(credit_roles = TRUE)
    Condition
      Error:
      ! The `credit_roles` argument of `plm_template()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use `role_cols = credit_roles()` instead.
    Code
      everyone_but()
    Condition
      Error:
      ! `everyone_but()` was deprecated in plume 0.2.0 and is now defunct.

