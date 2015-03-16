disaggregate.crop <- function(...) FUN.crop(disaggregate,...)

FUN.crop <- function(FUN,dat,extent=extent(c(-180,180,-90,90)),...) {
    dat=crop(dat,extent)
    return(FUN(dat,...))
}