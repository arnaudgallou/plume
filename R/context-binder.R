ContextBinder <- R6Class(
  public = list(
    bind = function(x) {
      private$data <- x
      private$clear(caller_env())
    },

    pull = function(call, ignore) {
      private$check_context(call)
      out <- private$data
      if (missing(ignore)) {
        return(out)
      }
      drop_from(out, ignore)
    }
  ),

  private = list(
    data = NULL,

    clear = function(env) {
      expr <- as.call(list(function() private$data <- NULL))
      do.call(on.exit, list(expr), envir = env)
    },

    check_context = function(call) {
      if (!is.null(private$data)) {
        return(invisible(NULL))
      }
      msg <- glue("`{call}()` must be used within a `set_*()` method.")
      abort_check(msg = msg)
    }
  )
)
