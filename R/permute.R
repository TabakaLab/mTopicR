#' @name permute
#'
#' @title Randomly permute the count matrices.
#'
#' @description This function randomly permutes the counts within each column
#'  of the count matrices in each modality. Permutations are performed either
#'  on dense matrices or sparse matrices based on the sparse_mode parameter.
#'  Basic filtering is applied to retain only non-empty cells and features.
#'
#' @param object A Seurat object containing multiple modalities.
#' @param subset The number of cells (observations) to randomly subset
#'  before performing permutation. If NULL, all cells are used. Default is
#'  NULL.
#' @param seed Seed for the random number generator to ensure reproducibility
#'  of the permutation. Default is 2291.
#' @param sparse_mode If FALSE, performs permutation on dense matrices (after
#'  converting to dense). Default is FALSE.
#'
#' @return A new Seurat object with permuted data.
#'
#' @note Filtering is applied using scanpy.pp.filter_cells() and
#'  scanpy.pp.filter_genes() to remove empty cells and features.
#' @note The function uses muon.pp.intersect_obs() to ensure consistency across
#'  modalities after filtering.
permute <- function(
    object,
    subset = NULL,
    seed = 2291,
    sparse_mode = FALSE
){
  .CheckSeurat(object)
  mdata <- .SeuratToMuData(object)
  mdata <- .mTopic$pp$permute(
    mdata = mdata,
    subset = subset,
    seed = as.integer(seed),
    copy = TRUE,
    sparse_mode = sparse_mode
  )
  object <- subset(object, cells = mdata$obs_names)
  object <- .GetCountMatrices(
    object = object,
    mdata = mdata
  )
  return(object)
}
