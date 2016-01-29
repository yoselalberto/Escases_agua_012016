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

# uno todas las colonias en un data frame
df_afectaciones <- "names<-"(afectaciones, NULL) %>% do.call(what = rbind) %>%
                    unique() 
# convervare el cuauhtemoc cuahtemoc
cuah_rep <- which(df_afectaciones$colonia == "cuauhtemoc" & df_afectaciones$efecto == "escasez")
df_afectaciones <- df_afectaciones[-cuah_rep, ] %>%
                   "row.names<-"(value = NULL)
# un par se llaman valle gomez, pero ambas tienen desabasto total
# cuauhtemoc en la cuauhtemoc no tiene agua,
# cuauhtemoc en la magdalena tiene poca

# extraigo colonias afectadas
ubic_afectadas <- which(afect_mapa$nombre %in% df_afectaciones$colonia)
mapa_col_afec <- afect_mapa[ubic_afectadas, ]

# agrego el tipo de afectación
orden_secc <- apply(sapply(mapa_col_afec[["nombre"]], FUN = "==", df_afectaciones$colonia),
                    MARGIN = 2, FUN = which) 


# les asigno el resultado
mapa_col_afec$colonia <- unlist(df_afectaciones[orden_secc, c("colonia")])
mapa_col_afec$efecto <- unlist(df_afectaciones[orden_secc, c("efecto")])
# colores
poca_agua <- "#FEB24C"
sin_agua <- "#F03B20"
mapa_col_afec[["color"]] <- ifelse(mapa_col_afec$efecto == "Desabasto total", 
                                    yes = sin_agua, no = poca_agua)

writeOGR(mapa_col_afec, dsn = "../Datos/Shape_colonias/Colonias_afectadas", 
         layer = "colonias_afectadas", driver = "ESRI Shapefile")
# Graficado

# mapa con las colonias afectadas resaltadas
png(filename = "../Imagenes/Colonias_efecto.png", width = 1000, height = 1130)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15, cex = 2)
plot(colonias_df,  bg = "gray97", col = "gray90")
plot(mapa_col_afec, col = mapa_col_afec$color, add = TRUE)
legend("topleft", legend = c("Desabasto total", "Escasez", "Ninguna"), 
       fill = c(sin_agua, poca_agua, "gray90"), bty = "n", title = "Afectación")
dev.off()
