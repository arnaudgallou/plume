#' Famous encyclopedists
#'
#' Data on four famous authors of the Encyclopédie (originally "Encyclopédie, ou
#' dictionnaire raisonné des sciences, des arts et des métiers") published in
#' France in the second half of the 18th century. The data set is available in
#' English (`encyclopedists`) and French (`encyclopedists_fr`).
#'
#' @format A tibble with 4 rows and 12 variables:
#' \describe{
#'   \item{given_name,prénom}{authors' given names}
#'   \item{family_name,nom}{authors' family names}
#'   \item{email,courriel}{authors' email addresses}
#'   \item{phone,téléphone}{authors' phone numbers}
#'   \item{orcid}{authors' ORCID}
#'   \item{affiliation}{authors' affiliations}
#'   \item{role_n}{authors' roles written as nouns}
#'   \item{role_v}{authors' roles written as active verbs}
#'   \item{note}{special notes about authors}
#' }
#' @examples
#' encyclopedists
#'
#' encyclopedists_fr
"encyclopedists"

#' @rdname encyclopedists
#' @format NULL
"encyclopedists_fr"
