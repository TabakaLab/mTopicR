#' @name update_assays
#'
#' @title Update Assay to Assay5.
#'
#' @description This function converts every assay of class Assay to Assay5.
#'
#' @param object A Seurat object.
#'
#' @return A new Seurat object containing assays of class Assay5.
#'
update_assays <- function(
    object
){
  .CheckSeurat(object)
  for (mod in names(object@assays)){
    if (class(object[[mod]]) == "Assay"){
      object[[mod]] = as(object[[mod]], Class = "Assay5")
    }
  }
  return(object)
}
