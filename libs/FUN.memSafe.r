FUN.memSafe <- function(r,FUN,...) {
    layerNo <<- layerNo + 1
    print( layerNo )
    tempFileName=paste("temp/r",layerNo,sep="")
    r=FUN(r,...)
    return(writeRaster(r,filename=tempFileName,overwrite=TRUE))
}