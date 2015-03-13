layer.apply <- function(indexs,FUN,...) {
 	if (class(FUN)!="function") FUN <- match.fun(FUN) 
 	
 	if (is.raster.class(indexs)) {
		x=FUN(indexs[[1]],...)
		if (!is.raster.class(x))  x=list(x)
		if (nlayers(indexs)>1) {
			if (is.raster.class(x)) {
				for (i in 2:nlayers(indexs)) x=addLayer.ext(x,FUN(indexs[[i]],...))
			} else {
				for (i in 2:nlayers(indexs)) x[[i]]=FUN(indexs[[i]],...)
			}
		}
	} else {
		y=lapply(indexs,FUN,...)
		x=y[[1]]
		for (i in y[-1]) if (!is.null(i)) x=addLayer.ext(x,i)
		
 	}
 	return(x)
}