# este script contiene codigo de soporte para el reporte
## ---- cargado ----
mapa_df <- readOGR('../Datos/mapa_df.geojson', 'OGRGeoJSON', verbose = FALSE) %>%
    geometry()
delegaciones <- readOGR('../Datos/delegaciones.geojson', 'OGRGeoJSON',  verbose = FALSE) %>%
    geometry()
# todas las colonias
colonias_df <- readOGR('../Datos/colonias_df.geojson', 'OGRGeoJSON', 
                       stringsAsFactors = FALSE, verbose = FALSE)
# colonias afectadas
colonias_afectadas <- readOGR('../Datos/colonias_afectadas.geojson', 'OGRGeoJSON',
                              stringsAsFactors = FALSE,  verbose = FALSE)
##---- mapa_desabasto ----
mapa <- leaflet(data = colonias_afectadas) %>%
    setView(-99.168, 19.383, zoom = 11) %>%
    addProviderTiles("CartoDB.PositronNoLabels",
                     options = tileOptions(minZoom = 11, maxZoom = 14)) %>%
    setMaxBounds(-99.3649, 19.0482,-98.9403,19.5927) %>%
    addPolygons(data = mapa_df, color = "darkgrey", fill = FALSE, opacity = 1,
                weight = 4) %>%
    addPolygons(color = ~color, weight = 1, fillOpacity = 0.75, 
                popup = htmlEscape(~nombre_of)) %>%
    addPolygons(data = delegaciones, weight = 2, color = "darkgrey", fill = FALSE,
                opacity = 1) %>%
    addLegend(position = "topright", labels = c("Desabasto total", "Escasez"),
              title = "Afectación", colors = c("#F03B20", "#FEB24C"), 
              opacity = 0.8)
mapa

##---- tabla_busqueda ----
informacion <- readRDS("../Datos/Informacion_colonias.Rds")
datatable(informacion, rownames = FALSE, caption = c("Colonias con desabasto de agua"),
          filter = "top")

