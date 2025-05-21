#' @name scale_counts
#'
#' @title Scale count matrices to normalize the total sum of counts across
#'  modalities.
#'
#' @description This function normalizes the total sum of counts in the count
#'  matrix of each modality within the provided Seurat object. Each modality’s
#'  counts are scaled so that their total sum matches a specified target value
#'  (counts_per_cell * n_obs). This ensures consistency in total counts across
#'  different modalities, which is crucial for comparative and integrative
#'  analyses in single-cell multimodal datasets.
#'
#' @param object A Seurat object containing multiple modalities.
#' @param counts_per_cell The target average counts per cell. The total sum of
#'  counts in each modality is scaled to counts_per_cell * n_obs, where n_obs
#'  is the number of cells. Default is 10,000.
#'
#' @return A new Seurat object.
#'
#' @note This function is especially useful when working with multimodal
#' datasets where each modality may have different total counts, making
#' comparisons challenging.
scale_counts <- function(
    object,
    counts_per_cell = 10000
){
  .CheckSeurat(object)
  if (!("data" %in% SeuratObject::Layers(object))){
    stop("Data layer not found. Normalize your data first.")
  }
  mdata <- .SeuratToMuData(object, normalized = TRUE)
  mdata <- .mTopic$pp$scale_counts(
    mdata = mdata,
    counts_per_cell = as.integer(counts_per_cell),
    copy = TRUE
  )
  object <- .GetCountMatrices(
    object = object,
    mdata = mdata,
    scaled = TRUE
  )
  return(object)
}
