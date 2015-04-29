regridData <- function(fileTS3.1,fileDetr,FUN,...) {
    ###############################
    ## regrid new data           ##
    ###############################
    In  = brick(fileTS3.1)
    old = brick(fileDetr)
    if (testRun) {
        In  = In [[1:12]]
        old = old[[1:12]]
    }
    
    old    = layer.apply(old,FUN.memSafe,crop,y=extentDefault)
    samp   = old[[1]]
    regrid = layer.apply(In,FUN.memSafe,FUN,samp,...)
    return(list(old,regrid))
}