.onLoad <- function(
    libname,
    pkgname
){
  env_name <- getOption("MTOPIC_ENV_NAME", default = "mTopic_r_package")
  if (!requireNamespace("reticulate", quietly = TRUE)){
    stop("You need to install reticulate first.")
  }
  if (!reticulate::condaenv_exists(env_name)){
    if (reticulate::virtualenv_exists(env_name)){
      warning(paste("Conda environment not found. Using venv instead"))
      reticulate::use_virtualenv(env_name)
    } else{
      stop(paste(env_name, "virtual environment not found."))
    }
  } else{
    reticulate::use_condaenv(env_name)
  }
  suppressMessages({
    .warnings <<- reticulate::import("warnings", delay_load = TRUE)
    .warnings$simplefilter("ignore")
    .matplotlib_main <<- reticulate::import("matplotlib",
      convert = TRUE, delay_load = TRUE)
    .matplotlib_main$use("Agg")
    .matplotlib <<- reticulate::import("matplotlib.pyplot", delay_load = TRUE)
    .muon <<- reticulate::import("muon", delay_load = TRUE)
    .mTopic <<- reticulate::import("mtopic", delay_load = TRUE)
  })
}


.SeuratToMuData <- function(
    object,
    normalized = FALSE,
    scaled = FALSE,
    spatial = FALSE
){
  .CheckSeurat(object)
  list_for_mudata <- list()
  for (modality in names(object@assays)){
    list_for_mudata[[modality]] <- .AddAnnDataModality(
      object = object,
      modality = modality,
      normalized = normalized,
      scaled = scaled
    )
  }
  mdata <- .muon$MuData(list_for_mudata)
  if (spatial){
    check_spatial <- .CheckSpatialData(object)
    stopifnot(
      'Failed to detect spot coordinates' = check_spatial[['is_spatial']]
    )
    mdata$obsm$coords = check_spatial[['coords']]
  }
  return(mdata)
}


.AddAnnDataModality <- function(
    object,
    modality = NULL,
    normalized = FALSE,
    scaled = FALSE
){
  count_matrix <- if(scaled){
    object[[modality]]$scale.data
  } else if (normalized){
    object[[modality]]$data
  } else{
    object[[modality]]$counts
  }
  if (inherits(count_matrix, "dgRMatrix")) {
    count_matrix <- as(as.matrix(count_matrix), "dgCMatrix")
  }
  features <- .AddFeatures(object, modality)
  rownames(features) <- rownames(object[[modality]])
  anndata_modality <- anndata::AnnData(
    X = Matrix::t(count_matrix),
    var = features
  )
  return(anndata_modality)
}


.GetCountMatrices <-function(
    object,
    mdata,
    normalized = FALSE,
    scaled = FALSE
){
  for (modality in names(mdata['mod'])){
    object[[modality]] <- subset(
      object[[modality]],
      features = colnames(mdata[modality])
    )
    if (scaled){
      object[[modality]]$scale.data <- NULL
      object[[modality]]$scale.data <- Matrix::t(mdata[modality]$X)
    } else if (normalized){
      object[[modality]]$data <- NULL
      object[[modality]]$data <- Matrix::t(mdata[modality]$X)
    } else{
      object[[modality]]$counts <- NULL
      object[[modality]]$counts <- Matrix::t(mdata[modality]$X)
    }
  }
  # object[[modality]]@features <- NULL
  # object[[modality]]@features <- mdata[[modality]]$var
  return(object)
}


.CheckSpatialData <- function(
    object
){
  spatial_is_present <- TRUE
  spatial_coordinates <- try(
    Seurat::GetTissueCoordinates(object)[, c('x', 'y')],
    silent = TRUE
  )
  if(inherits(spatial_coordinates, 'try-error')){
    if ("Spatial" %in% names(object@reductions)){
      spatial_coordinates <- object@reductions$Spatial@cell.embeddings[, 1:2]
    } else {
      spatial_is_present <- FALSE
      spatial_coordinates <- NULL
    }
  }
  return(list(
    'is_spatial' = spatial_is_present,
    'coords' = spatial_coordinates)
  )
}


.CheckSeurat <- function(
    object
){
  object_class <- class(object)[1]
  class_message <- paste0(
    'Provided object of class ', object_class, ' instead of Seurat')
  if (object_class != 'Seurat'){
    stop(class_message)
  }
}


.AddFeatures <- function(
    object,
    modality
){
  slots <- slotNames(object[[modality]])
  meta_data_df <- NULL
  if('meta.data' %in% slots){
    meta_data_df <- object[[modality]]@meta.data
  } else if ('meta.features' %in% slots){
    meta_data_df <- object[[modality]]@features
  } else {
    meta_data_df <- matrix(
      data = NA,
      nrow = nrow(object[[modality]]),
      ncol = 0
    )
  }
  rownames(meta_data_df) <- rownames(object[[modality]])
  if (ncol(meta_data_df) == 0){
    meta_data_df$dummy_feature <- rownames(meta_data_df)
  }
  return(meta_data_df)
}


.AddTopics <- function(
    object,
    mdata
){
  tryCatch({
    topics_df <- object@reductions[['mTopic']]@cell.embeddings
  }, error = function(e){
    stop(paste(
      "Topic proportions not found.",
      "Have you inferred and exported the topics?"))
  })
  mdata$obsm$topics <- as.data.frame(topics_df)
  return(mdata)
}


.AddSignatures <-function(
    object,
    mdata
){
  for (modality in names(object@assays)){
    meta_names <- colnames(object[[modality]]@meta.data)
    if (length(meta_names) == 0){
      stop('no topic in varm')
    }
    meta_cols <- grep("topic_", meta_names)
    meta_df <- object[[modality]]@meta.data[, meta_cols]
    rownames(meta_df) <- rownames(mdata[modality]$var)
    mdata[[modality]]$varm[['signatures']] <- meta_df
  }
  return(mdata)
}


.AddZscores <-function(
    object,
    mdata
){
  for (modality in names(object@assays)){
    zscores_df <- object[[modality]]@misc[['zscores']]
    mdata[[modality]]$obsm[['zscores']] <- zscores_df
  }
  return(mdata)
}


.AddEmbedding <- function(
    object,
    mdata,
    x
){
  embedding_df <- object@reductions[[x]]@cell.embeddings[, 1:2]
  mdata$obsm$temp_df <- as.data.frame(embedding_df)
  return(mdata)
}
