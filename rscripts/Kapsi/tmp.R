
url.list <- c()
# Maastotietokanta kaikki; 9.9G; several subdirs (shape)
url.list[["Maastotietokanta-kaikki"]] <- "http://kartat.kapsi.fi/files/maastotietokanta/kaikki/etrs89/shp/
# Maastokartta 100
url.list[["Maastokartta-100"]] <- "http://kartat.kapsi.fi/files/maastokartta_100k/kaikki/etrs89/shp/"
# Maastokartta 250
url.list[["Maastokartta-250"]] <- "http://kartat.kapsi.fi/files/maastokartta_250k/kaikki/etrs89/shp/"

library(XML)
temp <- readHTMLTable("http://kartat.kapsi.fi/files/maastokartta_100k/kaikki/etrs89/shp/")
as.vector(temp[[1]]$Name)

# ---------------------------


URLs <- c("http://gis.tirol.gv.at/ogd/umwelt/wasser/wis_gew_pl.zip",
          "http://gis.tirol.gv.at/ogd/umwelt/wasser/wis_tseepeicher_pl.zip")
 
url_shp_to_spdf <- function(URL) {
 
  require(rgdal)
 
  wd <- getwd()
  td <- tempdir()
  setwd(td)
 
  temp <- tempfile(fileext = ".zip")
  download.file(URL, temp)
  unzip(temp)
 
  shp <- dir(tempdir(), "*.shp$")
  lyr <- sub(".shp$", "", shp)
  y <- lapply(X = lyr, FUN = function(x) readOGR(dsn=shp, layer=lyr))
  names(y) <- lyr
 
  unlink(dir(td))
  setwd(wd)
  return(y)
  }
 
y <- lapply(URLs, url_shp_to_spdf)
z <- unlist(unlist(y))
 
# finally use it:
plot(z[[1]])

# ------------------------

