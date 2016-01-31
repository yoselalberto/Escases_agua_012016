# es este script mapeo la info
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(magrittr)
library(dplyr)

# cargado de datos
# mapa delagacional
#delegaciones
dir_shp <- "../Datos/Shapes"
delegaciones <- readOGR(dsn = dir_shp,layer = "df_municipal") %>%
                geometry()
# todas las colonias
colonias_df <- readOGR(dir_shp, "Colonias_df", stringsAsFactors = FALSE)
# colonias afectadas
colonias_afectadas <- readOGR("../Datos/Shapes/Colonias_afectadas", "colonias_afectadas",
                              stringsAsFactors = FALSE)


# colores 
col_sin <- "#F03B20"
col_poca <- "#FEB24C"

# Mapas
png(filename = "../Imagenes/Colonias_efecto_1.png", width = 800, height = 900)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15, cex = 2)
plot(delegaciones, bg = "gray97")
plot(colonias_df, col = "gray90", add = TRUE)
plot(colonias_afectadas, add = TRUE, col = colonias_afectadas$color)
legend("topleft", legend = c("Desabasto total", "Escasez", "Ninguna"), 
       fill = c(col_sin, col_poca, "gray90"), bty = "n", title = "Afectación")
dev.off()