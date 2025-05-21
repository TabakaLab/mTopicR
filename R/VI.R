#' @name VI
#'
#' @title Perform Variational Inference (VI) to infer topics from the data.
#'
#' @description VI is a deterministic approximation method that updates the
#'  model’s variational parameters over several iterations to optimize its fit
#'  to the data. Use VI for moderate-sized datasets where the full dataset can
#'  be used in each iteration.
#'
#' @param model An MTM or sMTM model.
#' @param n_iter Number of iterations for the VI algorithm. Default is 20.
#' @param max_iter_d Maximum iterations for the E-step in each VI update.
#'  Controls convergence criteria. Default is 100.
#'
#' @return MTM or sMTM object.
VI <- function(
    model,
    n_iter = 20,
    max_iter_d = 100
){
  model$VI(
    n_iter = as.integer(n_iter),
    max_iter_d = as.integer(max_iter_d)
  )
  return(model)
}
