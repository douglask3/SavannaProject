source("cfg.r")

##Make wind

fileIn  <- c('data/wspd.sig995.mon.mean.nc',
             'data/uvas_19512000detr_new.nc')

fileOut <- 'outputs/uvas_wspd.sig995.mon.mean.1900-2013.nc'
repeatN <- 3
layerNo <- 0

oldChop <- 2

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
rept  = regrid[[(layerNo-11):layerNo]]

wind=addLayer(old,old[[1:(nlayers(old)-12*oldChop)]],regrid)
for (i in 1:repeatN) wind=addLayer(wind,rept)

writeRaster(wind,fileOut,overwrite=TRUE)


