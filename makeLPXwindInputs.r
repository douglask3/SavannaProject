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

FUN.memSafe <- function(r,FUN,...) {
    layerNo <<- layerNo + 1
    print( layerNo )
    tempFileName=paste("temp/r",layerNo,sep="")
    r=FUN(r,...)
    return(writeRaster(r,filename=tempFileName,overwrite=TRUE))
}

###############################
## regrid new data           ##
###############################
In  = brick(fileIn[1])
old = brick(fileIn[2])

old = layer.apply(old,crop,y=extentDefault)

samp = old[[1]]
regrid=layer.apply(In,FUN.memSafe,regridWind)

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