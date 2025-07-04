% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plume-handler.R
\name{PlumeHandler}
\alias{PlumeHandler}
\title{PlumeHandler class}
\description{
Internal class processing and shaping tabular data into a
\code{plume} object.
}
\keyword{internal}
\section{Super class}{
\code{plume::NameHandler} -> \code{PlumeHandler}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-PlumeHandler-new}{\code{PlumeHandler$new()}}
\item \href{#method-PlumeHandler-print}{\code{PlumeHandler$print()}}
\item \href{#method-PlumeHandler-data}{\code{PlumeHandler$data()}}
\item \href{#method-PlumeHandler-get_plume}{\code{PlumeHandler$get_plume()}}
\item \href{#method-PlumeHandler-roles}{\code{PlumeHandler$roles()}}
\item \href{#method-PlumeHandler-get_roles}{\code{PlumeHandler$get_roles()}}
\item \href{#method-PlumeHandler-clone}{\code{PlumeHandler$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-new"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$new(
  data,
  names,
  roles,
  credit_roles,
  initials_given_name,
  dotted_initials,
  family_name_first = FALSE,
  distinct_initials = FALSE,
  interword_spacing = TRUE
)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-print"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-print}{}}}
\subsection{Method \code{print()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$print()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-data"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-data}{}}}
\subsection{Method \code{data()}}{
Get the data of a plume object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$data()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
A tibble.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-get_plume"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-get_plume}{}}}
\subsection{Method \code{get_plume()}}{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

Please use \verb{$data()} instead.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$get_plume()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
A tibble.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-roles"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-roles}{}}}
\subsection{Method \code{roles()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$roles()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-get_roles"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-get_roles}{}}}
\subsection{Method \code{get_roles()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$get_roles()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeHandler-clone"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeHandler-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeHandler$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
