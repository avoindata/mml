# Get the urls for the data zip files in subdir structures
# Then read the shape files within these zips and store into RData

url.list <- c()
# Maastotietokanta kaikki; 9.9G; several subdirs (shape)
url.list[["Maastotietokanta-kaikki"]] <- "http://kartat.kapsi.fi/files/maastotietokanta/kaikki/etrs89/shp/"
# Maastokartta 100
url.list[["Maastokartta-100"]] <- "http://kartat.kapsi.fi/files/maastokartta_100k/kaikki/etrs89/shp/"
# Maastokartta 250
url.list[["Maastokartta-250"]] <- "http://kartat.kapsi.fi/files/maastokartta_250k/kaikki/etrs89/shp/"

# ------------------------------------------

source("funcs.R")
ziplist <- list()
for (id in names(url.list)) {
  id <- names(url.list)[[3]]
  ziplist[[id]] <- list.MML.zips(url.list[[id]])
}

#url_shp_to_spdf(url)
#y <- lapply(URLs, url_shp_to_spdf)
#z <- unlist(unlist(y))
## finally use it:
#plot(z[[1]])

library(sorvi)
conversions <- list()
for (id in names(url.list)) {

  print(id)

  # Get MML Shape file lists from Kapsi server
  urls <- ziplist[[id]]

  # Go through subdirs
  for (nam in names(urls)) {
  
    zip.urls <- urls[[nam]]
    for (url in zip.urls) {

      print(url)

      # Temporary directory
      tmp.dir <- paste("tmp.", abs(rnorm(1)), sep = "")

      # Get the data
      dat <- NULL
      tmp <- try(dat <- GetMML(url, tmp.dir))
      if (length(grep("Error", tmp) > 0)) {
        print(paste("Failed to open", url))
	conversions[[url]] <- FALSE
      } else {
        print(dim(as.data.frame(dat)))
	conversions[[url]] <- TRUE
      }

      # Convert to RData and store to rdata/ subdir and save the original zip files
      #output.dir <- ConvertMMLToRData(dat$shape.list, output.dir = paste(destination.dir, id, "/", sep = ""))
      #system(paste("cp ", dat$zipfile, output.dir))

      # Remove the temporary dirs
      system(paste("rm -rf ", tmp.dir))

    }
  }
}
