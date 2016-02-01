# es este script mapeo la info
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(dplyr)
library(stringr)
library(leaflet)
library(htmltools)
library(DT)

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
colonias_afectadas <- readOGR("../Datos/Shapes/Colonias_afectadas", 
                              "colonias_afectadas", stringsAsFactors = FALSE)
# datos para la tabla html
informacion <- data.frame(colonias_afectadas) %>%
               select(del, nombre_of, efecto) %>%
               rename(Delegación = del, Colonia = nombre_of, Afectación = efecto) %>%
               unique() %>%
               mutate(Delegación = as.factor(str_to_title(Delegación))) %>%
               mutate(Afectación = as.factor(str_to_title(Afectación))) %>%
               arrange(Delegación, Colonia)
#saveRDS(informacion, file = "../Datos/Informacion_colonias.Rds", compress = FALSE)

# Mapas

# leaflet
mapa <- leaflet(data = colonias_afectadas) %>%
        setView(-99.168, 19.383, zoom = 11) %>%
        addProviderTiles("CartoDB.PositronNoLabels",
                         options = tileOptions(minZoom = 11, maxZoom = 14)) %>%
        setMaxBounds(-99.3649, 19.0482,-98.9403,19.5927) %>%
        addPolygons(data = mapa_df, color = "darkgrey", fill = FALSE, opacity = 1,
                    weight = 4) %>%
        addPolygons(color = ~color, weight = 1, fillOpacity = 0.75, 
                    popup = htmlEscape(~nombre_of)) %>%
        addPolygons(data = delegaciones, weight = 2, color = "darkgrey", 
                    fill = FALSE, opacity = 1) %>%
# leyenda
        addLegend(position = "topright", labels = c("Desabasto total", "Escasez"),
                  title = "Afectación", colors = c(col_sin, col_poca), opacity = 0.8)

# Table HTML
datatable(informacion, rownames = FALSE, filter = "top",
          caption = c("Colonias con desabasto de agua"))
    

# en png
col_sin <- "#F03B20"
col_poca <- "#FEB24C"
png(filename = "../Imagenes/Colonias_efecto_1.png", width = 800, height = 900)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15, cex = 2)
plot(delegaciones, bg = "gray97")
plot(colonias_df, col = "gray90", add = TRUE)
plot(colonias_afectadas, add = TRUE, col = colonias_afectadas$color)
legend("topleft", legend = c("Desabasto total", "Escasez", "Ninguna"), 
       fill = c(col_sin, col_poca, "gray90"), bty = "n", title = "Afectación")
dev.off()