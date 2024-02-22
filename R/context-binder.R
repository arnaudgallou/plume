ContextBinder <- R6Class(
  public = list(
    bind = function(x) {
      private$data <- x
      private$clear(caller_env())
    },

    pull = function() {
      private$check_context()
      private$data
    }
  ),

  private = list(
    data = NULL,

    clear = function(env) {
      expr <- as.call(list(function() private$data <- NULL))
      do.call(on.exit, list(expr), envir = env)
    },

    check_context = function() {
      if (!is.null(private$data)) {
        return(invisible())
      }
      caller <- deparse(rlang::caller_call(2))
      msg <- glue("`{caller}` must be used within a *status setter* method.")
      abort_check(msg = msg)
    }
  )
)
