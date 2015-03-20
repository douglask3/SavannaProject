library("gitProjectExtras")
setupProjectStructure()
sourceAllLibs()
library("raster")
library("ncdf")

extentDefault   = extent(c(113,154,-40,-10))

testRun         = TRUE

detrendedLength = c(full=600,
                    test=12)
                    
                    

nyrs        <- 163
                    
                    
if (testRun) detrendedLength=detrendedLength['test'] else detrendedLength=detrendedLength['full']