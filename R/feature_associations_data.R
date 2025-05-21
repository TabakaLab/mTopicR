#' @name feature_associations_data
#'
#' @title Prepare topic signatures for training feature associations.
#'
#' @description Extracts and optionally row-normalizes signature matrices from
#'  multiple modalities in a Seurat object. Each signature matrix is expected
#'  to be stored in meta data of the respective modality. Matrices are returned
#'  in a dictionary keyed by modality name.
#'
#' @param object A Seurat object containing modalities with signature matrices
#'  in object[[modality]]@meta.data.
#' @param mods A vector of modality names to extract from the Seurat object.
#' @param normalize If TRUE, rows of the signature matrices are normalized to
#'  sum to 1. (default: TRUE)
#'
#' @return A nested list where the keys are the names of the modalities. Each
#'  modality contains a two-element list. The first element is a
#'  torch.FloatTensor of shape (n_topics, n_features). The second element is
#'  a data frame corresponding to the signatures.
feature_associations_data <- function(
    object,
    mods,
    normalize = TRUE
){
  mdata <- .SeuratToMuData(object)
  mdata <- .AddSignatures(object, mdata)
  nested_list <- .mTopic$pp$feature_associations_data(
     mdata = mdata,
     mod_list = mods,
     normalize = normalize
  )
  return(nested_list)
}
