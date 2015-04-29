###############################
## Paths and Info            ##
###############################
source("cfg.r")

fileIn      <- c('pas_fill2.nc',
                 'cropland_18512006.nc',
                 'popdens_fill2.nc')
                 
pathIn      <- '~/Documents/climInputs/climData/historic/'
                
fileOut     <- list(trans=fileIn,
                    detr=c('pas_fillSpinUp.nc',
                           'cropland_1851.nc',
                           'popdens_fillSpinUp.nc'))

varname     <- c('pas',
                'crop',
                'popdens')
                
unit        <- c("fraction",
                 'fraction',
                 '-')

fname       <- "regridLPXdiffLengthInputs.r"
###############################
## setup                     ##
###############################
layerNo    <- 0
fileIn     <- joinPaths(pathIn,fileIn)
fileOut    <- joinPaths('outputs/',fileOut)

###############################
## regrid and output         ##
###############################
regidAndOutDL <- function(fileIn,fileOutTrans,fileOutDetr,varname,unit) {
    r=brick(fileIn)
    r=layer.apply(r,FUN.memSafe,crop,y=extentDefault)
    
    nl=nlayers(r)
    for (i in 1:(nyrs-nl)) r=addLayer(r,r[[nl]])
    writeRasterStandard(r,fileOutTrans,varname,unit,fname)
    
    d=stack()
    for (i in 1:50) d=addLayer(d,r[[1]])
    writeRasterStandard(d,fileOutDetr,varname,unit,fname)
}

mapply(regidAndOutDL,fileIn,fileOut$trans,fileOut$detr,varname,unit)
