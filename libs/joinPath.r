joinPath    <- function(a,b) paste(a,b,sep="/")


joinPaths    <- function(a,b)
    if (class(b)=='list') return (lapply(b,joinPaths,a=a)) else return(joinPath(a,b))