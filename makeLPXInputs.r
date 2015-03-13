source("cfg.r")

##Make wind

fileIn  <- c('data/wspd.sig995.mon.mean.nc',
             'data/uvas_19512000detr.nc')

fileOut <- 'outputs/uvas_wspd.sig995.mon.mean.1900-2013.nc'

repeatN <- 3


###############################
## regrid new data           ##
###############################
In  = brick(fileIn[1])[[1:120]]
old = brick(fileIn[2])
samp= old[[1]]
layerNo=0
regridWind <- function(r) {
    layerNo <<- layerNo + 1
    print( layerNo )
    tempFileName=paste("temp/r",tempFileNo,".nc",sep="")
    r=disaggregate(r,5)
    r=resample(r,samp)
    return(writeRaster(r,filename=tempFileName,overwrite=TRUE))
}


regrid=layer.apply(In,regridWind)

rept  = regrid[[(layerNo-11):layerNo]]

wind=addLayer(old,regrid)
for (i in 1:repeatN) wind=addLayer(wind,rept)

writeRaster(wind,fileOut)


    
