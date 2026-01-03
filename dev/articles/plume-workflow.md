# plume workflow

## Data

plume is designed to work with spreadsheets, which makes it easy to
store, maintain and share data with co-authors. I recommend using
[Google Sheets](https://docs.google.com/spreadsheets/) to take advantage
of the R interface provided by the
[googlesheets4](https://googlesheets4.tidyverse.org) package.

First, you’ll need to create a spreadsheet.
[`plm_template()`](https://arnaudgallou.github.io/plume/dev/reference/plm_template.md)
provides a default template for that purpose.

``` r
googlesheets4::gs4_create(
  name = "authors",
  sheets = plm_template()
)
```

The above will create a sheet named `authors` with the columns defined
by
[`plm_template()`](https://arnaudgallou.github.io/plume/dev/reference/plm_template.md).

Enter your information and share the sheet with your collaborators so
they can add theirs too.

Note that if it’s the first time you use googlesheets4, you’ll need to
grant the package permission to work with Google Sheets. You can read
more about googlesheets4 authentication
[here](https://googlesheets4.tidyverse.org/reference/gs4_auth.html).

Once the sheet is online, use `read_sheet()` to read it in R.

``` r
googlesheets4::read_sheet("sheet_id")
```

## Set up

### Plume

If you use `Plume`, put the code directly in your R Markdown or Quarto
document as shown in the example below:

```` default
---
title: An awesome publication
execute:
  echo: false
---

```{r}
#| label: setup
#| include: false

library(plume)

tbl_authors <- googlesheets4::read_sheet("sheet_id")

aut <- Plume$new(tbl_authors)
aut$set_corresponding_authors(1)
```

`r aut$get_author_list("^a,^co")`

```{r}
#| results: asis
as_lines(aut$get_affiliations())
```

\*Correspondence to: `r aut$get_contact_details()`

## Main text

Lorem ipsum...

## Contributions

```{r}
#| results: asis
as_lines(aut$get_contributions())
```
````

To modify author data, simply edit the spreadsheet. All author
information in the document will update automatically the next time you
render it.

### PlumeQuarto

If you use `PlumeQuarto` to add or update author information in a Quarto
document, you’ll have to pass the data from a separate R script.

``` r
library(plume)

tbl_authors <- googlesheets4::read_sheet("sheet_id")

aut <- PlumeQuarto$new(tbl_authors, file = "file.qmd")
aut$set_corresponding_authors(1)
aut$to_yaml()
```

Remember to run the script everytime the spreadsheet is updated to
implement the changes in your document.
