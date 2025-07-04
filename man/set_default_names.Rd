% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set-default-names.R
\name{set_default_names}
\alias{set_default_names}
\title{Set new default names to a plume subclass}
\usage{
set_default_names(..., .plume_quarto = FALSE)
}
\arguments{
\item{...}{Key-value pairs where keys are default names and values their
respective replacements.}

\item{.plume_quarto}{Are you setting new names for \code{\link{PlumeQuarto}}?}
}
\value{
A named list.
}
\description{
This helper function allows you to set new default names to a
plume subclass, e.g. to set default names to a language other than English.
}
\details{
Available names are:

\code{id}, \code{initials}, \code{literal_name}, \code{corresponding}, \code{role}, \code{contributor_rank}, \code{given_name}, \code{family_name}, \code{orcid}, \code{email}, \code{phone}, \code{fax}, \code{url}, \code{affiliation}, \code{note}.

Using \code{.plume_quarto = TRUE} adds \code{deceased}, \code{equal_contributor}, \code{number},
\code{dropping_particle} and \code{acknowledgements}.
}
\examples{
# Extending `Plume` with default names in French
PlumeFr <- R6::R6Class(
  classname = "PlumeFr",
  inherit = Plume,
  private = list(
    names = set_default_names(
      initials = "initiales",
      literal_name = "nom_complet",
      corresponding = "correspondant",
      given_name = "prénom",
      family_name = "nom",
      email = "courriel",
      phone = "téléphone"
    )
  )
)

PlumeFr$new(encyclopedists_fr)
}
