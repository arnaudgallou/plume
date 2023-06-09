% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sequence.R
\name{sequential}
\alias{sequential}
\title{Control sequencing behaviour of vectors}
\usage{
sequential(x)
}
\arguments{
\item{x}{A character vector.}
}
\description{
Modifier function used to generate logical sequences of characters.
}
\examples{
aut <- Plume$new(
  tibble::tibble(given_name = "X", family_name = "Y", affiliation = 1:60),
  symbols = list(affiliation = sequential(letters))
)

aut$get_affiliations(sep = ": ", superscript = FALSE) |> cat(sep = "\n")
}
