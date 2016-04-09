# Convert data files from MML, obtained through Kapsi and PaITuli, into RData
# format.
# List the data sets relevant to our present R tools

# If run from RStudio, set the WD correctly
if (Sys.getenv("RSTUDIO") == "1") {
  setwd("rscripts/MML/")
}

file.list <- c()

# Maastotietokanta tiestö osoitteilla 1; 14K;
# From http://kartat.kapsi.fi/
file.list[["Yleiskartta-1000"]] <- list(src.file = "2012/1_milj_Shape_etrs_shape.zip",
                                        dst.dir = "../../rdata/2012")

file.list[["Yleiskartta-4500"]] <- list(src.file = "2012/4_5_milj_shape_etrs-tm35fin.zip",
                                        dst.dir = "../../rdata/2012")

# Kuntajako ilman merialueita 2016, 1:1 000 000
# From PaITuli https://research.csc.fi/paituli
file.list[["Kuntajako-1000"]] <- list(src.file = "2016/Kuntajako_2016_1_1milj.zip",
                                      dst.dir = "../../rdata/2016")

library(sorvi)
source("../Kapsi/funcs.R")

for (id in names(file.list)) {

  # Pick the MML Shape files
  zipfile <- file.list[[id]][["src.file"]]

  # Set up temporary directory
  tmp.dir <- tempdir()

  # Get the data
  dat <- GetMML(id, zipfile, tmp.dir)

  # Convert to RData and store to rdata/ subdir and save the original zip files
  output.dir <- ConvertMMLToRData(dat$shape.list,
                                  output.dir = file.path(file.list[[id]][["dst.dir"]],
                                                         id))
  # system(paste("cp ", dat$zipfile, output.dir))

  message("Copying the annotation files")
  for (of in dat$other.files) {
    if (!is.na(of)) {
      system(paste("cp ", of, output.dir))
    }
  }

  # Remove contents from the temporary directory
  system(paste("rm ", tmp.dir, "/*", sep = ""))

  # ---------------------------------------------------------

  fnam <- paste(output.dir, "README", sep = "")

  write(paste("The RData files in this directory were converted from", fnam, "on", date(), "with https://github.com/avoindata/mml/blob/master/rscripts/MML/mml2rdata.R"), file = fnam)

  write(paste("Data (C) MML 2011-2012. The original zip files were downloaded manually from https://tiedostopalvelu.maanmittauslaitos.fi in 2012 and follow the municipal borders from that time."), file = fnam, append = TRUE)

  write(paste("RData Conversion (C) Leo Lahti / Louhos louhos.github.com; FreeBSD license"), file = fnam, append = TRUE)

}

# ----------------------------------------

# Finally convert some shape files into data frames for simplified downloads
load("../../rdata/Yleiskartta-1000/HallintoAlue.RData")
df <- as.data.frame(sp)
save(df, file = "../../rdata/Yleiskartta-1000/HallintoAlue_DataFrame.RData")

# ----------------------------------------

# Save batch information
fnam <- paste(destination.dir, "README", sep = "")
write("Land Survey Finland (MML) data in RData format. ", file = fnam)
write("The data (C) MML 2011-2013.", file = fnam, append = TRUE)
write("The original zip files downloaded from MML 2013 by Leo Lahti.", file = fnam, append = TRUE)
write("For full conversion details, references and contact information, see https://github.com/avoindata/mml/tree/master/rscripts/MML", file = fnam, append = TRUE)
write(paste("Last conversion:", date()), file = fnam, append = TRUE)

