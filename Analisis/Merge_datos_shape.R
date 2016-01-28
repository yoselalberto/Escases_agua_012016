# junto los datos y las shapes de las colonias
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(stringr)
library(magrittr)
library(dplyr)


# cargado de datos
mapa_colonias <- readOGR(dsn = "../Datos/Shape_colonias", layer = "Colonias_df",
                         stringsAsFactors = FALSE)
res_afect     <- readRDS("../Datos/Resumen_afectacion.Rds")
del_col       <- readRDS("../Datos/Delegacion_colonias.Rds")

# cambio los nombres de las variables
names(mapa_colonias) %<>% str_to_lower(locale = "sp")




# gráficas exploratorias
png(filename = "../Imagenes/Colonias_df.png", width = 600, height = 670, bg = "gray97", res = 600)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15)
plot(mapa_colonias, bg = "gray97")
dev.off()


