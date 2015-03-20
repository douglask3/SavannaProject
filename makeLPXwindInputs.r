###############################
## setup                     ##
###############################
source("cfg.r")

fileIn  <- c('data/wspd.sig995.mon.mean.nc',
             'data/uvas_19512000detr_new.nc')

fileOut <- c(trans='uvas_wspd.sig995.mon.mean.1900-2013.nc',
             detr ='uvas_19512000detr_new.nc')
repeatN <- 3

oldChop <- 0

###############################
## setup                     ##
###############################

layerNo     <- 0
fileOut     <- joinPaths('outputs/',fileOut)

regridWind  <- function(r,samp,...) {
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
layerNo=nlayers(regrid)
rept  = regrid[[(layerNo-11):layerNo]]

wind=addLayer(old,old[[1:(nlayers(old)-12*oldChop)]],regrid)
for (i in 1:repeatN) wind=addLayer(wind,rept)

writeRasterStandardTransDetr(wind,fileOut[1],fileOut[2])

testTSplot(wind,fileOut['trans'])