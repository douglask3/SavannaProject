###############################
## setup                     ##
###############################
source("cfg.r")

fileIn  <- c('data/wspd.sig995.mon.mean.nc',
             'data/uvas_19512000detr_new.nc')

fileOut <- 'outputs/uvas_wspd.sig995.mon.mean.1900-2013.nc'
repeatN <- 3
layerNo <- 0

oldChop <- 2

###############################
## requred functions         ##
###############################

regridWind <- function(r) {
    r=disaggregate.crop(r,extent=extentDefault,fact=5)
    r=resample(r,samp)
}

###############################
## regrid new data           ##
###############################
c(old,regrid):=regridData(fileIn[1],fileIn[2],regridWind)

###############################
## String together:          ##
##      -1850-1900 detrended ##
##      -1900-1948 detredned ##
##          (minus some yrs) ##
##      -1948-2010 transient ##
##      -2010-2013 2010 trans##
###############################
rept  = regrid[[(layerNo-11):layerNo]]

wind=addLayer(old,old[[1:(nlayers(old)-12*oldChop)]],regrid)
for (i in 1:repeatN) wind=addLayer(wind,rept)

writeRaster(wind,fileOut,overwrite=TRUE)


###############################
## Test                      ##
###############################
mask=wind[[1]]; mask[]=1
for (i in 1:nlayers(wind)) mask=mask+is.na(wind[[i]])
mask[mask!=1]=NaN  
    
globalWind <- function(r) {
    r=r*mask
    sum.raster(r,na.rm=TRUE)
}

gwinds=unlist(layer.apply(wind,globalWind))

plot(gwinds,type='l')