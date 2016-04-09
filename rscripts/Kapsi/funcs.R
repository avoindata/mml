#' Read zip files from given URL
#'
#' Arguments:
#'   @param url url
#'
#' Returns:
#'   @return zip file list
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords utilities

url_shp_to_spdf <- function(url) {

  # Adjusted from http://thebiobucket.blogspot.co.at

  require(rgdal)

  wd <- getwd()
  td <- tempdir()
  setwd(td)

  #temp <- tempfile(fileext = ".zip")
  temp <- "tmp.zip"
  download.file(url, temp)
  unzip(temp)

  shp <- dir(tempdir(), "*.shp$")
  lyr <- sub(".shp$", "", shp)
  y <- lapply(X = lyr, FUN = function(x) readOGR(dsn=shp, layer=lyr))
  names(y) <- lyr

  unlink(dir(td))
  setwd(wd)
  return(y)
  }

#' List zip files in MML sudirectory structure on Kapsi server
#'
#' Arguments:
#'   @param url url
#'
#' Returns:
#'   @return zip file list
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords utilities

list.MML.zips <- function (url) {

  library(XML)

  temp <- readHTMLTable(url)
  entries <- as.vector(temp[[1]]$Name)
  entries <- paste(url, entries[grep("/", as.vector(temp[[1]]$Name))], sep = "")

  zips <- list()
  for (url2 in entries) {

    temp2 <- readHTMLTable(url2)
    entries2 <- as.vector(temp2[[1]]$Name)
    entries2 <- paste(url2, entries2[grep("/", as.vector(temp2[[1]]$Name))], sep = "")

    for (url3 in entries2) {
      temp3 <- readHTMLTable(url3)
      entries3 <- as.vector(temp3[[1]]$Name)
      entries3 <- paste(url3, entries3[grep(".zip", as.vector(temp3[[1]]$Name))], sep = "")
      zips[[url3]] <- entries3
    }

    if (length(grep(".zip", entries2)) > 0) {stop("zip files found in root dir - handle this")}

  }

  zips

}


#' Download Kapsi/MML data
#'
#' Arguments:
#'   @param zipfile zip file URL or local file name
#'   @param tmp.dir temporary data directory
#'
#' Returns:
#'   @return data
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords utilities

GetKapsi <- function (zipfile, tmp.dir) {

  require(maptools)

  # Temporary file name
  items <- unlist(strsplit(gsub("/", "--", zipfile), "--"));
  local.zip <- items[[length(items)]]
  local.zip <- paste(tmp.dir, local.zip, sep = "/")

  # Create temporary directory and zip file destination
  if (length(dir(tmp.dir)) == 0) {
    system(paste("mkdir ", tmp.dir))
  }

  # Download the zip file:
  if (is_url(zipfile)) {
    download.file(zipfile, destfile = local.zip)
  } else {
    local.zip <- zipfile
  }

  # Unzip the downloaded zip file
  unzip(local.zip, exdir = file.path(tmp.dir))

  # List the unzipped shape files
  shape.files <- dir(tmp.dir, pattern = ".shp$")

  shape.list <- list()
  for (f in shape.files) {

    # Read and preprocess shape file
    message(f)
    fnam <- paste(tmp.dir, "/", f, sep = "")
    sp <- NULL
    sp <- try(maptools::readShapeSpatial(fnam))

    if (length(grep("Spatial", class(sp))) == 0) {
      warning(paste("failed to read", f))
    } else {
      shape.list[[f]] <- PreprocessShapeMML(sp)
    }

  }

  list(shape.list = shape.list, zipfile = local.zip, tmp.dir = tmp.dir)

}




#' Download MML data
#'
#' Arguments:
#'   @param id name of the resource
#'   @param zipfile zip file URL or local file name
#'   @param tmp.dir temporary data directory
#'
#' Returns:
#'   @return data
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords utilities

GetMML <- function(id, zipfile, tmp.dir) {

  require(maptools)

  # Temporary file name
  items <- unlist(strsplit(gsub("/", "--", zipfile), "--"));
  local.zip <- items[[length(items)]]
  local.zip <- paste(tmp.dir, local.zip, sep = "/")

  # Download the zip file:
  if (is_url(zipfile)) {
    download.file(zipfile, destfile = local.zip)
  } else {
    local.zip <- zipfile
  }

  # Unzip the downloaded zip file
  unzip(local.zip, exdir = file.path(tmp.dir))

  # Kuntajako has a different dir structure, so it needs different processing.
  if (id == "Kuntajako-1000") {
    # List the unzipped shape files
    shape.files <- dir(file.path(tmp.dir, "Kuntajako_2016_1_1milj/mml/hallintorajat_milj_tk/2016"),
                       pattern = ".shp$", full.names = TRUE)
    pdf.files <- NA
    txt.files <- dir(tmp.dir, pattern = ".txt$", recursive = TRUE,
                     full.names = TRUE)
  } else {
    # List the unzipped shape files
    shape.files <- dir(paste(tmp.dir, "/etrs-tm35fin/", sep = ""),
                       pattern = ".shp$", full.names = TRUE)

    system(paste("mv ", tmp.dir, "/Maanmittaus*", " ", tmp.dir,
                 "/MaanmittauslaitoksenIlmaiskayttooikeuslisenssiYleiskartta.pdf",
                 ssep = ""))
    pdf.files <- dir(tmp.dir, pattern = "Maanmittaus", full.names = TRUE)
    txt.files <- dir(tmp.dir, pattern = ".txt$", full.names = TRUE)
  }

  shape.list <- list()
  for (f in shape.files) {

    # Read and preprocess shape file
    message(f)
    sp <- NULL
    sp <- try(maptools::readShapeSpatial(f))

    if (length(grep("Spatial", class(sp))) == 0) {
      warning(paste("failed to read", f))
    } else {
      fsplit <- unlist(strsplit(f, "/"));
      fout <- fsplit[[length(fsplit)]]
      shape.list[[fout]] <- PreprocessShapeMML(sp)
    }

  }

  return(list(shape.list = shape.list, zipfile = local.zip, tmp.dir = tmp.dir,
              other.files = c(pdf.files, txt.files)))

}




#' Convert MML shape objects into RData format. For detailed example, see https://github.com/louhos/sorvi/wiki/Maanmittauslaitos
#'
#' Arguments:
#'   @param MML output from GetShapeMML(input.data.dir = ".")
#'   @param output.dir output data directory
#'
#' Returns:
#'   @return output data directory name
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords utilities

ConvertMMLToRData <- function (MML, output.dir) {

  if (length(dir(output.dir)) == 0) {
    nams <- unlist(strsplit(gsub("/", "--", output.dir), "--"))
    dir.orig <- getwd()
    k <- 1
    while (k <= length(nams)) {
      system(paste("mkdir", nams[[k]]))
      setwd(nams[[k]])
      k <- k+1
    }
    setwd(dir.orig)
  }

  for (item in names(MML)) {
    message(item)

    sp <- MML[[item]]

    fnam <- paste(output.dir, item, ".RData", sep = "")
    fnam <- gsub(".shp", "", fnam)

    # Save the data
    message(paste("Saving data to ", fnam))
    save(sp, file = fnam)

  }

  output.dir

}





#' Preprocessing function for MML data
#'
#' This script can be used to preprocess shape data
#' obtained from Finnish geographical agency (Maanmittauslaitos, MML)
#' The data copyright is on (C) MML 2011.
#'
#' @aliases preprocess.shape.mml
#'
#' Arguments:
#'   @param sp Shape object (SpatialPolygonsDataFrame)
#'
#' Returns:
#'   @return Shape object (from SpatialPolygonsDataFrame class)
#'
#' @details The various Finland shape data files obtained from http://www.maanmittauslaitos.fi/aineistot-palvelut/digitaaliset-tuotteet/ilmaiset-aineistot/hankinta have been preprocessed with this function, and the preprocessed versions are included in soRvi package. You can also download shape files and apply this function.
#'
#' @export
#' @references
#' See citation("sorvi")
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples # Not run:
#' # load(url(paste(sorvi.data.url, "MML.rda", sep = "")));
#' # sp <- MML[[1]][[1]];
#' # sp2 <- PreprocessShapeMML(sp)
#'
#' @keywords utilities

PreprocessShapeMML <- function (sp) {

  # TODO: parseri, joka poimii vain oleelliset tiedot data.frameen
  # ja tekee tarpeelliset merkistomuunnokset.
  # names(sp)
  # "Suuralue"  "Suural_ni1" "Suural_ni2"
  # "AVI"        "AVI_ni1"    "AVI_ni2"
  # "Maakunta"   "Maaku_ni1" "Maaku_ni2"
  # "Seutukunta" "Seutuk_ni1" "Seutuk_ni2"
  # "Kunta"     "Kunta_ni1"  "Kunta_ni2"
  # "Kieli_ni1"  "Kieli_ni2"  # Ruotsi/Suomi
  # "Kaupunki"
  # "SHAPE_Leng" "SHAPE_Area"

  # Specify fields that need to converted into UTF-8
  nams <- colnames(sp@data)
  inds <- which(nams %in% c("AVI_ni1", "AVI_ni2", "Kieli_ni1", "Kieli_ni2", "TEXT1", "TEXT2", "TEXT3", "Suural_ni1", "Suural_ni2", "Maaku_ni1",  "Maaku_ni2", "Seutuk_ni1", "Seutuk_ni2", "Kunta_ni1", "Kunta_ni2"))
  dat <- sp@data

  # Convert encoding to UTF-8 for the text fields
  dat[, inds] <- apply(sp@data[, inds], 2, function (x) {iconv(x, from = "latin1", to = "UTF-8")})

  # Convert text fields back into factors as in the original data
  for (k in inds) { dat[, k] <- factor(dat[,k]) }

  ###################################

  # The name (ni1) is always given with the main language (Kieli_ni1)
  # For compatibility with other data sources, add fields where all
  # names are systematically listed in Finnish, no matter what is the
  # main language

  if (!is.null(sp$AVI_ni1)) {
    # All ni1 already in Finnish
    dat$AVI.FI <- iconv(sp$AVI_ni1, from = "latin1", to = "UTF-8")
  }

  if (!is.null(sp$Kieli_ni1)) {
    # All ni1 already in Finnish
    dat$Kieli.FI <- dat$Kieli_ni1
  }

  if (!is.null(sp$Suural_ni1)) {
    # All ni1 already in Finnish
    dat$Suuralue.FI   <- iconv(dat$Suural_ni1, from = "latin1", to = "UTF-8")
  }

  if (!is.null(sp$Maaku_ni1)) {
    # All ni1 already in Finnish
    dat$Maakunta.FI   <- iconv(dat$Maaku_ni1, from = "latin1", to = "UTF-8")
  }

  if (!is.null(sp$Seutuk_ni1)) {

    # Combine ni1, ni2 to use systematically Finnish names
    kunta <- as.character(sp$Seutuk_ni1)
    inds <- sp$Kieli_ni1 == "Ruotsi" & !sp$Seutuk_ni2 == "N_A"
    kunta[inds] <- as.character(sp$Seutuk_ni2[inds])
    dat$Seutukunta.FI <- factor(iconv(kunta, from = "latin1", to = "UTF-8"))

  }

  if (!is.null(sp$Kunta_ni1)) {
    # Combine ni1, ni2 to use systematically Finnish names
    kunta <- as.character(sp$Kunta_ni1)
    inds <- sp$Kieli_ni1 == "Ruotsi" & !sp$Kunta_ni2 == "N_A"
    kunta[inds] <- as.character(sp$Kunta_ni2[inds])
    dat$Kunta.FI <- iconv(kunta, from = "latin1", to = "UTF-8")

    dat$Kunta.FI <- convert_municipality_codes(dat$Kunta.FI)
    # Update municipality names
    dat$Kunta.FI <- factor(dat$Kunta.FI)

  }

  # The shapefile being processed is recognized to conatain municipality
  # polygons if it contains field "Enklaavi".
  # Attribute field "Enklaavi" specifies of how many parts a municipality
  # constitutes of. 1 indicates only one polygon, anything >1 means that the
  # municipality constitutes of several polygons. Other than field "Enklaavi",
  # the attribute rows are identical. Merge polygons and use the first
  # attribute row.

  # First check if multipolygon municipalities exist
  if ("Enklaavi" %in% names(dat) & any(dat$Enklaavi > 1)) {
    union_sp <- unionSpatialPolygons(sp, sp$Kunta)
    # Get only 1st attribute data row ("Enklaavi") for each municipality
    dat <- dat[which(dat$Enklaavi == 1),]

    # Use Kunta (ID) as row names, this is needed for the creation of a merged
    # SpatialPolygonsDataFrame
    row.names(dat) <- dat$Kunta

    sp <- SpatialPolygonsDataFrame(union_sp, data=dat)
  } else {
    sp@data <- dat
  }
  # Set projection string to ETRS89 TM35-FIN
  proj4string(sp) <- "+init=epsg:3067"
  return(sp)
}


