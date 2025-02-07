.names <- list(
  internals = list(
    id = "id",
    initials = "initials",
    literal_name = "literal_name",
    corresponding = "corresponding",
    role = "role"
  ),
  primaries = list(
    given_name = "given_name",
    family_name = "family_name"
  ),
  secondaries = list(
    orcid = "orcid",
    email = "email",
    phone = "phone",
    fax = "fax",
    url = "url"
  ),
  nestables = list(
    affiliation = "affiliation",
    note = "note"
  )
)

.col_bullets <- list(
  corresponding = c(
    i = "Did you forget to assign corresponding authors?",
    i = "Use `set_corresponding_authors()` to set corresponding authors."
  )
)

.links <- list(
  crt = c("Contributor Roles Taxonomy", "https://credit.niso.org"),
  quarto_schemas = c(
    "author and affiliations schemas",
    "https://quarto.org/docs/journals/authors.html"
  )
)

link <- function(id) {
  els <- .links[[id]]
  md_link(els[[2]], els[[1]])
}
