library(sorvi)
sp <- PreprocessShapeMML(readShapePoly("kunta1_p.shp"))
save(sp, file = "kunnat.RData")
system("git add kunnat.RData")
system("git commit -a -m'kunnat.RData added'")
system("git push")

