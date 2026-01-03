# Create an ORCID icon

Create an ORCID icon for use with the
[`Plume`](https://arnaudgallou.github.io/plume/dev/reference/Plume.md)
class. This is only supported in R Markdown.

## Usage

``` r
icn_orcid(size = 16, bw = FALSE)
```

## Arguments

- size:

  Size of the icon (in pixels).

- bw:

  Should the black and white version of the icon be used?

## Value

A plume icon, i.e. an object with S3 class `plm_icon`.

## Examples

``` r
aut <- Plume$new(encyclopedists, orcid_icon = icn_orcid(bw = TRUE))
```
