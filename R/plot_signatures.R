#' @name plot_signatures
#'
#' @title  Visualize the top features (signatures) for each topic in
#'  a specified modality of a Seurat object.
#'
#' @description This function generates bar plots displaying the top n_top
#'  features associated with each topic in a specified modality of a Seurat
#'  object. Features are ranked by their importance in the topic, providing
#'  insight into the key contributors for each topic. The plots are arranged
#'  in a grid layout for easy comparison.
#'
#' @param object A Seurat object containing multimodal single-cell data with
#'  feature-topic distributions stored in modality's meta.data.
#' @param mod  The modality to visualize topic signatures for (e.g., ‘rna’,
#'  ‘protein’).
#' @param n_top Number of top features to display for each topic. Default
#'  is 30.
#' @param cmap Colormap to use for visualizing feature importance. Default
#'  is ‘viridis’.
#' @param figsize Tuple specifying the figure size (width, height) in inches.
#'  If None, the size is automatically determined based on the number of topics
#'  and the number of top features. Default is None.
#' @param fontsize Font size for plot titles and labels. Default is 8.
#' @param transparent Whether to make the figure background transparent. Useful
#'  for overlays in presentations. Default is False.
#' @param save Path to save the figure. If None, the figure is displayed but
#'  not saved. Default is None.
plot_signatures <- function(
    object,
    mod,
    n_top = 30,
    cmap = 'viridis',
    figsize = NULL,
    fontsize = 8,
    transparent = FALSE,
    save = NULL
){
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mdata <- .AddSignatures(object, mdata)
  .mTopic$pl$signatures(
    mdata = mdata,
    mod = mod,
    signatures = 'signatures',
    n_top = as.integer(n_top),
    cmap = cmap,
    figsize = figsize,
    fontsize = fontsize,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
