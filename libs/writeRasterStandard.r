writeRasterStandard <- function(dat,filename,varname='variable',unit='',
                                fname='N/A',wname=match.call.string(),index=NULL,
                                dataType = 'FLT8S', ...) {
	
	if (!is.null(index)) dat=dat[[index]]
	print(dataType)
	writeRaster(dat,filename,varname=varname,overwrite=TRUE,
	            xname='lon',yname='lat',zname='time',unit=unit,datatype=dataType,...)
	
	nc=open.ncdf(filename,write=TRUE)
		att.put.ncdf(nc,0,"gitRepositoryURL" ,returnGitRemoteURL())
		att.put.ncdf(nc,0,"gitRevisionNumber",returnGitVersionNumber())
		att.put.ncdf(nc,0,"MainFunctionName" ,fname)
		att.put.ncdf(nc,0,"writeFunctionName",wname)
	close.ncdf(nc)
}

writeRasterStandardTransDetr <- function(clim,fileOutTrans,fileOutDetr,...) {
    writeRasterStandard(clim,fileOutTrans,...)
    writeRasterStandard(clim,fileOutDetr ,index=1:detrendedLength,...)
}