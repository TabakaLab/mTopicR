#' @name plot_scatter_pie
#'
#' @title Create a scatter plot with pie charts representing topic distributions
#'  at each sample coordinate.
#'
#' @description This function visualizes topic proportions for each sample in
#'  a dataset using pie charts positioned at their corresponding spatial or
#'  embedding coordinates. Each pie chart represents the distribution of
#'  topics for a single cell/spot, and a legend provides the color mapping for
#'  each topic.
#'
#' @param object A MuData object containing multimodal single-cell data,
#'  including topic distributions and coordinates.
#' @param x A name of the embedding to use for plotting (e.g., UMAP, PCA).
#'  If equal to ’Spatial’ tries to use spot coordinates.
#' @param radius The radius of the pie charts. Default is 0.005.
#' @param xrange The range of x-coordinates to display in the plot. Default
#'  is c(0, 1).
#' @param yrange The range of y-coordinates to display in the plot. Default
#'  is c(0, 1).
#' @param figsize The size of the figure (width, height) in inches. Default
#'  is c(10, 10).
#' @param palette A list mapping topics to colors. If NULL, a default palette
#'  is generated. Default is NULL.
#' @param legend_markersize The size of the markers in the legend. Default
#'  is 10.
#' @param legend_ncol The number of columns in the legend. Default is 1.
#' @param save Path to save the figure. If None, the figure is displayed but
#'  not saved. Default is NULL.
#' @param transparent Whether to save the figure with a transparent background.
#'  Default is FALSE.
#'
#' @note The xrange and yrange parameters allow zooming into specific regions
#'  of the plot.
plot_scatter_pie <- function(
    object,
    x,
    radius = 0.005,
    xrange = c(0, 1),
    yrange = c(0, 1),
    figsize = c(10, 10),
    palette = NULL,
    legend_markersize = 10,
    legend_ncol = 1,
    save = NULL,
    transparent= FALSE
){
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mdata <- .AddEmbedding(object, mdata, x)
  mdata <- .AddTopics(object, mdata)

  .mTopic$pl$scatter_pie(
    mdata = mdata,
    topics = 'topics',
    x = 'temp_df',
    radius = radius,
    xrange = xrange,
    yrange = yrange,
    figsize = figsize,
    palette = palette,
    legend_markersize = legend_markersize,
    legend_ncol = as.integer(legend_ncol),
    save = save,
    transparent = transparent
  )
  .matplotlib$show()
}
