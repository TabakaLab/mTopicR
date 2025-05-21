#' @name tfidf
#'
#' @title Apply Term Frequency-Inverse Document Frequency (TF-IDF)
#'  transformation to a specific modality in a Seurat object.
#'
#' @description This function performs a TF-IDF transformation on the count
#'  matrix of the specified modality within the provided Seurat object.
#'  The TF-IDF transformation adjusts raw counts by considering both term
#'  frequency (TF) and inverse document frequency (IDF). This enhances
#'  interpretability by down-weighting common features and emphasizing rare
#'  ones. The transformation is applied in-place by default or to a copy if
#'  specified.
#'
#' @param object A Seurat object containing multiple modalities, each with
#'  a count matrix to be transformed.
#' @param mod The modality to apply the TF-IDF transformation to (e.g.,
#'  ‘rna’, ‘protein’).
#'
#' @return A new Seurat object with the TF-IDF-transformed data.
#'
#' @note The TfidfTransformer from sklearn is used with norm=None and
#'  smooth_idf=False, meaning the output will not be normalized, and
#'  inverse document frequency will not be smoothed.
#' @note This function assumes the count matrix of the specified modality
#'  is compatible with TfidfTransformer.
#' @note Ideal for preprocessing single-cell data with modalities like RNA
#'  or ATAC.
tfidf <- function(
    object,
    mod
){
  .CheckSeurat(object)
  stopifnot('Incorrect modality' = mod %in% names(object@assays))

  mdata <- .SeuratToMuData(object)
  mdata <- .mTopic$pp$tfidf(
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
