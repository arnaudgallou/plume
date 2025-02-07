# set_default_names() sets new plume names

    Code
      str(nms)
    Output
      List of 4
       $ internals  :List of 6
        ..$ id              : chr "id"
        ..$ initials        : chr "initiales"
        ..$ literal_name    : chr "nom_complet"
        ..$ corresponding   : chr "correspondant"
        ..$ role            : chr "role"
        ..$ contributor_rank: chr "rang_contributeur"
       $ primaries  :List of 2
        ..$ given_name : chr "prénom"
        ..$ family_name: chr "nom"
       $ secondaries:List of 5
        ..$ orcid: chr "orcid"
        ..$ email: chr "courriel"
        ..$ phone: chr "téléphone"
        ..$ fax  : chr "fax"
        ..$ url  : chr "url"
       $ nestables  :List of 2
        ..$ affiliation: chr "affiliation"
        ..$ note       : chr "note"

# set_default_names() gives meaningful error messages

    Code
      (expect_error(set_default_names()))
    Output
      <error/rlang_error>
      Error:
      ! `...` must not be empty.
    Code
      (expect_error(set_default_names(1)))
    Output
      <error/rlang_error>
      Error:
      ! `...` must be a character vector.
    Code
      (expect_error(set_default_names("a")))
    Output
      <error/rlang_error>
      Error:
      ! All `...` inputs must be named.
    Code
      (expect_error(set_default_names(x = "a", y = "a")))
    Output
      <error/rlang_error>
      Error:
      ! `...` must have unique input values.
    Code
      (expect_error(set_default_names(x = "a", x = "b")))
    Output
      <error/rlang_error>
      Error:
      ! `...` must have unique input names.
    Code
      (expect_error(set_default_names(given_name = "nom", .plume_quarto = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `.plume_quarto` must be `TRUE` or `FALSE`.

