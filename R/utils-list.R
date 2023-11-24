list_fetch_all <- function(x, ..., squash) {
  out <- list()
  for (name in c(...)) {
    out <- c(out, list_fetch(x, name))
  }
  if (squash) {
    return(squash(out))
  }
  out
}

list_fetch <- function(x, name) {
  out <- NULL
  for (i in names(x)) {
    x_i <- x[[i]]
    if (length(out)) {
      break
    } else if (i == name) {
      out <- if (length(x_i) > 1L) x_i else x[i]
    } else if (is.list(x_i)) {
      out <- list_fetch(x_i, name)
    }
  }
  out
}

list_replace <- function(x, y) {
  for (i in names(x)) {
    if (i == "protected") {
      next
    }
    x_i <- x[[i]]
    if (is.list(x_i)) {
      list_slice(x, i) <- list_replace(x_i, y)
    } else if (any(names(y) == i)) {
      list_slice(x, i) <- y[[i]]
    }
  }
  x
}

`list_slice<-` <- function(x, i, value) {
  if (is.null(value)) {
    x[i] <- list(NULL)
  } else {
    x[[i]] <- value
  }
  x
}
