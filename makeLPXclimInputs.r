###############################
## Paths and Info            ##
###############################

source("cfg.r")

fileTS3.1  <- c('cru_ts3.22.1901.2013.cld.dat.nc')
pathTS3.1  <- 'data/'
                
fileDetr   <- c('clt_19512000detr.nc')
pathDetr   <- '~/Documents/climInputs/detrended/'

fileOut    <- 'cru_ts2.19502000detr.ts3.22.1901.2013.cld.dat.nc'

varnames   <- 'clt'

units      <- '%'

###############################
## setup                     ##
###############################
layerNo     <- 0

joinPath    <- function(a,b) paste(a,b,sep="/")
fileTS3.1   <- joinPath(pathTS3.1 ,fileTS3.1)
fileDetr    <- joinPath(pathDetr  ,fileDetr )
fileOut     <- joinPath('outputs/',fileOut  )

###############################
## requred functions         ##
###############################
regridclim <- function(r,samp) {
    r=crop(r,y=extentDefault)
    r=resample(r,samp)
}

regridAndOut <- function(fileTS3.1,fileDetr,fileOut,varname,unit) {
    c(old,regrid):=regridData(fileTS3.1,fileDetr,regridclim)
    clim=addLayer(old,regrid)
    writeRaster(clim,fileOut,overwrite=TRUE,
                varname=varname,xname='lon',yname='lat',zname='time',unit=unit)
    return(clim)
}

###############################
## regrid & Test              ##
###############################
dats=mapply(regridAndOut,fileTS3.1, fileDetr, fileOut, varnames, units)

mapply(testTSplot,dats,fileOut)