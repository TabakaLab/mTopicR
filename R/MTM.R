#' @name MTM
#'
#' @title Multimodal Topic Model (MTM) for single-cell data analysis.
#'
#' @description This class implements a Multimodal Topic Model (MTM) for
#'  analyzing single-cell data across multiple modalities. It is designed to
#'  discover latent topics that capture patterns and relationships between
#'  features across modalities. MTM can be trained using Variational Inference
#'  (VI) or Stochastic Variational Inference (SVI) for efficient learning from
#'  large datasets.
#'
#' @param object A Seurat object containing multiple modalities. Each modality
#'  represents a feature space (e.g., RNA, ATAC, protein), which is used for
#'  topic modeling.
#' @param n_topics The number of latent topics to infer. Each topic corresponds
#'  to a distinct pattern or feature distribution across modalities. Default
#'  is 20.
#' @param seed Random seed for reproducibility. Ensures consistent
#'  initialization and results. Default is 2291.
#' @param n_jobs Number of CPU cores to use for parallel processing. If set
#'  to -1, uses all available cores. Default is -1.
#'
#' @return MTM object.
MTM <- function(
    object,
    n_topics = 20,
    seed = 2291,
    n_jobs = -1
){
  .CheckSeurat(object)

  mdata <- .SeuratToMuData(object, scaled = TRUE)
  mtm_object <- .mTopic$tl$MTM(
    mdata = mdata,
    n_topics = as.integer(n_topics),
    seed = as.integer(seed),
    n_jobs = as.integer(n_jobs)
  )
  return(mtm_object)
}
