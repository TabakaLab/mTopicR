#' @name feature_associations
#'
#' @title Cross-modality feature associations.
#'
#' @description Learns a feature-level probabilistic mapping from one modality
#'  to another using KL divergence minimization with regularization. The
#'  optimization is done independently for each feature in A. The result is a
#'  sparse matrix showing how features in modality B (columns) associate with
#'  features in modality A (rows). The model applies softmax-based weighting
#'  with optional entropy and sparsity regularization.
#'
#' @param A Topic-feature matrix of modality A.
#' @param A_var DataFrame from modality A, used for column names.
#' @param B Topic-feature matrix of modality B.
#' @param B_var DataFrame from modality B, used for row names.
#' @param mask Optional boolean mask (shape: n_features_B x n_features_A)
#'  specifying which feature pairs to consider (default: NULL).
#' @param n_epochs Number of optimization steps per target feature
#'  (default: 10000).
#' @param lambda_reg Regularization coefficient for sparsity
#'  (default: 1e-4).
#' @param lambda_entropy Regularization coefficient for entropy
#'  (default: 1e-3).
#' @param lambda_spread Regularization coefficient for weight spread
#'  (default: 0.05).
#' @param temperature Softmax temperature for controlling assignment sharpness
#'  (default: 0.2).
#' @param normalize Whether to check and normalize A and B to ensure row sums
#'  equal 1. (default: TRUE).
#' @param seed Random seed for reproducibility (default: 1898).
#' @param n_threads Number of threads to use for Torch (default: 10).
#'
#' @return A data frame of shape (n_features_B, n_features_A) with association
#'  weights.
feature_associations <- function(
    A, A_var, B, B_var,
    mask = NULL,
    n_epochs = 10000,
    lambda_reg = 1e-4,
    lambda_entropy = 1e-3,
    lambda_spread = 0.05,
    temperature = 0.2,
    normalize = TRUE,
    seed = 1898,
    n_threads = 10
){
  df <- .mTopic$tl$feature_associations(
    A = A,
    A_var = A_var,
    B = B,
    B_var = B_var,
    mask = mask,
    n_epochs = as.integer(n_epochs),
    lambda_reg = lambda_reg,
    lambda_entropy = lambda_entropy,
    lambda_spread = lambda_spread,
    temperature = temperature,
    normalize = normalize,
    seed = as.integer(seed),
    n_threads = as.integer(n_threads)
  )
  return(df)
}
