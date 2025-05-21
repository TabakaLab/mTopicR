#' @name plot_topics
#'
#' @title Visualize topic distributions on spatial coordinates or embedding.
#'
#' @description This function generates scatter plots to visualize the
#'  topic distributions across cells/spots. Each topic is displayed
#'  in a separate subplot, showing how the topic is spatially distributed or
#'  distributed within a specified embedding. The plots are arranged in a grid
#'  for easy comparison.
#'
#' @param object A Seurat object containing multimodal single-cell data, with
#'  topic distributions stored in ’mTopic’ reduction embedding.
#' @param x A name of the embedding to use for plotting (e.g., UMAP, PCA).
#'  If equal to ’Spatial’ tries to use spot coordinates.
#' @param cmap Colormap to use for visualizing topic proportions. Default is
#'  ‘gnuplot’.
#' @param marker Marker style for scatter plots. Default is ‘.’.
#' @param s Marker size in scatter plots. Default is 10.
#' @param vmax Maximum value for the color scale. If NULL, it is set to the
#'  99.9th percentile of the data for each topic. Default is NULL.
#' @param fontsize Font size for plot titles and colorbar ticks. Default is 10.
#' @param figsize Vector specifying the figure size c(width, height) in inches.
#'  If NULL, the size is automatically determined based on the number of
#'  topics. Default is NULL.
#' @param transparent Whether to make the figure background transparent. Useful
#'  for overlays in presentations. Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is NULL.
plot_topics <- function(
    object,
    x,
    cmap = 'gnuplot',
    marker = '.',
    s = 10,
    vmax = NULL,
    fontsize = 10,
    figsize = NULL,
    transparent = FALSE,
    save = NULL
){
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mdata <- .AddEmbedding(object, mdata, x)
  mdata <- .AddTopics(object, mdata)

  .mTopic$pl$topics(
    mdata = mdata,
    x = 'temp_df',
    topics = 'topics',
    cmap = cmap,
    marker = marker,
    s = s,
    vmax = vmax,
    fontsize = fontsize,
    figsize = figsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
