# este script contiene codigo de soporte para el reporte
## ---- cargado ----
mapa_df <- readOGR(dsn = "../Datos/Shapes/DF", layer = "df_estatal", verbose = FALSE) %>%
    geometry()
delegaciones <- readOGR(dsn = "../Datos/Shapes", layer = "df_municipal",  verbose = FALSE) %>%
    geometry()
# todas las colonias
colonias_df <- readOGR("../Datos/Shapes", "Colonias_df", stringsAsFactors = FALSE,
                       verbose = FALSE)
# colonias afectadas
colonias_afectadas <- readOGR("../Datos/Shapes/Colonias_afectadas", "colonias_afectadas",
                              stringsAsFactors = FALSE,  verbose = FALSE)
##---- mapa_desabasto ----
mapa <- leaflet(data = colonias_afectadas) %>%
    setView(-99.168, 19.383, zoom = 11) %>%
    addProviderTiles("CartoDB.PositronNoLabels") %>%
    setMaxBounds(-99.3649, 19.0482,-98.9403,19.5927) %>%
    addPolygons(data = mapa_df, color = "darkgrey", fill = FALSE, opacity = 1,
                weight = 4) %>%
    addPolygons(color = ~color, weight = 1, fillOpacity = 0.75, 
                popup = htmlEscape(~nombre_of)) %>%
    addPolygons(data = delegaciones, weight = 2, color = "darkgrey", fill = FALSE,
                opacity = 1)
mapa