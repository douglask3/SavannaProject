fileOld     <- "~/Documents/climInputs/climData/historic/co2_18512006.nc"
fileDat     <- "data/NOAA_CO2_19802014.tab"

fileOut     <- "outputs/co2_18512013.nc"

newIndex    <- 28:34

nc <- open.ncdf(fileOld)
oldD <- get.var.ncdf( nc ,'co2')
close.ncdf(nc)

newD = read.table(fileDat)[newIndex,2]

dat=c(oldD,newD)

# Make a few dimensions we can use
nt      <- length(dat)
xvals   <- 1:nt
dimT    <- dim.def.ncdf( "Time", "Year", (1:nt), unlim=TRUE )

# Make varables of various dimensionality, for illustration purposes
mv      <- -999 # missing value to use
var1d   <- var.def.ncdf( "CO2", "ppm", dimT, mv )

# Create the test file
nc <- create.ncdf(fileOut, list(var1d) )

# Write some data to the file
put.var.ncdf( nc, var1d, dat ) # no start or count: write all values

close.ncdf(nc)