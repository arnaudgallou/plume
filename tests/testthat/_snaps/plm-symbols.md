# plm_symbols() returns a list of symbols

    Code
      str(plm_symbols())
    Output
      List of 3
       $ affiliation  : NULL
       $ corresponding: chr "*"
       $ note         : chr [1:6] "†" "‡" "§" "¶" ...
       - attr(*, "class")= chr [1:2] "plm_list" "list"

# plm_symbols() gives meaningful error messages

    Code
      plm_symbols(affiliation = 1)
    Condition
      Error in `plm_symbols()`:
      ! `affiliation` must be a character vector.

