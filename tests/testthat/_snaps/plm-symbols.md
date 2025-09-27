# plm_symbols() returns a list of symbols

    Code
      plm_symbols()
    Output
      $affiliation
      NULL
      
      $corresponding
      [1] "*"
      
      $note
      [1] "†"  "‡"  "§"  "¶"  "#"  "**"
      

# plm_symbols() gives meaningful error messages

    Code
      plm_symbols(affiliation = 1)
    Condition
      Error in `plm_symbols()`:
      ! `affiliation` must be a character vector.

