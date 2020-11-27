######################
## Clean
######################

library(raster)
library(modleR)
library(ntbox)
#######

###### Read 

s_brasiliensi <- read.csv("./dados/Syzygiella_rubricaulis/records/New/CSV/S_rubricaulis.csv", sep = ",", dec = ".")

#S_brasilensis_2 <- read.csv (__________________)

#### data clean via "clean_dup" of ntbox

s_rubricaulis_data_clean <- clean_dup(s_brasiliensi, longitude= "longitude", latitude = "latitude", threshold = 0.035)

write.csv(s_rubricaulis_data_clean, "./dados/Syzygiella_rubricaulis/records/New/Data_Clean/s_rubricaulis_clean_ntbox_0035_final.csv", sep = ",", dec =".")


### data clean via setupd_sdmdata of modleR
predictors_list <- list.files("./dados/Syzygiella_rubricaulis/envs/", full.names = T, pattern = ".tif")

predictors <- stack(predictors_list)

sdmdata_s_brasiliense <- setup_sdmdata(species_name = unique(s_brasiliensi[2]),
                             occurrences = s_brasiliensi[3:4],
                             lon = "longitude",
                             lat = "latitude",
                             predictors = predictors,
                             models_dir = "data_clean_modleR",
                             partition_type = "crossvalidation",
                             cv_partitions = 1,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "mean",
                             png_sdmdata = TRUE,
                             n_back = 0,
                             clean_dupl = T,
                             clean_uni = T,
                             clean_nas = T,
                             select_variables = F,
                             sample_proportion = 0.5,
                             cutoff = 0.7)
########## END
