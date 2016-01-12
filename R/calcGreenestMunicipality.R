#also for month as a string

showGreenestMuni <- function(month) {
	r <- raster(modisNDVIlayers, layer=month)
	extractedNDVIMonth <- extract(r, nlCityUTM, fun=mean, na.rm=TRUE)
	greenestMunicipMonth <- nlCityUTM$NAME_2[extractedNDVIMonth == max(extractedNDVIMonth)]
	paste("Greenest municipality = ", greenestMunicipMonth)
}
showGreenestMuni(8)
showGreenestMuni(9)
