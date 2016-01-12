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
modisNDVIlayers
plot(modisNDVIlayers[[1]])
#dataset with cities/municipalities
nlCity <- raster::getData('GADM',country='NLD', level=2)
nlCity
#put both dataframes in same projection
nlCityUTM <- spTransform(nlCity, CRS(proj4string(modisNDVIlayers)))

#get greenest municipality in january

#write a function with a defined month
r <- modisNDVIlayers
extractedNDVIJan <- extract(r, nlCityUTM, layer=1, fun=mean, na.rm=TRUE)
greenestMunicipJan <- nlCityUTM$NAME_2[extractedNDVIAug == max(extractedNDVIAug)]
paste("Greenest municipality in January =", greenestMunicipJan)
plot(greenestMunicipJan)

extractedNDVIall
#get greenest municipality in august
extractedNDVIAug <- extract(r, nlCityUTM, layer=8, fun=mean, na.rm=TRUE)

greenestMunicipAug <- nlCityUTM$NAME_2[extractedNDVIAug == median(extractedNDVIAug)]
paste("Greenest municipality in August =", greenestMunicipAug)
plot(nlCityUTM[extractedNDVIAug == max(extractedNDVIAug)])

#get greenest municipality on average

extractedNDVIAvg <- extract(r, nlCityUTM, fun=mean, na.rm=TRUE)
extractedNDVIAvg
greenestMuniciAvg<- nlCityUTM$NAME_2[extractedNDVIAvg == max(extractedNDVIAvg)]
paste("Greenest municipality on average =", greenestMuniciAvg)
plot(nlCityUTM[nlCityUTM$NAME_2 == greenestMuniciAvg,])

#for min a empty string

Make at least one map to visualize the results

greenMunicipalPoly <- mask(modisNDVIlayers[[1]], nlCityUTM[nlCityUTM$NAME_2 == greenestMuniciAvg,])

# Set graphical parameters (one row and two columns)
plot(extentst)
plot(greenMunicipalPoly, main='Mask()', ylim=c(5850000, 5950000), xlim=c(350000, 420000))
#solve
?plot

# Reset graphical parameters
par(opar)


plotRGB()
