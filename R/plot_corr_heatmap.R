#' @name plot_corr_heatmap
#'
#' @title  Visualize the correlation matrix between two sets of features as
#'  a heatmap.
#'
#' @description This function computes and plots a correlation heatmap to
#'  visualize the relationships between two sets of features. Each set is
#'  represented as data frame, with columns as features. The color intensity
#'  in the heatmap indicates the strength and direction of the correlation.
#'
#' @param data1 A data frame representing the first set of features. Each column
#'  corresponds to a feature.
#' @param data2 A data frame representing the second set of features. Each
#'  column corresponds to a feature.
#' @param label1 Label for the y-axis, representing the features from arr1.
#'  If NULL, no label is set. Default is NULL.
#' @param label2 Label for the x-axis, representing the features from arr2.
#'  If NULL, no label is set. Default is NULL.
#' @param cmap Colormap for the heatmap. Default is ‘bwr’ (blue-white-red
#'  colormap)
#' @param fontsize Font size for axis labels and colorbar ticks. Default is 8.
#' @param figsize Vector specifying the figure size c(width, height) in inches.
#'  Default is c(8, 6).
#' @param transparent If TRUE, saves the figure with a transparent background.
#'  Default is FALSE.
#' @param save File path to save the figure. If NULL, the figure is displayed
#'  but not saved. Default is NULL.
plot_corr_heatmap <- function(
  data1,
  data2,
  label1 = NULL,
  label2 = NULL,
  cmap = 'bwr',
  fontsize = 8,
  figsize = c(8, 6),
  transparent = FALSE,
  save = NULL
){
  .mTopic$pl$corr_heatmap(
    arr1 = data.frame(data1),
    arr2 = data.frame(data2),
    label1 = label1,
    label2 = label2,
    cmap = cmap,
    fontsize = fontsize,
    figsize = figsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
