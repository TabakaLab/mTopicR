#' @name plot_zscores
#'
#' @title Visualize the spatial or embedding-based distribution of z-scores for
#'  topics in a specified modality.
#'
#' @description This function generates scatter plots showing the distribution
#'  of z-scores for each topic in a specified modality of a Seurat object.
#'  Z-scores are used to highlight spatial or embedding-based patterns of
#'  feature expression across samples, revealing significant variations
#'  relative to the global mean.
#'
#' @param object A Seurat object containing multimodal single-cell data with
#'  z-scores stored in the misc attribute.
#' @param mod The modality to visualize z-scores for (e.g., ‘rna’, ‘protein’).
#' @param x The key in the reduction attribute of the Seurat object,
#'  representing the spatial coordinates or embedding to use for plotting
#'  (e.g., ‘umap’, ’Spatial’).
#' @param cmap The colormap to use for visualizing z-scores. If NULL, a custom
#'  colormap is applied. Default is NULL.
#' @param marker Marker style for scatter plots. Default is ‘.’.
#' @param s Marker size for scatter plots. Default is 10.
#' @param fontsize Font size for plot titles and colorbar ticks. Default is 10.
#' @param figsize  Vector specifying the figure size c(width, height) in
#'  inches. If NULL, the size is automatically determined based on the number
#'  of topics. Default is NULL.
#' @param transparent Whether to make the figure background transparent. Useful
#'  for overlays in presentations. Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is NULL.
plot_zscores <- function(
    object,
    mod,
    x,
    cmap = NULL,
    marker = '.',
    s = 10,
    fontsize = 10,
    figsize = NULL,
    transparent = FALSE,
    save = NULL
){
  mdata <- .SeuratToMuData(object)
  mdata <- .AddEmbedding(object, mdata, x)
  mdata <- .AddZscores(object, mdata)
  .mTopic$pl$zscores(
    mdata = mdata,
    mod = mod,
    x = 'temp_df',
    zscores = 'zscores',
    cmap = cmap,
    marker = marker,
    s = s,
    fontsize = fontsize,
    figsize = figsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
