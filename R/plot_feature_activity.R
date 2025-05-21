#' @name plot_feature_activity
#'
#' @title Visualize the distribution of specified features in a MuData object.
#'
#' @description This function plots the spatial or embedding-based distribution
#'  of specified features (e.g., genes or proteins) across a sample dataset.
#'  Each feature is visualized individually, highlighting regions with high or
#'  low activity levels. This allows users to identify spatial patterns or
#'  clusters of cells associated with specific features.
#'
#' @param object A Seurat object containing multimodal single-cell data,
#'  including spatial coordinates and expression matrices.
#' @param x A name of the embedding to use for plotting (e.g., UMAP, PCA).
#'  If equal to ’Spatial’ tries to use spot coordinates.
#' @param features A vector of features (e.g., genes or proteins) to visualize.
#' @param cmap The colormap to use for visualizing feature activity. Default
#'  is ‘gnuplot’.
#' @param marker Marker style for scatter plots. Default is ‘.’.
#' @param s Marker size in the scatter plots. Default is 10.
#' @param p_top Percentile threshold to highlight top feature activity values.
#'  Points above this percentile are displayed prominently. Default is 99.
#' @param fontsize Font size for plot titles and colorbar ticks. Default
#'  is 10.
#' @param figsize Vector specifying the figure size (width, height) in inches.
#'  If NULL, size is automatically determined based on the number of features.
#'  Default is NULL.
#' @param transparent If True, saves the figure with a transparent background.
#'  Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is None.
plot_feature_activity <- function(
    object,
    x,
    features = NULL,
    cmap = 'gnuplot',
    marker = '.',
    s = 20,
    p_top = 99,
    fontsize = 10,
    figsize = NULL,
    transparent = FALSE,
    save = NULL
){
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mdata <- .AddEmbedding(object, mdata, x)
  mdata <- .AddTopics(object, mdata)

  if (length(features) == 1) {
    features <- list(features)
  }

  .mTopic$pl$feature_activity(
    mdata = mdata,
    x = 'temp_df',
    features = features,
    cmap = cmap,
    marker = marker,
    s = s,
    p_top = as.integer(p_top),
    fontsize = fontsize,
    figsize = figsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
