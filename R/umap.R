#' @name umap
#'
#' @title  Perform UMAP dimensionality reduction on topic distributions and
#'  store the results in the MuData object.
#'
#' @description This function applies Uniform Manifold Approximation and
#'  Projection (UMAP) to reduce the dimensionality of topic distributions.
#'
#' @param object A Seurat object containing the topic proportions in the
#'  scmtm reduction.
#' @param umap The key under which the UMAP results will be stored in the
#'  Seurat embedding. Default is mTopic_umap.
#' @param n_components The number of dimensions for the UMAP embedding.
#'  Default is 2.
#' @param min_dist The minimum distance between points in the UMAP embedding.
#'  Controls the balance between local and global structure. Default is 0.1.
#' @param n_neighbors The number of nearest neighbors to consider when
#'  computing the UMAP embedding. Default is 20.
#' @param seed Random seed for reproducibility. Ensures consistent embeddings
#'  across runs. Default is 2291.
#'
#' @return A Seurat object.
#'
#' @note UMAP is a non-linear dimensionality reduction technique widely used
#'  for visualizing high-dimensional data.
umap <- function(
    object,
    umap = 'mTopic_umap',
    n_components = 2,
    min_dist = 0.1,
    n_neighbors = 20,
    seed = 2291
){
  mdata <- .SeuratToMuData(object, normalized = TRUE, scaled = TRUE)
  mdata <- .AddTopics(object, mdata)

  .mTopic$tl$umap(
    mdata = mdata,
    x = 'topics',
    umap = 'temp_umap',
    n_components = as.integer(n_components),
    min_dist = min_dist,
    n_neighbors = as.integer(n_neighbors),
    seed = as.integer(seed)
  )
  umap_coords <- as.matrix(mdata['obsm']['temp_umap']$temp_umap)
  object@reductions[[umap]] <- SeuratObject::CreateDimReducObject(
    embeddings = umap_coords, key = 'mTopic_')
  return(object)
}
