

# Convert certain key data files from MML, obtained through Kapsi, into RData format.
# From http://kartat.kapsi.fi/
# List the data sets relevant to our present R tools

url.list <- c()

# Maastotietokanta tiestö osoitteilla 1; 14K; 
url.list[["Maastotietokanta-tiesto1"]] <- "http://kartat.kapsi.fi/files/maastotietokanta/tiesto_osoitteilla/etrs89/shp/N61.shp.zip" 

# Maastotietokanta tiestö osoitteilla 2; 1.3M; 
url.list[["Maastotietokanta-tiesto2"]] <- "http://kartat.kapsi.fi/files/maastotietokanta/tiesto_osoitteilla/etrs89/shp/N62.shp.zip"

# Yleiskartta 1000; 45M; 
# http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-11-000-000
url.list[["Yleiskartta-1000"]] <- "http://kartat.kapsi.fi/files/yleiskartta_1000k/kaikki/etrs89/shape/1_milj_Shape_etrs_shape.zip"

# Yleiskartta 4500; 2.8M; 
# http://www.maanmittauslaitos.fi/digituotteet/yleiskartta-14-500-000 
url.list[["Yleiskartta-4500"]] <- "http://kartat.kapsi.fi/files/yleiskartta_4500k/kaikki/etrs89/shape/4_5_milj_shape_etrs-tm35fin.zip"


# Directory to store the data
destination.dir <- "../../rdata/"

library(sorvi)
source("funcs.R")

for (id in names(url.list)) {

  # Get MML Shape files from Kapsi server
  url <- url.list[[id]]

  # Temporary directory
  tmp.dir <- tempfile(fileext = ".zip")

  # Get the data
  dat <- GetKapsi(url, tmp.dir)

  # Convert to RData and store to rdata/ subdir and save the original zip files
  output.dir <- ConvertMMLToRData(dat$shape.list, output.dir = paste(destination.dir, id, "/", sep = ""))
  # system(paste("cp ", dat$zipfile, output.dir))

  fnam <- paste(output.dir, "README.Kapsi", sep = "")

  write(paste("The RData files in this directory were converted from", url, "on", date(), "with https://github.com/avoindata/mml/blob/master/rscripts/Kapsi/kapsi2rdata.R"), file = fnam)

  write(paste("Data (C) MML 2013. The original zip files were automatically downloaded from https://tiedostopalvelu.maanmittauslaitos.fi/tp/kartta"), file = fnam, append = TRUE)

  write(paste("RData Conversion (C) Leo Lahti / Louhos louhos.github.com; FreeBSD license"), file = fnam, append = TRUE)

  write(paste("For more information of the MML map files, see http://www.maanmittauslaitos.fi"), file = fnam, append = TRUE)

}

# Easier way to download the files but not get worḱing yet
#url <- url.list[[2]]
#y <- url_shp_to_spdf(url.list[[1]])
#z <- unlist(unlist(y))

# Save batch information 
fnam <- paste(destination.dir, "README", sep = "")
write("Land Survey Finland (MML) data in RData format. ", file = fnam)
write("The data (C) MML 2013.", file = fnam, append = TRUE)
write("Obtained through Kapsi.", file = fnam, append = TRUE)
write("For full conversion details, references and contact information, see https://github.com/avoindata/mml/tree/master/rscripts/Kapsi", file = fnam, append = TRUE)
write(paste("Last conversion:", date()), file = fnam, append = TRUE)

# Send RData to datavaalit site (will require password)
# system(paste("scp -r", output.dir, "username@server.xxx:../datavaalit/storage/avoindata/mml/"))
# Also see spider.R for further shape file processing scripts.
