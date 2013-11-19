

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
  tmp.dir <- paste("tmp.", rnorm(1), sep = "")

  # Get the data
  dat <- GetMML(url, tmp.dir)

  # Convert to RData and store to rdata/ subdir and save the original zip files
  output.dir <- ConvertMMLToRData(dat$shape.list, output.dir = paste(destination.dir, id, "/", sep = ""))
  system(paste("cp ", dat$zipfile, output.dir))

  # Remove the temporary dirs
  system(paste("rm -rf ", tmp.dir))

}

# Save batch information 
fnam <- paste(destination.dir, "README", sep = "")
write("Land Survey Finland (MML) data in RData format. ", file = fnam)
write("The data (C) MML 2013.", file = fnam, append = TRUE)
write("Obtained through Kapsi.", file = fnam, append = TRUE)
write("Converted using scripts in github.com/avoindata/mml", file = fnam, append = TRUE)
write(paste("Last conversion:", date()), file = fnam, append = TRUE)
write("For full details, references and contact information, see https://github.com/avoindata/mml/tree/master/rscripts/Kapsi", file = fnam, append = TRUE)

# Send RData to datavaalit site (will require password)
# system(paste("scp -r", output.dir, "username@server.xxx:../datavaalit/storage/avoindata/mml/"))

