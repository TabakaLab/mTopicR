#' @name filter_var_knee
#'
#' @title Filter overrepresented features from a Seurat object using a knee
#'  detection algorithm.
#'
#' @description This function identifies and removes overrepresented features
#'  (e.g., genes, proteins) across all topics in each modality of a Seurat
#'  object using a knee detection algorithm. Overrepresented features, which
#'  are beyond a significant drop-off point (knee point) in their cumulative
#'  activity, are filtered out to improve data quality and downstream analysis.
#'
#' @param object A raw, unfiltered Seurat object to be processed.
#' @param model An instance of a topic model containing the topic-feature
#'  distributions (e.g., lambda_ matrix for each modality).
#' @param knee_sensitivity Sensitivity for the knee detection algorithm. Higher
#'  values make the algorithm more conservative in identifying overrepresented
#'  features. It can be a single integer (global for all modalities) or a
#'  dictionary specifying sensitivity per modality. Default is 5.
#'
#' @return A Seurat object with overrepresented features removed.
#'
#' @note Feature Identification: Overrepresented features are identified by
#'  calculating their cumulative activity across all topics in a modality.
#'  The knee detection algorithm (kneed) detects the knee point, beyond which
#'  features are considered overrepresented.
#' @note Knee Sensitivity: The knee_sensitivity parameter can be set globally
#'  for all modalities or specified individually for each modality as a
#'  dictionary. This allows flexibility based on the characteristics of each
#'  modality.
#' @note Applicability: This approach is ideal for filtering features that
#'  dominate topic distributions, which may obscure meaningful patterns.
filter_var_knee <- function(
    object,
    model,
    knee_sensitivity = 5
){
  suppressWarnings({
    mdata <- .SeuratToMuData(object, scaled = FALSE)
    temp_path <- tempfile(fileext = '.h5mu')
    .muon$write_h5mu(
      mdata = mdata,
      filename = temp_path
    )
    mdata <- .mTopic$pp$filter_var_knee(
      path = temp_path,
      model = model,
      knee_sensitivity = knee_sensitivity
    )
    object <- .GetCountMatrices(
      object = object,
      mdata = mdata
    )
    file.remove(temp_path)
  })
  return(object)
}
