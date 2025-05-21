#' @name filter_var_list
#'
#' @title Retain a specific list of features in a Seurat object.
#'
#' @description This function retains only the specified list of features
#'  (e.g., genes, proteins) in a Seurat object and removes all other features.
#'  It is designed to streamline downstream analysis by focusing on a
#'  predefined subset of relevant features.
#'
#' @param object A raw, unfiltered Seurat object to be processed.
#' @param var A vector of feature names to be retained in the Seurat object.
#'
#' @return A Seurat object containing only the specified features.
#'
#' @note Ensure the feature names in var match the names in the dataset to
#'  avoid errors.
filter_var_list <- function(
    object,
    var
){
  mdata <- .SeuratToMuData(object, scaled = FALSE)
  temp_path <- tempfile(fileext = '.h5mu')
  .muon$write_h5mu(
    mdata = mdata,
    filename = temp_path
  )
  mdata <- .mTopic$pp$filter_var_list(
    path = temp_path,
    var = var
  )
  suppressWarnings({
    object <- .GetCountMatrices(
      object = object,
      mdata = mdata
    )
  })
  file.remove(temp_path)
  return(object)
}
