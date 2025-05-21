#' @name clr
#'
#' @title Perform Centered Log-Ratio (CLR) normalization on a modality in a
#'  Seurat object.
#'
#' @description This function applies CLR normalization to the specified
#'  modality within a Seurat object. CLR normalization is widely used for
#'  compositional data, such as single-cell protein counts. It calculates
#'  the geometric mean of counts for each cell, normalizes each feature by
#'  dividing its count by the geometric mean, and applies a log transformation.
#'  This normalization helps mitigate the effects of varying library sizes and
#'  technical biases.
#'
#' @param object Seurat object containing multimodal single-cell data.
#' @param mod The modality to which CLR normalization will be applied.
#'
#' @note The CLR normalization follows these steps: 1. Compute the geometric
#'  mean of counts for each cell (row) across all features (columns). 2. Divide
#'  each feature count by the geometric mean of its respective cell. 3. Apply a
#'  log1p transformation (log(x + 1)) to the normalized data.
#' @note A small pseudocount (1e-6) is added to the geometric mean to avoid
#'  division by zero errors.
clr <- function(
    object,
    mod
){
  .CheckSeurat(object)
  stopifnot('Incorrect modality' = mod %in% names(object@assays))

  mdata <- .SeuratToMuData(object)
  mdata <- .mTopic$pp$clr(
    mdata = mdata,
    mod = mod,
    copy = TRUE
  )
  temp_matrix <- mdata[mod]$X
  if (inherits(temp_matrix, "dgRMatrix")){
    temp_matrix <- as(temp_matrix, "CsparseMatrix")
    object[[mod]]$data <- Matrix::t(temp_matrix)
  }
  object[[mod]]$data <- Matrix::t(temp_matrix)
  return(object)
}
