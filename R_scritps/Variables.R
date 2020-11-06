###############################
## Crop_Variables
## Author: Tainá Rocha
###############################

#Library

library(raster)
library(rgdal)


## Solar Radiation

List_Solar_Radiantion <-list.files("/home/taina/Documentos/Worldclim/wc2.1_5m_srad/", pattern = ".tif", full.names = T)

Stack_Solar_Radiation <- stack(List_Solar_Radiantion)
plot(Stack_Solar_Radiation)

Mean_Solar_Radiation <- mean(Stack_Solar_Radiation)
plot(Mean_Solar_Radiation)

writeRaster(Mean_Solar_Radiation, "/home/taina/Documentos/Worldclim/wc2.1_5m_srad/solar_radiation_mean.tif")

## Water vapor pressure 
List_Water_Vapor <- list.files("/home/taina/Documentos/Worldclim/wc2.1_5m_vapr/", pattern = ".tif", full.names = T)

Stack_Water_Vapor <- stack(List_Water_Vapor)
plot(Stack_Water_Vapor)

Mean_Water_Vapor <- mean(Stack_Water_Vapor)
plot(Mean_Water_Vapor)

writeRaster(Mean_Water_Vapor, "/home/taina/Documentos/Worldclim/wc2.1_5m_vapr/water_vapor_pressure_mean_.tif")

############################################ Crop envs

## Read Shape

Shape_SA_AZ <- readOGR("./dados/Syzygiella_rubricaulis/Shapes/Recorte_Netropical_Açores.shp")
plot(Shape_SA_AZ)


List_all <- list.files("/home/taina/Documentos/Worldclim/wc2.1_5m_bio/", pattern = ".tif", full.names = T)

Stack_all <- stack(List_all)
plot(Stack_all)

### Mask Crop  Solar Radiation
all_masked <- mask(x = Stack_all, mask = Shape_SA_AZ) #aplicando a máscara (shape) pela função mask do pacote raster 
plot(all_masked) # plote 

all_cropped <- crop(x = all_masked, y = extent(Shape_SA_AZ)) #agora corte por essa máscara
plot(all_cropped)

a <- paste0(names(all_cropped), ".tif")

writeRaster(all_cropped, filename= a, bylayer=TRUE) ### Isto vai salvar no local em que estiver o projeto. Veja este local no canto superior  direito 

