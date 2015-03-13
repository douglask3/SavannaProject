source("cfg.r")

##Make wind

fileIn  <- c('data/wspd.sig995.mon.mean.nc',
             'data/uvas_19512000detr.nc')

fileOut <- 'outputs/uvas_wspd.sig995.mon.mean.1900-2013.nc'

repeatN <- 3


###############################
## regrid new data           ##
###############################
In =  brick(fileIn[1])[[1:120]]
tempFileNo=0
regridWind <- function(r) {
    tempFileNo <<- tempFileNo + 1
    print( tempFileNo )
    tempFileName=paste("temp/r",tempFileNo,".nc",sep="")
    r=disaggregate(r,5)
    return(writeRaster(r,filename=tempFileName,overwrite=TRUE))
}


regrid=layer.apply(In,regridWind)

