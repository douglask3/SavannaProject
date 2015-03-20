###############################
## Paths and Info            ##
###############################

source("cfg.r")

fileIn     <- c('cru_ts2.19502000detr.ts3.22.1901.2013.tmn.dat.nc',
                'cru_ts2.19502000detr.ts3.22.1901.2013.tmx.dat.nc')
                
fileOut    <- 'cru_ts2.19502000detr.ts3.22.1901.2013.tas.dat.nc'
varname    <- 'tas'

fname      <- "makeLPXtasInputs.r"
###############################
## setup                     ##
###############################
layerNo    <- 0
fileIn     <- joinPath('outputs/',fileIn)

###############################
## requred functions         ##
###############################
Ins  = lapply(fileIn,brick)
Outs=stack()

meanLayer <- function(r1,r2) (r1+r2)/2

for (i in 1:nlayers(Ins[[1]]))
    Outs=addLayer(Outs,FUN.memSafe(Ins[[1]][[i]],meanLayer,Ins[[2]][[i]]))

writeRasterStandard(Outs,fileOut,varname,unit,fname)
#Outs=Outs[[-1]]