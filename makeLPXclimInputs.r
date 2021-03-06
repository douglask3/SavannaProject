###############################
## Paths and Info            ##
###############################
source("cfg.r")

fileTS3.1  <- c('cru_ts3.22.1901.2013.cld.dat.nc',
                'cru_ts3.22.1901.2013.pre.dat.nc',
                'cru_ts3.22.1901.2013.tmn.dat.nc',
                'cru_ts3.22.1901.2013.tmx.dat.nc',
                'cru_ts3.22.1901.2013.wet.dat.nc')
pathTS3.1  <-   'data/'
                
fileDetr   <- c('clt_19512000detr.nc',
                'pr_19512000detr.nc',
                'tasmin_19512000detr.nc',
                'tasmax_19512000detr.nc',
                'wetdays_19512000detr.nc')
pathDetr   <- '~/Documents/climInputs/detrended/'

fileOut    <- list(trans=c('cru_ts2.19502000detr.ts3.22.1901.2013.cld.dat.nc',
                           'cru_ts2.19502000detr.ts3.22.1901.2013.pre.dat.nc',
                           'cru_ts2.19502000detr.ts3.22.1901.2013.tmn.dat.nc',
                           'cru_ts2.19502000detr.ts3.22.1901.2013.tmx.dat.nc',
                           'cru_ts2.19502000detr.ts3.22.1901.2013.wet.dat.nc'),
                   detr =c('cru_ts2.19502000detr.cld.dat.nc',
                           'cru_ts2.19502000detr.pre.dat.nc',
                           'cru_ts2.19502000detr.tmn.dat.nc',
                           'cru_ts2.19502000detr.tmx.dat.nc',
                           'cru_ts2.19502000detr.wet.dat.nc'))
                           
                        

varnames   <- c('clt',
                'pr',
                'tasmin',
                'tasmax',
                'wetdays')
            
units      <- c('%',
                'm/s',
                'K',
                'K',
                'no. days')
                
scalings   <- list(list('*',1),
                   list('/',365*24*60*60/12),
                   list('+',273.15),
                   list('+',273.15),
                   list('*',1))

fname      <- "makeLPXclimInputs.r"

###############################
## setup                     ##
###############################
layerNo     <- 0

fileTS3.1   <- joinPaths(pathTS3.1 ,fileTS3.1)
fileDetr    <- joinPaths(pathDetr  ,fileDetr )
fileOut     <- joinPaths('outputs/',fileOut  )

###############################
## requred functions         ##
###############################
regridclim <- function(r,samp,scaling) {
    r = crop(r,y=extentDefault)
    r = resample(r,samp)
    return(match.fun(scaling[[1]])(r,scaling[[2]]))
}

regridAndOut <- function(fileTS3.1,fileDetr,fileOutTrans,fileOutDetr,
                         varname,unit,scaling) {
    c(old,regrid):=regridData(fileTS3.1,fileDetr,regridclim,scaling)
    clim=addLayer(old,regrid)
    writeRasterStandardTransDetr(clim,fileOutTrans,fileOutDetr,varname,unit,fname)
    return(clim)
}

###############################
## regrid & Test              ##
###############################
dats=mapply(regridAndOut,fileTS3.1, fileDetr, fileOut$trans, fileOut$detr,
            varnames, units, scalings)

graphics.off()
mapply(testTSplot,dats,fileOut$trans)