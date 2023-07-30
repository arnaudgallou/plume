.names <- list(
  protected = list(
    crt = list(
      conceptualization = "Conceptualization",
      curation = "Data curation",
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
  crt = c("Contributor Roles Taxonomy", "https://credit.niso.org")
)

link <- function(id) {
  els <- .links[[id]]
  md_link(els[2], els[1])
}
