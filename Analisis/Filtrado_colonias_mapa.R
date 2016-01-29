# aquí resalto las colonias afectadas
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(stringr)
library(magrittr)
library(dplyr)

# cargado de datos
afectaciones <- readRDS("../Datos/Colonias_afectadas.Rds")
# todas las colonias
colonias_df <- readOGR(dsn = "../Datos/Shape_colonias", layer = "Colonias_df",
                         stringsAsFactors = FALSE)

# colonias en delegaciones afectadas
afect_mapa   <- readOGR(dsn = "../Datos/Shape_colonias/", layer = "Delegaciones_afectadas",
                     stringsAsFactors = FALSE)

nombres_colonias <- sapply(afectaciones, "[[", 1)
names(nombres_colonias) <- NULL
nom_col_afec <- unique(unlist(nombres_colonias))
# un par se llaman valle gomez, pero ambas tienen desabasto total
# cuauhtemoc en la cuauhtemoc no tiene agua,
# cuauhtemoc en la magdalena tiene poca
afectaciones$`la magdalena contreras` %<>% filter(colonia != "cuauhtemoc")

# extraigo colonias afectadas
ubic_afectadas <- which(afect_mapa$nombre %in% nom_col_afec)
mapa_col_afec <- afect_mapa[ubic_afectadas, ]

# agrego el tipo de afectación
orden_secc <- apply(sapply(mapa_col_afec[["nombre"]], FUN = "==", nom_col_afec),
                    MARGIN = 2, FUN = which) 


# les asigno el resultado
mapa_col_afec$efecto <- unlist(afectaciones[orden_secc, "efecto"])

# Graficado

# mapa con las colonias afectadas resaltadas
png(filename = "../Imagenes/Colonias_afectadas.png", width = 1000, height = 1130)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15)
plot(colonias_df,  bg = "gray97")
plot(mapa_col_afec, col = "gray85", add = TRUE)
dev.off()