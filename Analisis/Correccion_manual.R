# agrego manualmente las colonias faltantes
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(sp)
library(rgdal)
library(stringr)
library(magrittr)
library(dplyr)
source("Funciones.R")

# cargo los datos
res_afect      <- readRDS("../Datos/Resumen_afectacion.Rds")
del_col        <- readRDS("../Datos/Delegacion_colonias.Rds")
afectacion_inc <- readRDS("../Datos/Col_afec_parcial.Rds")
info_de_mapa   <- readRDS("../Datos/Info_de_mapa.Rds")
# mapa
del_afect <- readOGR(dsn = "../Datos/Shape_colonias/", layer = "Delegaciones_afectadas",
                     stringsAsFactors = FALSE)

## Correccion manual

# azcapo
afectacion_inc$azcapotzalco %<>% rbind(
                                     c("ampl san pedro xalpa", "escacez"),
                                     c("san bernabe", "escacez"),
                                     c("santa ines", "escacez"),
                                     c("san marcos", "escacez"),
                                     c("santa cruz acayucan", "escacez"),
                                     c("nueva ampl el rosario", "escacez"),
                                     c("la providencia", "escacez"),
                                     c("barrio san sebastian", "escacez"),
                                     c("santa maria maninalco", "escacez"),
                                     c("azcapotzalco 2000", "escacez"),
                                     c("unidad hab cuitlahuac", "escacez"),
                                     c("villa azcapotzalco", "escacez"))

# benito juarez
afectacion_inc$`benito juárez` %<>% rbind(
                                         c("ampl napoles", "escasez"),
                                         c("maria del carmen", "escasez"),
                                         c("atenor sala", "escasez"),
                                         c("gral pedro maria anaya", "escasez"),
                                         c("piedad narvarte", "Desabasto total"),
                                         c("niños heroes de chapultepec", "escasez"),
                                         c("xoco", "escasez"),
                                         c("fracc res emperadores", "Desabasto total"),
                                         c("periodista francisco zarco", "escasez"),
                                         c("tlacoquemecatl", "Desabasto total"),
                                         c("narvarte poniente", "Desabasto total"),
                                         c("narvarte oriente", "Desabasto total"),
                                         c("u hab imss narvarte", "Desabasto total"))

# coyoacan
carrasco <- c("del pedregal", "infonavit", "panteon mauseleos del angel", "santa ursula", 
              "unidad hab villa panamericana", "vistas del maurel", "centro urbano",
              "conjunto hab pedregal de carrasco", "pedregal del maurel", "rinconada las playas infonavit", 
              "modulo social iman")
carrasco_afect <- cbind(carrasco,"escasez") 
colnames(carrasco_afect) <- c("colonia", "efecto")
afectacion_inc$coyoacán  %<>% rbind(
                             c("diaz ordaz", "escasez"),
                             c("adolfo ruiz cortines", "escasez"),
                             carrasco_afect)

# Cuajimalpa
#mapa_cuajimalpa <- del_afect[which(del_afect$del == "CUAJIMALPA DE MORELOS"), ]
#writeOGR(mapa_cuajimalpa, dsn = "../Datos/Shape_colonias/Cuajimalpa", layer = "cuajimalpa", 
#         driver = "ESRI Shapefile")
contadero <- c("el contadero", "pueblo la venta", "valle de las monjas")
contadero_afect <- cbind(contadero, "Desabasto total")
colnames(contadero_afect) <- c("colonia", "efecto")

afectacion_inc$`cuajimalpa de morelos` %>% rbind(
                                           c("la navidad", "Desabasto total"),
                                           c("cooperativa palo alto", "escasez"),
                                           contadero_afect)
# la cuauhtemoc
afectacion_inc$cuauhtémoc %<>% rbind(
                              c("ampl asturias", "escasez"),
                              c("hipodromo", "Desabasto total"),
                              c("santa maria la ribera", "Desabasto total"),
                              c("unidad hab nonoalco tlatelolco", "escasez")
)

# Iztacalco
#mapa_izta <- del_afect[which(del_afect$del == "IZTACALCO"), ]
#writeOGR(mapa_izta, dsn = "../Datos/Shape_colonias/Iztacalco", layer = "Iztacalco", 
#         driver = "ESRI Shapefile")
afectacion_inc$iztacalco %<>% rbind(
                             c("pantitlan", "Desabasto total"),
                             c("santa cruz", "Desabasto total"),
                             c("gabriel ramos millan secc tlacotal", "Desabasto total"),
                             c("gabriel ramos millan secc bramadero", "escasez"),
                             c("ex ejido magdalena mixhuca", "escasez"),
                             c("san pedro", " Desabasto total"),
                             c("lic carlos zapata 1ra y 2da secc", "escasez"))
                             
# Iztapalapa
afectacion_inc$iztapalapa %<>% rbind(
                              c("sifon", "Desabasto total"),
                              c("carlos hank gonzalez", "Desabasto total"),
                              c("la hera", "Desabasto total"),
                              c("plan de iguala", "Desabasto total"),
                              c("magdalena atlazolpa", "escasez"),
                              c("los paseos de churubusco", "Desabasto total"),
                              c("presidentes de mexico", "Desabasto total"),
                              c("san andres tetepilco", "escasez"),
                              c("unidad hab vicente guerrero", "Desabasto total"),
                              c("santa maria aztahuacan", "Desabasto total"))

# magdalena contreras
afectacion_inc$`la magdalena contreras` %<>% rbind(
                                            c("pueblo san nicolas totolapan", "Desabasto total"),
                                            c("pueblo san bernabe ocotepec", "escasez"),
                                            c("pueblo la magdalena contreras", "escasez"),
                                            c("barrio barranca seca", "escasez"),
                                            c("barros sierra", "escasez"),
                                            c("san francisco", "escasez"))
    
# Miguel Hidalgo
afectacion_inc$`miguel hidalgo` %<>% rbind(
                                    c("ampl granada", "escasez"),
                                    c("ampl popo", "escasez"),
                                    c("ampl torreblanca", "Desabasto total"),
                                    c("nueva argentina", "Desabasto total"),
                                    c("anahuac dos lagos", "escasez"),
                                    c("francisco i madero", "escasez"),
                                    c("manzanos", "escasez"),
                                    c("anahuac mariano escobedo", "escasez"),
                                    c("nextitla", "escasez"),
                                    c("modelo", "escasez"),
                                    c("san diego ocoyoacac", "Desabasto total"),
                                    c("torreblanca", "escasez"))

# Tlahuac
afectacion_inc$tláhuac %<>% rbind(
                           c("las arboledas", "Desabasto total"),
                           c("del mar", "Desabasto total"),
                           c("ampl los olivos", "Desabasto total"),
                           c("villa centroamericana y del caribe", "escasez"),
                           c("villas la draga", "escasez"),
                           c("santa ana zapotitlan", "Desabasto total"))
# Venustiano
afectacion_inc$`venustiano carranza` %<>% rbind(
                           c("ampl 20 de noviembre", "escasez"),
                           c("jardin balbuena", "escasez"),
                           c("valentin gomez farias", "Desabasto total"),
                           c("moctezuma 1ra secc", "Desabasto total"), 
                           c("moctezuma 2da secc", "Desabasto total"))
# Alvaro Obregon
afectacion_inc$`álvaro obregón` %<>% rbind(
                                    c("lomas de axomiatla", "escasez"),
                                    c("lomas de los angeles tetelpan", "escasez"),
                                    c("la otra banda", "Desabasto total"),
                                    c("carlos a madrazo", "escasez"),
                                    c("ermita tizapan", "Desabasto total"),
                                    c("isidro fabela", "escasez"),
                                    c("camino real de tetelpan", "escasez"))
# Tlalpan
afectacion_inc$tlalpan %<>% rbind(
                           c("cruz del farol", "Desabasto total"),
                           c("los volcanes", "escasez"),
                           c("san andres totoltepec", "escasez"),
                           c("pedregal santa ursula xitla", "escasez"),
                           c("pedregal de san nicolas 1a seccion", "escasez"),
                           c("pedregal de san nicolas 2da secc", "Desabasto total"),
                           c("pedregal de san nicolas 3ra secc", "Desabasto total"),
                           c("pedregal de san nicolas 4ta secc", "Desabasto total"),
                           c("nuevo renacimiento de axalco", "escasez"),
                           c("la nopalera", "escasez"),
                           c("maria esther zuno de echeverria", "Desabasto total"),
                           c("ejidos de sn pedro martir", "escasez"),
                           c("bosques del pedregal", "Desabasto total"),
                           c("ampl miguel hidalgo 3a seccion", "Desabasto total"),
                           c("ampl miguel hidalgo 4ta secc", "Desabasto total"),
                           c("el mirador 2da secc", "escasez"),                        
                           c("el mirador 3ra secc", "escasez"),
                           c("el mirador i", "escasez"))

# guardado
saveRDS(afectacion_inc, file = "../Datos/Colonias_afectadas.Rds", compress = FALSE)
