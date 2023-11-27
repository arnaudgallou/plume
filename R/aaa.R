.names <- list(
  public = list(
    internals = list(
      id = "id",
      initials = "initials",
      literal_name = "literal_name",
      corresponding = "corresponding"
    ),
    primaries = list(
      given_name = "given_name",
      family_name = "family_name"
    ),
    secondaries = list(
      email = "email",
      phone = "phone",
      fax = "fax",
      url = "url"
    ),
    nestables = list(
      affiliation = "affiliation",
      role = "role",
      note = "note"
    )
  ),
  protected = list(
    orcid = "orcid",
    crt = list(
      conceptualization = "Conceptualization",
      data_curation = "Data curation",
      analysis = "Formal analysis",
      funding = "Funding acquisition",
      investigation = "Investigation",
      methodology = "Methodology",
      administration = "Project administration",
      resources = "Resources",
      software = "Software",
      supervision = "Supervision",
      validation = "Validation",
      visualization = "Visualization",
      writing = "Writing - original draft",
      editing = "Writing - review & editing"
    )
  )
)

.links <- list(
  crt = c("Contributor Roles Taxonomy", "https://credit.niso.org"),
  quarto_schemas = c(
    "author and affiliations schemas",
    "https://quarto.org/docs/journals/authors.html"
  )
)

.deprecations <- list(
  credit_roles = \(caller, param) {
    lifecycle::deprecate_warn(
      "0.2.0",
      what = glue("{caller}(credit_roles)"),
      with = I(glue("`{param} = credit_roles()`"))
    )
  },
  explicit_roles = \() {
    lifecycle::deprecate_warn(
      "0.2.0",
      what = I("Defining explicit roles in the input data"),
      with = "new(roles)",
      details = paste0(
        "See <",
        "https://arnaudgallou.github.io/plume/articles/plume.html",
        "#defining-roles-and-contributors",
        ">."
      )
    )
  }
)

# nocov start
link <- function(id) {
  els <- .links[[id]]
  md_link(els[[2]], els[[1]])
}

print_deprecation <- function(id, ...) {
  do.call(.deprecations[[id]], list(...))
}
# nocov end
