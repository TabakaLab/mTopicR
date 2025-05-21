#' @name plot_filter_var_knee
#'
#' @title Detect and visualize overrepresented features using a knee detection
#'  algorithm.
#'
#' @description This function identifies and visualizes features (e.g., genes)
#'  that are overrepresented across all topics in a specified modality of a
#'  topic model. By plotting the cumulative activity of features across topics,
#'  it applies a knee detection algorithm to find points of significant
#'  activity drop, which can be used to filter out less informative features
#'  in downstream analysis.
#'
#'  Multiple knee points are calculated using varying sensitivities, providing
#'  insight into how the detection threshold affects the selection of
#'  overrepresented features.
#'
#' @param model An instance of a MTM or sMTM model containing the topic-feature
#'  distributions.
#' @param mod The modality to analyze (e.g., ‘rna’, ‘protein’).
#' @param knee_sensitivities List of sensitivities for the knee detection
#'  algorithm. Higher sensitivity values detect more subtle changes. Default
#'  is c(1, 2, 5, 10).
#' @param s Marker size for the scatter plot. Default is 20.
#' @param figsize Tuple specifying the size of the figure (width, height) in
#'  inches. Default is c(8, 6).
#' @param fontsize Font size for plot labels, annotations, and ticks. Default
#'  is 10.
#' @param annotate_features Whether to annotate feature names on the plot. If
#'  TRUE, feature names will be displayed near their points. Default is FALSE.
#' @param show_frac Fraction of the top features to display based on their
#'  cumulative activity. Default is 1 (all features).
#' @param log_scale Whether to apply a log scale to the y-axis for feature
#'  activity. Default is TRUE.
#' @param transparent If TRUE, saves the figure with a transparent background.
#'  Default is FALSE.
#' @param save Path to save the figure. If NULL, the figure is displayed but
#'  not saved. Default is NULL.
#'
#' @note This function is an implementation of the scmtm.pl.filter_var_knee
#'  function from the original scmtm Python package.
plot_filter_var_knee <- function(
    model,
    mod,
    knee_sensitivities = c(1, 2, 5, 10),
    s = 20,
    figsize = c(8, 6),
    fontsize = 10,
    annotate_features = FALSE,
    show_frac = 1,
    log_scale = TRUE,
    transparent = FALSE,
    save = NULL
){
  .mTopic$pl$filter_var_knee(
    model = model,
    mod = mod,
    knee_sensitivities = knee_sensitivities,
    s = s,
    figsize = figsize,
    fontsize = fontsize,
    annotate_features = annotate_features,
    show_frac = show_frac,
    log_scale = log_scale,
    transparent = transparent,
    save = save
  )
  .matplotlib$show()
}
