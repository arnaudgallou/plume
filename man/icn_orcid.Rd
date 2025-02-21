% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/icon.R
\name{icn_orcid}
\alias{icn_orcid}
\title{Create an ORCID icon}
\usage{
icn_orcid(size = 16, bw = FALSE)
}
\arguments{
\item{size}{Size of the icon (in pixels).}

\item{bw}{Should the black and white version of the icon be used?}
}
\value{
A plume icon, i.e. an object with S3 class \code{plm_icon}.
}
\description{
Create an ORCID icon for use with the \code{\link{Plume}} class.
}
\examples{
aut <- Plume$new(encyclopedists, orcid_icon = icn_orcid(bw = TRUE))
}
