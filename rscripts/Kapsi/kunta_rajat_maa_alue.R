library(sf)
library(tidyverse)

# Helper functions --------------------------------------------------------

get_data <- function(url, target_dir) {
  target_dir <- file.path(target_dir, gsub("\\.zip", "", basename(url)))
  target_zip <- file.path(target_dir, basename(url))
  
  if (!file.exists(target_dir)) {
    dir.create(target_dir)
  }
  
    download.file(url, target_zip)
  unzip(target_zip, exdir = target_dir)
  return(invisible(TRUE))
}

# Get data ----------------------------------------------------------------

kuntarajat_url <- "http://kartat.kapsi.fi/files/kuntajako/kuntajako_1000k/etrs89/shp/TietoaKuntajaosta_2017_1000k.zip"
yleiskartta_url <- "http://kartat.kapsi.fi/files/yleiskartta_1000k/kaikki/etrs89/shape/1_milj_Shape_etrs_shape.zip"

target_dir <- "data/mml"

get_data(kuntarajat_url, target_dir)
get_data(yleiskartta_url, target_dir)

# Process data ------------------------------------------------------------

municipal_borders <- sf::st_read("data/mml/TietoaKuntajaosta_2017_1000k/SuomenKuntajako_2017_1000k.shp")
# No need to reproject, but set CRS to EPSG:3067 (same as municipal borders)
water_area <- sf::st_read("data/mml/1_milj_Shape_etrs_shape/VesiAlue.shp") %>% 
  sf::st_set_crs(3067)
sea_area <- water_area %>% 
  dplyr::filter(Kohdeluokk == 36211) 

sf::st_bbox(sea_area)

# Filter only sea areas and remove them
municipal_borders_land <- municipal_borders %>% 
  sf::st_difference(sf::st_union(sf::st_combine(sea_area)))

# Since the previous operation works only on the intersection of layer
# bounding boxes (?), find out which municipalities are left out and bring them
# back in.
municipal_borders_land <- municipal_borders %>% 
  dplyr::filter(!GML_ID %in% municipal_borders_land$GML_ID) %>% 
  rbind(municipal_borders_land) %>% 
  # Also coerce GML_ID back to characted, otherwise GDAL won't like it
  # when writing a shapfile
  dplyr::mutate(GML_ID = as.character(GML_ID)) %>% 
  # For now, the data is a strange mix of POLYGONs and MULTIPOLYGONs.
  # Cast explicitly to MULTIPOLYGON just to be sure.
  sf::st_cast("MULTIPOLYGON")

# Write data --------------------------------------------------------------

output_file <- file.path(target_dir, "kuntajako_2017_maa_alueet.shp")
sf::st_write(municipal_borders_land, output_file)

# zip it as well
shp_files <- list.files(dirname(output_file), gsub("\\..{3}$", "", 
                                                   basename(output_file)),
                        full.names = TRUE)
zip(gsub("\\.shp", "\\.zip", output_file), files = shp_files)
