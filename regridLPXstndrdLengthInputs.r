###############################
## Paths and Info            ##
###############################
source("cfg.r")

fileIn      <- c('landmask_0k.nc',
                'soildata_0k.nc',
                'lightn_climatology_otd_mlnha.nc',
                 'a_nd_fill.nc')
                
pathIn      <- '~/Documents/climInputs/detrended/'
                
fileOut     <- c('Ausmask_0k.nc',
                'soildata_0k.nc',
                'lightn_climatology_otd_mlnha.nc',
                'a_nd_fillSpinUp.nc')
                           
varname     <- c('mask',
                'soiltype',
                'lightn',
                'a_nd')
                
unit        <- c("-",
                 '-',
                 'flash/m2',
                 '-')
                 
dataType    <- c('LOG1S',
                 'INT1S',
                 'FLT4S',
                 'FLT4S')

fname       <- "regridLPXstndrdLengthInputs.r"
###############################
## setup                     ##
###############################
layerNo    <- 0
fileIn     <- joinPath(pathIn,fileIn)
fileOut    <- joinPath('outputs/',fileOut)

###############################
## regrid and output         ##
###############################
regidAndOutSL <- function(fileIn,fileOut,varname,unit,DT) {
    r=brick(fileIn)
    r=layer.apply(r,FUN.memSafe,crop,y=extentDefault)
    writeRasterStandard(r,fileOut,varname,unit,fname,dataType=DT)
}

mapply(regidAndOutSL,fileIn,fileOut,varname,unit,dataType)
