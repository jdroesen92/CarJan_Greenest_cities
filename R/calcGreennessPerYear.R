#get greenest municipality on average

r <- modisNDVIlayers
r <- stack(modisNDVIlayers)

showGreennessMunicipal <- function(StatisticalProperty) {
	extraNDVIStat <- extract(modisNDVIlayers, nlCityUTM, fun=mean,df=T, na.rm())
	extraNDVIStat
	greenestMuniciStat <- nlCityUTM$NAME_2[extraNDVIStat == StatisticalProperty(extraNDVIStat)]
	paste("Greenest municipality over the year =", greenestMuniciStat)
}
