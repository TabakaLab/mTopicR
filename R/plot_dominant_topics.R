#' @name plot_dominant_topics
#'
#' @title Visualize the dominant topic for each sample in a Seurat object.
#'
#' @description This function creates a scatter plot where each point
#'  represents a cell/spot, colored according to the dominant topic (i.e., the
#'  topic with the highest probability) for that sample. The plot provides an
#'  intuitive overview of how topics are distributed spatially or in a given
#'  embedding. A legend maps colors to topics for easy interpretation.
#'
#' @param object A Seurat object containing multimodal single-cell data,
#'  including topic probabilities and coordinates.
#' @param x A name of the embedding to use for plotting (e.g., UMAP, PCA).
#'  If equal to ’Spatial’ tries to use spot coordinates.
#' @param palette A list mapping topics to specific colors. If NULL, a default
#'  palette of unique hex colors is generated. Default is NULL.
#' @param marker Marker style for the scatter plot. Default is ‘.‘.
#' @param s Marker size in the scatter plot. Default is 20.
#' @param fontsize Font size for legend labels. Default is 10.
#' @param markerscale Scale of markers in the legend relative to their size in
#'  the scatter plot. Default is 2.
#' @param figsize Vector specifying the figure size c(width, height) in inches.
#'  Default is c(7, 5).
#' @param transparent Whether to save the figure with a transparent background.
#'  Useful for overlays or presentations. Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is NULL.
plot_dominant_topics <- function(
    object,
    x,
    palette = NULL,
    marker = '.',
    s = 20,
    fontsize = 10,
    markerscale = 2,
    figsize = c(7, 5),
    transparent = FALSE,
    save = NULL
){
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mdata <- .AddEmbedding(object, mdata, x)
  mdata <- .AddTopics(object, mdata)

  .mTopic$pl$dominant_topics(
    mdata = mdata,
    x = 'temp_df',
    topics = 'topics',
    palette = palette,
    marker = marker,
    s = s,
    fontsize = fontsize,
    markerscale = markerscale,
    figsize = figsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
