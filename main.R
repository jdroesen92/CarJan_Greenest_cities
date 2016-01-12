#Careli Caballero and Jan Droesen
#Team CarJan
#12-01-2016


#libraries
library(raster)
library(rgeos)
library(rgdal)

inputfolder <- '' (inputfolder)
	
outputfolder <-
#function calls

#download the data
modisNDVI <- "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip"

dir.create("data", showWarnings = FALSE)

inputZip <- list.files(path='data', pattern= '^.*\\.zip$')
if (length(inputZip) == 0){ ##only download when not alrady downloaded (safes time to debug the whole script)
	download.file(url = modisNDVI, destfile = 'data/ndvi.zip', method = 'wget')
}
unzip('data/ndvi.zip')

#process data
modisNDVIgrid <- list.files(pattern = glob2rx('*.grd'), full.names = TRUE)
modisNDVIlayers <- brick(modisNDVIgrid)


#dataset with cities/municipalities
nlCity <- raster::getData('GADM',country='NLD', level=2)

#put both dataframes in same projection
nlCityUTM <- spTransform(nlCity, CRS(proj4string(modisNDVIlayers)))


#get greenest municipality per month (input = in numbers)
source('R/calcGreenestMunicipality.R')
showGreenestMuni(1)
r <- modisNDVIlayers
r
#get maximum greenness of municipalities per year
extraNDVIStat <- extract(r, nlCityUTM, layer=ALL, fun=mean)

#avg per municipality
greenestMuniciStat <- nlCityUTM$NAME_2[extraNDVIStat == StatisticalProperty(extraNDVIStat)]
paste("Greenest municipality over the year =", greenestMuniciStat)

#source('R/calcGreennessPerYear.R')

showGreennessMunicipal(max)

extractedNDVIStat <- extract(r, nlCityUTM, nl=12, fun=mean, na.rm=TRUE)

greenMunicipalPoly <- mask(modisNDVIlayers[[1]], nlCityUTM[nlCityUTM$NAME_2 == greenestMuniciAvg,])

# Set graphical parameters
plot(greenMunicipalPoly, main='Greenest municipality', ylim=c(5850000, 5950000), xlim=c(350000, 420000))


