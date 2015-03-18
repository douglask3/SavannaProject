testTSplot <- function(clim,name) {
    mask=clim[[1]]; mask[]=1
    for (i in 1:nlayers(clim)) mask=mask+is.na(clim[[i]])
    mask[mask!=1]=NaN  
    
    globalClim <- function(r) {
        r=r*mask
        sum.raster(r,na.rm=TRUE)
    }

    gclim=unlist(layer.apply(clim,globalClim))
    dev.new()
    plot(gclim,type='l')
    mtext(name)
}