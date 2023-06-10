# nocov start
.onLoad <- function(...) {
  vctrs::s3_register("waldo::compare_proxy", "plm")
  invisible()
}
# nocov end
