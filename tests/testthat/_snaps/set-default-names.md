# set_default_names() sets new plume names

    Code
      str(nms)
    Output
      List of 2
       $ public   :List of 4
        ..$ internals  :List of 4
        .. ..$ id           : chr "id"
        .. ..$ initials     : chr "initiales"
        .. ..$ literal_name : chr "nom_complet"
        .. ..$ corresponding: chr "correspondant"
        ..$ primaries  :List of 2
        .. ..$ given_name : chr "prénom"
        .. ..$ family_name: chr "nom"
        ..$ secondaries:List of 4
        .. ..$ email: chr "courriel"
        .. ..$ phone: chr "téléphone"
        .. ..$ fax  : chr "fax"
        .. ..$ url  : chr "url"
        ..$ nestables  :List of 3
        .. ..$ affiliation: chr "affiliation"
        .. ..$ role       : chr "role"
        .. ..$ note       : chr "note"
       $ protected:List of 2
        ..$ orcid: chr "orcid"
        ..$ crt  :List of 14
        .. ..$ conceptualization: chr "Conceptualization"
        .. ..$ data_curation    : chr "Data curation"
        .. ..$ analysis         : chr "Formal analysis"
        .. ..$ funding          : chr "Funding acquisition"
        .. ..$ investigation    : chr "Investigation"
        .. ..$ methodology      : chr "Methodology"
        .. ..$ administration   : chr "Project administration"
        .. ..$ resources        : chr "Resources"
        .. ..$ software         : chr "Software"
        .. ..$ supervision      : chr "Supervision"
        .. ..$ validation       : chr "Validation"
        .. ..$ visualization    : chr "Visualization"
        .. ..$ writing          : chr "Writing - original draft"
        .. ..$ editing          : chr "Writing - review & editing"

# set_default_names() gives meaningful error messages

    Code
      (expect_error(set_default_names(1)))
    Output
      <error/rlang_error>
      Error:
      ! `...` inputs must be character vectors.
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
      (expect_error(set_default_names(.plume_quarto = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `.plume_quarto` must be `TRUE` or `FALSE`.

