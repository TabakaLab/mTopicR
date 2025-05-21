#' @name sMTM
#'
#' @title Spatial Multimodal Topic Model (sMTM) for single-cell spatial data
#'  analysis.
#'
#' @description This class implements a Spatial Multimodal Topic Model (sMTM)
#'  designed for analyzing single-cell spatial data across multiple modalities.
#'  The model captures spatial relationships by constructing a spatial
#'  neighborhood graph and uses Variational Inference (VI) to identify
#'  spatially-aware topics. These topics represent patterns across features
#'  and modalities while incorporating spatial information.
#'
#' @param object A Seurat object containing multimodal single-cell spatial
#'  data, including spatial coordinates in the obsm attribute.
#' @param n_topics Number of topics to infer. Each topic represents a distinct
#'  spatial pattern across features and modalities. Default is 20.
#' @param radius Radius for constructing a spatial neighborhood graph. Used if
#'  n_neighbors is None. Default is 0.05.
#' @param n_neighbors Number of neighbors to consider when constructing the
#'  spatial neighborhood graph. Overrides radius if set. Default is NULL.
#' @param cache_similarities If TRUE, caches spatial similarity information for
#'  each update during Variational Inference. Default is FALSE.
#' @param seed Random seed for reproducibility. Ensures consistent
#'  initialization and results. Default is 2291.
#' @param n_jobs Number of CPU cores to use for parallel processing. If set
#'  to -1, uses all available cores. Default is -1.
#'
#' @return A new Seurat object.
sMTM <- function(
    object,
    n_topics = 20,
    radius = 0.05,
    n_neighbors = NULL,
    cache_similarities = FALSE,
    seed = 2291,
    n_jobs = -1
){
  .CheckSeurat(object)

  mdata <- .SeuratToMuData(object, spatial = TRUE, scaled = TRUE)
  mtm_object <- .mTopic$tl$sMTM(
    mdata = mdata,
    n_topics = as.integer(n_topics),
    radius = radius,
    n_neighbors = n_neighbors,
    cache_similarities = cache_similarities,
    seed = as.integer(seed),
    spatial_key = 'coords',
    n_jobs = as.integer(n_jobs)
  )
  return(mtm_object)
}
