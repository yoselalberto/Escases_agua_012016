# es este script mapeo la info
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(magrittr)
library(dplyr)
library(leaflet)
library(htmltools)

# cargado de datos
# mapa delagacional
#delegaciones
dir_shp <- "../Datos/Shapes"

mapa_df <- readOGR(dsn = "../Datos/Shapes/DF",layer = "df_estatal") %>%
           geometry()
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
color_afec <- colonias_afectadas$color
centro_col <- coordinates(colonias_afectadas)
# leaflet
mapa <- leaflet(data = colonias_afectadas) %>%
        setView(-99.168, 19.383, zoom = 11) %>%
        addProviderTiles("CartoDB.PositronNoLabels") %>%
        setMaxBounds(-99.3649, 19.0482,-98.9403,19.5927) %>%
        addPolygons(data = mapa_df, weigth = 5, color = "gray40", fillColor = NULL) %>%
        addPolygons(data = delegaciones, weight = 2, color = "gray97", fillOpacity = 0.1) %>%
        addPolygons(color = ~color, weight = 1, fillOpacity = 0.6, 
                    popup = htmlEscape(~colonia))


# en png
png(filename = "../Imagenes/Colonias_efecto_1.png", width = 800, height = 900)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15, cex = 2)
plot(delegaciones, bg = "gray97")
plot(colonias_df, col = "gray90", add = TRUE)
plot(colonias_afectadas, add = TRUE, col = colonias_afectadas$color)
legend("topleft", legend = c("Desabasto total", "Escasez", "Ninguna"), 
       fill = c(col_sin, col_poca, "gray90"), bty = "n", title = "Afectación")
dev.off()