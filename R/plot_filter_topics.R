#' @name plot_filter_topics
#'
#' @title Visualize the significance of topics based on their maximum
#'  probability across cells.
#'
#' @description This function generates a scatter plot to show the maximum
#'  probability of each topic across all cells. Topics with higher
#'  maximum probabilities represent significant patterns in the dataset, while
#'  topics with low maximum probabilities might be less informative or represent
#'  noise. The plot includes a suggested threshold line (default at y = 0.01)
#'  to help identify insignificant topics for filtering in downstream analysis.
#'
#' @param model An instance of a MTM or sMTM model containing the topic
#'  distributionss (gamma) to analyze.
#' @param s Marker size for the scatter plot. Default is 50.
#' @param figsize Vector specifying the size of the figure c(width, height) in
#'  inches. Default is c(8, 6).
#' @param fontsize Font size for plot labels and annotations. Default is 10.
#' @param transparent Whether to save the figure with a transparent background.
#'  Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is NULL.
plot_filter_topics <- function(
    model,
    s = 50,
    figsize = c(8, 6),
    fontsize = 10,
    transparent = FALSE,
    save = NULL
){
  .mTopic$pl$filter_topics(
    model = model,
    s = s,
    figsize = figsize,
    fontsize = fontsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
