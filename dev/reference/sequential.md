# Control the sequencing behaviour of character vectors

Modifier function used to generate logical sequences of characters.

## Usage

``` r
sequential(x)
```

## Arguments

- x:

  A character vector.

## Value

A character vector with parent S3 class `sequential`.

## Examples

``` r
aut <- Plume$new(
  tibble::tibble(
    given_name = "X",
    family_name = "Y",
    affiliation = 1:60
  ),
  symbols = plm_symbols(affiliation = sequential(letters))
)

aut$get_affiliations(sep = ": ", superscript = FALSE)
#> a: 1
#> b: 2
#> c: 3
#> d: 4
#> e: 5
#> f: 6
#> g: 7
#> h: 8
#> i: 9
#> j: 10
#> k: 11
#> l: 12
#> m: 13
#> n: 14
#> o: 15
#> p: 16
#> q: 17
#> r: 18
#> s: 19
#> t: 20
#> u: 21
#> v: 22
#> w: 23
#> x: 24
#> y: 25
#> z: 26
#> aa: 27
#> ab: 28
#> ac: 29
#> ad: 30
#> ae: 31
#> af: 32
#> ag: 33
#> ah: 34
#> ai: 35
#> aj: 36
#> ak: 37
#> al: 38
#> am: 39
#> an: 40
#> ao: 41
#> ap: 42
#> aq: 43
#> ar: 44
#> as: 45
#> at: 46
#> au: 47
#> av: 48
#> aw: 49
#> ax: 50
#> ay: 51
#> az: 52
#> ba: 53
#> bb: 54
#> bc: 55
#> bd: 56
#> be: 57
#> bf: 58
#> bg: 59
#> bh: 60
```
