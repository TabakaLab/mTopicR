#' @name export_params
#'
#' @title  Export model parameters (gamma and lambda) to a Seurat object and
#'  filter insignificant topics.
#'
#' @description This function exports topic-cell distributions (gamma) and
#'  feature-topic distributions (lambda) from the given model into the 'mTopic'
#'  reduction and modality meta data. Users can apply optional filtering to
#'  remove topics with probabilities below a specified threshold, which helps
#'  focus on meaningful patterns.
#'
#' @param model A MTM model containing the parameters (gamma and lambda) to be
#'  exported
#' @param object A Seurat object to which the parameters will be exported.
#' @param filter_topics Whether to filter topics based on their maximum
#'  probability across cells. If TRUE, only topics with a maximum
#'  probability above filter_threshold are retained. Default is TRUE.
#' @param filter_threshold The threshold for filtering topics when
#'  filter_topics is TRUE. Topics with a maximum probability below this
#'  threshold are removed. Default is 0.01.
#' @param normalize Whether to normalize the topic-cell distributions (gamma).
#'  If TRUE, normalizes rows of gamma so that each row sums to 1. Default is
#'  TRUE.
#'
#' @return A Seurat object containing topic proportions for each sample and
#'  topic-feature distributions for each modality.
#'
#' @note Gamma (Topic Proportions) are stored in the reduction named mTopic
#' @note Lambda (Topic-Feature Distributions) are stored for each modality in
#'  object[[modality]]@meta.data
export_params <- function(
    model,
    object,
    filter_topics = TRUE,
    filter_threshold = 0.01,
    normalize = TRUE
){
  .CheckSeurat(object)
  mdata <- .SeuratToMuData(object, scaled = TRUE)
  .mTopic$tl$export_params(
    model = model,
    mdata = mdata,
    prefix = NULL,
    filter_topics = filter_topics,
    normalize = normalize)

  topics <- as.matrix(mdata['obsm']['topics']$topics)
  object@reductions[['mTopic']] <- SeuratObject::CreateDimReducObject(
    embeddings = topics)
  for (modality in names(mdata['mod'])){
    object[[modality]]@meta.data <- cbind(
      object[[modality]]@meta.data, mdata[modality]$varm$signatures
    )
  }
  return(object)
}
