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
colonias_df <- readOGR(dsn = "../Datos/Shapes", layer = "Colonias_df",
                         stringsAsFactors = FALSE)

# colonias en delegaciones afectadas
afect_mapa   <- readOGR(dsn = "../Datos/Shapes", layer = "Delegaciones_afectadas",
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
# 425 - 372 = 53 colonias con agua que tienen el nombre de una afectada
nombres_del <- unique(mapa_col_afec$del)
indices_corr <- vector(mode = "integer")
for (k in seq_along(nombres_del)) {
    indices_corr <- which(mapa_col_afec$del == nombres_del[k] & 
                          mapa_col_afec$nombre %in% afectaciones[[k]]$colonia) %>%
                    c(indices_corr, .)
        
}
# mapa sin colonias repetidas
mapa_afectaciones <- mapa_col_afec[indices_corr, ]


# agrego el tipo de afectación
orden_secc <- apply(sapply(mapa_afectaciones[["nombre"]], FUN = "==", df_afectaciones$colonia),
                    MARGIN = 2, FUN = which) 


# les asigno el resultado
mapa_afectaciones$colonia <- unlist(df_afectaciones[orden_secc, c("colonia")])
mapa_afectaciones$efecto <- unlist(df_afectaciones[orden_secc, c("efecto")])
# arreglo la colonia cuauhtemoc, magdalena
cuah_mc <- which(mapa_afectaciones$colonia == "cuauhtemoc" &
                     mapa_afectaciones$del == "LA MAGDALENA CONTRERAS")
mapa_afectaciones$efecto[cuah_mc] <- "escasez"
# colores
poca_agua <- "#FEB24C"
sin_agua <- "#F03B20"
mapa_afectaciones[["color"]] <- ifelse(mapa_afectaciones$efecto == "Desabasto total", 
                                    yes = sin_agua, no = poca_agua)

writeOGR(mapa_afectaciones, dsn = "../Datos/Shapes/Colonias_afectadas", 
         layer = "colonias_afectadas", driver = "ESRI Shapefile")
# Graficado

# mapa con las colonias afectadas resaltadas
png(filename = "../Imagenes/Colonias_efecto_b.png", width = 1000, height = 1130)
par(mar = c(0, 0, 0, 0) + 0.1, xaxs = "i", yaxs = "i",  lwd = 0.15, cex = 2)
plot(colonias_df,  bg = "gray97", col = "gray90")
plot(mapa_afectaciones, col = mapa_afectaciones$color, add = TRUE)
legend("topleft", legend = c("Desabasto total", "Escasez", "Ninguna"), 
       fill = c(sin_agua, poca_agua, "gray90"), bty = "n", title = "Afectación")
dev.off()
