require(sp)
require(rgdal)
require(maps)

# read in bear data, and turn it into a SpatialPointsDataFrame
coordinates(nafta) <- c("X", "Y")

okresy  <- readOGR(".", "../data/okresy/")
