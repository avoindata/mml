

# Convert certain key data files from MML, obtained through Kapsi, into RData format.
# From http://kartat.kapsi.fi/
# List the data sets relevant to our present R tools

file.list <- c()

# Maastotietokanta tiestö osoitteilla 1; 14K; 
file.list[["Yleiskartta-1000"]] <- "2012/1_milj_Shape_etrs_shape.zip"
file.list[["Yleiskartta-4500"]] <- "2012/4_5_milj_shape_etrs-tm35fin.zip"

# Directory to store the data
destination.dir <- "../../rdata/2012/"

library(sorvi)
source("../Kapsi/funcs.R")

for (id in names(file.list)) {

  # Pick the MML Shape files
  zipfile <- file.list[[id]]

  # Set up temporary directory
  tmp.dir <- tempdir()

  # Get the data
  dat <- GetMML(zipfile, tmp.dir)

  # Convert to RData and store to rdata/ subdir and save the original zip files
  output.dir <- ConvertMMLToRData(dat$shape.list, output.dir = paste(destination.dir, id, "/", sep = ""))
  # system(paste("cp ", dat$zipfile, output.dir))

  message("Copying the annotation files")
  for (of in dat$other.files) {
    system(paste("cp ", of, output.dir))
  }

  # Remove contents from the temporary directory
  system(paste("rm ", tmp.dir, "/*", sep = ""))

  # ---------------------------------------------------------

  fnam <- paste(output.dir, "README", sep = "")

  write(paste("The RData files in this directory were converted from", fnam, "on", date(), "with https://github.com/avoindata/mml/blob/master/rscripts/MML/mml2rdata.R"), file = fnam)

  write(paste("Data (C) MML 2011-2012. The original zip files were downloaded manually from https://tiedostopalvelu.maanmittauslaitos.fi in 2012 and follow the municipal borders from that time."), file = fnam, append = TRUE)

  write(paste("RData Conversion (C) Leo Lahti / Louhos louhos.github.com; FreeBSD license"), file = fnam, append = TRUE)

}

# Save batch information 
fnam <- paste(destination.dir, "README", sep = "")
write("Land Survey Finland (MML) data in RData format. ", file = fnam)
write("The data (C) MML 2011-2012.", file = fnam, append = TRUE)
write("The origina zip files downloaded from MML 2012 by Leo Lahti.", file = fnam, append = TRUE)
write("For full conversion details, references and contact information, see https://github.com/avoindata/mml/tree/master/rscripts/MML", file = fnam, append = TRUE)
write(paste("Last conversion:", date()), file = fnam, append = TRUE)

