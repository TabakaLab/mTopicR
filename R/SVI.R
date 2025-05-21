#' @name SVI
#'
#' @title  Perform Stochastic Variational Inference (SVI) for large-scale data.
#'
#' @description SVI divides the dataset into batches and uses stochastic
#'  updates to infer topics. This method is efficient for large datasets
#'  where processing the entire dataset at once is computationally expensive.
#'
#' @param model A MTM model.
#' @param n_batches Number of batches to divide the data into. Default is 100.
#' @param batch_size Number of samples per batch. Smaller batch sizes use less
#'  memory but result in noisier updates. Default is 100.
#' @param tau Initial learning rate for SVI. Default is 1.0.
#' @param kappa Learning rate decay parameter. Typically between 0.5 and 1.0.
#'  Default is 0.75.
#' @param max_iter_d Maximum iterations for the E-step in each SVI update.
#' Default is 100.
#'
#' @return A MTM object.
SVI <- function(
    model,
    n_batches = 100,
    batch_size = 100,
    tau = 1.0,
    kappa = 0.75,
    max_iter_d = 100
){
  model$SVI(
    n_batches = as.integer(n_batches),
    batch_size = as.integer(batch_size),
    tau = tau,
    kappa = kappa,
    max_iter_d = as.integer(max_iter_d))
  return(model)
}
