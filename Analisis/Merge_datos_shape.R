# junto los datos y las shapes de las colonias
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(stringr)
library(magrittr)
library(dplyr)
source("Funciones.R")

# cargado de datos
mapa_colonias <- readOGR(dsn = "../Datos/Shape_colonias", layer = "Colonias_df",
                         stringsAsFactors = FALSE)
res_afect     <- readRDS("../Datos/Resumen_afectacion.Rds")
del_col       <- readRDS("../Datos/Delegacion_colonias.Rds")
# letras sin acento
matriz_transf <- readRDS("../Datos/Matriz_trans.Rds")
# cambio los nombres de las variables del mapa
names(mapa_colonias) <- c("id", "zip", "estado", "del", "nombre", "tipo")


# convierto a minusculas y quito acentos
mapa_colonias[["nombre"]] %<>% str_to_lower(locale = "sp") %>%
                                  elim_Acent(matriz_trans = matriz_transf)

# elimino delegaciones no afectadas
dele_con_agua <- which(mapa_colonias$del == 'GUSTAVO A MADERO' |
                       mapa_colonias$del == 'MILPA ALTA' |
                       mapa_colonias$del == 'XOCHIMILCO')
# delegaciones afectadas
mapa_colonias_afec <- mapa_colonias[-dele_con_agua, ]

# enlazo la info del mapa con la del sacdf

# delegacion y colonia
colonias_mapa_info <- data.frame(mapa_colonias_afec)[, c(4,5)] %>%
                      sapply(tolower) %>% 
                      as.data.frame(stringsAsFactors = FALSE)
# las guardare en una lista
# magia
info_colonias_mapa <- vector(mode = "list", length = length(unique(colonias_mapa_info[, 1])))
#nombro las delegaciones
names(info_colonias_mapa) <- unique(colonias_mapa_info$mun_name)
for (i in seq_along(info_colonias_mapa)) {
    info_colonias_mapa[[i]] <- filter(colonias_mapa_info, mun_name == names(info_colonias_mapa)[i]) %>%
                               select(sett_name)
    row.names(info_colonias_mapa[[i]]) <- NULL
}
# igualo los nombres de las listas
names(del_col) <- names(info_colonias_mapa)

## Comparacion de nombres
colonias_afectadas <- vector(mode = "list", length = length(info_colonias_mapa))
names(colonias_afectadas) <- names(info_colonias_mapa)
# más magia
for (j in seq_along(colonias_afectadas)) {
    colonias_afectadas[[j]] <- intersect(del_col[[j]], info_colonias_mapa[[j]]$sett_name)
}







# gráficas exploratorias
png(filename = "../Imagenes/Colonias_df.png", width = 600, height = 670, bg = "gray97", res = 600)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15)
plot(mapa_colonias, bg = "gray97")
dev.off()


