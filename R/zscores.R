#' @name zscores
#'
#' @title Compute z-scores for the top features in each topic within a MuData
#'  object.
#'
#' @description This function calculates z-scores for the top features
#'  associated with each topic in the specified modality or across all
#'  modalities of a Seurat object. Z-scores are computed using normalized and
#'  log-transformed raw count data, allowing for a standardized comparison of
#'  feature expression levels relative to their mean and standard deviation
#'  across all cells. Computed z-scores are capped within a specified threshold
#'  range to limit extreme values.
#'
#' @param object A Seurat object containing multimodal single-cell data.
#' @param mod Specific modality to compute z-scores for. If NULL, z-scores are
#'  computed for all modalities. Default is NULL.
#' @param n_top Number of top features to select for each topic based on their
#'  importance in the topic signature. Default is 10.
#' @param thr Threshold to cap the computed z-scores. Z-scores will be limited
#'  to the range [-thr, thr]. Default is 5.
#'
#' @note Z-scores are computed as (x - mean) / std, where x is the log-
#'  transformed expression value of a feature, mean is the mean across all
#'  cells, and std is the standard deviation across all cells.
#' @note The top n_top features for each topic are selected based on their
#'  importance in the topic signatures (highest weights).
#' @note Extreme z-scores are capped to the range [-thr, thr] to mitigate the
#'  impact of outliers.
zscores <- function(
    object,
    mod = NULL,
    n_top = 10,
    thr = 5
){
  mdata <- .SeuratToMuData(object)
  mdata <- .AddSignatures(object, mdata)
  mdata_raw <- .SeuratToMuData(object, normalized = FALSE, scaled = FALSE)
  temp_path <- tempfile(fileext = '.h5mu')
  .muon$write_h5mu(
    mdata = mdata,
    filename = temp_path
  )
  .mTopic$tl$zscores(
    mdata = mdata,
    raw_data_path = temp_path,
    signatures = 'signatures',
    mod = mod,
    n_top = as.integer(n_top),
    thr = thr,
    out_key = 'zscores'
  )
  if (!is.null(mod)){
    object[[mod]]@misc[['zscores']] <- mdata[[mod]]$obsm[['zscores']]
  } else{
    for (modality in names(mdata['mod'])){
      object[[modality]]@misc[['zscores']] <- mdata[[modality]]$obsm[['zscores']]
    }
  }
  file.remove(temp_path)
  return(object)
}
