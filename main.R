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
showGreenestMuni(8)
#get maximum greenness of municipalities per year (credits to Froede and Daryll)
extraNDVIStat <- extract(modisNDVIlayers, nlCityUTM, fun=mean, df=TRUE, full.names=TRUE, sp=TRUE)
NDVIdataframe <- as.data.frame(extraNDVIStat)

#remove Na's
NDVIdataframe[is.na(NDVIdataframe)] <- 0
avgNDVIyear<- rowMeans(NDVIdataframe[,16:27])
NDVIdataframe <- cbind(NDVIdataframe, avgNDVIyear)

#selecting greenest municipality per year
greenestMunicipAvg <-  NDVIdataframe$NAME_2[NDVIdataframe[[28]]==max(NDVIdataframe[[28]])]
paste("Greenest municipality = ", greenestMunicipAvg)

#source('R/calcGreennessPerYear.R')


# Set graphical parameters
plot(greenMunicipalPoly, main='Greenest municipality', ylim=c(5850000, 5950000), xlim=c(350000, 420000))


