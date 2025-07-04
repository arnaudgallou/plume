% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plume-quarto.R
\name{PlumeQuarto}
\alias{PlumeQuarto}
\title{PlumeQuarto class}
\description{
Class that pushes author metadata in YAML files or the YAML
header of Quarto files.
}
\examples{
# Create a simple temporary file with a YAML header
# containing a title
tmp_file <- tempfile(fileext = ".qmd")
readr::write_lines("---\ntitle: Encyclopédie\n---", tmp_file)

# View the temporary file
cat(readr::read_file(tmp_file))

# Create a PlumeQuarto instance using the temporary file
# you've just created
aut <- PlumeQuarto$new(
  encyclopedists,
  file = tmp_file
)

# And push author data to the YAML header
aut$to_yaml()

cat(readr::read_file(tmp_file))

# Pushing again with new data updates the YAML
# header accordingly
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 2),
  file = tmp_file
)
aut$to_yaml()

cat(readr::read_file(tmp_file))

# Clean up the temporary file
unlink(tmp_file)
}
\section{Super classes}{
\code{plume::NameHandler} -> \code{\link[plume:PlumeHandler]{plume::PlumeHandler}} -> \code{\link[plume:StatusSetter]{plume::StatusSetter}} -> \code{\link[plume:StatusSetterPlumeQuarto]{plume::StatusSetterPlumeQuarto}} -> \code{PlumeQuarto}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-PlumeQuarto-new}{\code{PlumeQuarto$new()}}
\item \href{#method-PlumeQuarto-to_yaml}{\code{PlumeQuarto$to_yaml()}}
\item \href{#method-PlumeQuarto-clone}{\code{PlumeQuarto$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="plume" data-topic="PlumeHandler" data-id="data"><a href='../../plume/html/PlumeHandler.html#method-PlumeHandler-data'><code>plume::PlumeHandler$data()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="PlumeHandler" data-id="get_plume"><a href='../../plume/html/PlumeHandler.html#method-PlumeHandler-get_plume'><code>plume::PlumeHandler$get_plume()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="PlumeHandler" data-id="get_roles"><a href='../../plume/html/PlumeHandler.html#method-PlumeHandler-get_roles'><code>plume::PlumeHandler$get_roles()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="PlumeHandler" data-id="print"><a href='../../plume/html/PlumeHandler.html#method-PlumeHandler-print'><code>plume::PlumeHandler$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="PlumeHandler" data-id="roles"><a href='../../plume/html/PlumeHandler.html#method-PlumeHandler-roles'><code>plume::PlumeHandler$roles()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="StatusSetter" data-id="set_corresponding_authors"><a href='../../plume/html/StatusSetter.html#method-StatusSetter-set_corresponding_authors'><code>plume::StatusSetter$set_corresponding_authors()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="StatusSetterPlumeQuarto" data-id="set_cofirst_authors"><a href='../../plume/html/StatusSetterPlumeQuarto.html#method-StatusSetterPlumeQuarto-set_cofirst_authors'><code>plume::StatusSetterPlumeQuarto$set_cofirst_authors()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="StatusSetterPlumeQuarto" data-id="set_deceased"><a href='../../plume/html/StatusSetterPlumeQuarto.html#method-StatusSetterPlumeQuarto-set_deceased'><code>plume::StatusSetterPlumeQuarto$set_deceased()</code></a></span></li>
<li><span class="pkg-link" data-pkg="plume" data-topic="StatusSetterPlumeQuarto" data-id="set_equal_contributor"><a href='../../plume/html/StatusSetterPlumeQuarto.html#method-StatusSetterPlumeQuarto-set_equal_contributor'><code>plume::StatusSetterPlumeQuarto$set_equal_contributor()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeQuarto-new"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeQuarto-new}{}}}
\subsection{Method \code{new()}}{
Create a \code{PlumeQuarto} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeQuarto$new(
  data,
  file,
  names = NULL,
  roles = credit_roles(),
  credit_roles = FALSE,
  initials_given_name = FALSE,
  dotted_initials = TRUE,
  by = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{A data frame containing author-related data.}

\item{\code{file}}{A \code{.qmd}, \code{.yml} or \code{.yaml} file to insert author data into.}

\item{\code{names}}{A vector of key-value pairs specifying custom names to use,
where keys are default names and values their respective replacements.}

\item{\code{roles}}{A vector of key-value pairs defining roles where keys
identify columns and values describe the actual roles to use.}

\item{\code{credit_roles}}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

It is now recommended to use \code{roles = credit_roles()} to use the
\href{https://credit.niso.org}{Contributor Roles Taxonomy}.}

\item{\code{initials_given_name}}{Should the initials of given names be used?}

\item{\code{dotted_initials}}{Should initials be dot-separated?}

\item{\code{by}}{A character string defining the default variable used to assign
specific metadata to authors in all \verb{set_*()} methods. By default, uses
authors' id.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \code{PlumeQuarto} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeQuarto-to_yaml"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeQuarto-to_yaml}{}}}
\subsection{Method \code{to_yaml()}}{
Push or update author information in a YAML file or YAML
header. The generated YAML complies with Quarto's
\href{https://quarto.org/docs/journals/authors.html}{author and affiliations schemas}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeQuarto$to_yaml()}\if{html}{\out{</div>}}
}

\subsection{Details}{
If missing, \code{to_yaml()} inserts author information into the desired file.
Otherwise, the function replaces old \code{author} and \code{affiliations} values
with the ones provided in the input data.
}

\subsection{Returns}{
The input \code{file} invisibly.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PlumeQuarto-clone"></a>}}
\if{latex}{\out{\hypertarget{method-PlumeQuarto-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PlumeQuarto$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
