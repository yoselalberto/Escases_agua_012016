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
                                     c("ampl san pedro xalpa", "escasez", "Ampliación San Pedro Xalapa"),
                                     c("san bernabe", "escasez", "Barrio San Bernabé"),
                                     c("santa ines", "escasez", "Barrio Santa Inés"),
                                     c("san marcos", "escasez", "Barrio San Marcos"),
                                     c("santa cruz acayucan", "escasez", "Barrio Santa Cruz Acayucán"),
                                     c("nueva ampl el rosario", "escasez", "Nueva Ampliación El Rosario"),
                                     c("la providencia", "escasez", "Providencia"),
                                     c("barrio san sebastian", "escasez", "San Sebastián"),
                                     c("santa maria maninalco", "escasez", " Santa María Malinalco"),
                                     c("azcapotzalco 2000", "escasez", "U.H. Azcapotzalco"),
                                     c("unidad hab cuitlahuac", "escasez", "U.H. Cuitláhuac"),
                                     c("villa azcapotzalco", "escasez", "Villas Azcapotzalco"))

# benito juarez
afectacion_inc$`benito juárez` %<>% rbind(
                                         c("ampl napoles", "escasez", "Ampliación Nápoles"),
                                         c("maria del carmen", "escasez", "Carmen"),
                                         c("atenor sala", "escasez", "Atenor Salas"),
                                         c("gral pedro maria anaya", "escasez", "General Pedro María Anaya"),
                                         #c("piedad narvarte", "Desabasto total"),
                                         c("niños heroes de chapultepec", "escasez", "Niños Héroes"),
                                         c("xoco", "escasez", "Pueblo de Xoco"),
                                         c("fracc res emperadores", "Desabasto total", "Residencial Emperadores"),
                                         c("periodista francisco zarco", "escasez", "Segunda del Periodista"),
                                         c("tlacoquemecatl", "Desabasto total", "Tlacoquemécatl del Valle"),
                                         c("narvarte poniente", "Desabasto total", "Narvarte Poniente"),
                                         c("narvarte oriente", "Desabasto total", "Narvarte Oriente"),
                                         c("u hab imss narvarte", "Desabasto total", "U.H IMSS Narvarte"))

# coyoacan
carrasco <- c("del pedregal", "infonavit", "panteon mauseleos del angel",
              "unidad hab villa panamericana", "vistas del maurel", "centro urbano",
              "conjunto hab pedregal de carrasco", "pedregal del maurel", 
              "rinconada las playas infonavit", "modulo social iman")
carrasco_afect <- cbind(carrasco,"escasez", "Pedregal de Carrasco") 
colnames(carrasco_afect) <- c("colonia", "efecto", "nombre_oficial")
afectacion_inc$coyoacán  %<>% rbind(
                             c("diaz ordaz", "escasez", "Gustavo Díaz Ordaz"),
                             c("adolfo ruiz cortines", "escasez", "Ruiz Cortines"),
                             carrasco_afect)

# Cuajimalpa
#mapa_cuajimalpa <- del_afect[which(del_afect$del == "CUAJIMALPA DE MORELOS"), ]
#writeOGR(mapa_cuajimalpa, dsn = "../Datos/Shape_colonias/Cuajimalpa", layer = "cuajimalpa", 
#         driver = "ESRI Shapefile")
contadero <- c("el contadero", "pueblo la venta", "valle de las monjas")
contadero_afect <- cbind(contadero, "Desabasto total", "Contadero")
colnames(contadero_afect) <- c("colonia", "efecto", "nombre_oficial")

afectacion_inc$`cuajimalpa de morelos` %>% rbind(
                                           c("la navidad", "Desabasto total", "Navidad"),
                                           c("cooperativa palo alto", "escasez", "Palo Alto"),
                                           contadero_afect)
# la cuauhtemoc
afectacion_inc$cuauhtémoc %<>% rbind(
                              c("ampl asturias", "escasez", "Ampliación Asturias"),
                              c("santa maria la ribera", "Desabasto total", "Santa María La Rivera"),
                              c("unidad hab nonoalco tlatelolco", "escasez", "Unidad Tlatelolco")
)

# Iztacalco
#mapa_izta <- del_afect[which(del_afect$del == "IZTACALCO"), ]
#writeOGR(mapa_izta, dsn = "../Datos/Shape_colonias/Iztacalco", layer = "Iztacalco", 
#         driver = "ESRI Shapefile")
afectacion_inc$iztacalco %<>% rbind(
                             c("pantitlan", "Desabasto total", "Agrícula Pantitlán"),
                             c("santa cruz", "Desabasto total", "Barrio de la Cruz"),
                             c("gabriel ramos millan secc tlacotal", "Desabasto total", "Tlacotal"),
                             c("gabriel ramos millan secc bramadero", "escasez", "Gabriel Ramos Millán Sección Bramadero"),
                             c("ex ejido magdalena mixhuca", "escasez", "Ex Ejido de la Magdalena Mixiuca"),
                             c("san pedro", "Desabasto total", "Barrio de San Pedro"),
                             c("lic carlos zapata 1ra y 2da secc", "escasez", "Zapata Vela"))
                             
# Iztapalapa
afectacion_inc$iztapalapa %<>% rbind(
                              c("sifon", "Desabasto total", "El Sifón"),
                              c("carlos hank gonzalez", "Desabasto total", "Hank González"),
                              c("la hera", "Desabasto total", "La Era"),
                              c("plan de iguala", "Desabasto total", "Pueblo Plan de Iguala"),
                              c("los paseos de churubusco", "Desabasto total", "Paseos de Churubusco"),
                              c("san andres tetepilco", "escasez", "San Andrés Tepilco"),
                              c("unidad hab vicente guerrero", "Desabasto total", "Unidad Vicente Guerrero"),
                              c("santa maria aztahuacan", "Desabasto total", "Ejido Santa María Aztahuacan"))

# magdalena contreras
afectacion_inc$`la magdalena contreras` %<>% rbind(
                                            c("pueblo san nicolas totolapan", "Desabasto total", "Pueblo de San Nicolás Totolapan"),
                                            c("pueblo san bernabe ocotepec", "escasez", "Pueblo de San Bernabé Ocotepec"),
                                            c("pueblo la magdalena contreras", "escasez", "Pueblo de la Magdalena Contreras"),
                                            c("barrio barranca seca", "escasez", "Barranca Seca"),
                                            c("barros sierra", "escasez", "Barrio Barranca Sierra"),
                                            c("san francisco", "escasez", "Barrio San Francisco"))
    
# Miguel Hidalgo
afectacion_inc$`miguel hidalgo` %<>% rbind(
                                    c("ampl granada", "escasez", "Ampliación Granada"),
                                    c("ampl popo", "escasez", "Ampliación Popo"),
                                    c("ampl torreblanca", "Desabasto total", "Ampliación Torreblanca"),
                                    c("nueva argentina", "Desabasto total", "Argentina Poniente"),
                                    c("anahuac dos lagos", "escasez", "Dos Lagos"),
                                    c("francisco i madero", "escasez", "Francisco I. Madero"),
                                    c("manzanos", "escasez", "Los Manzanos"),
                                    c("anahuac mariano escobedo", "escasez", "Mariano Escobedo"),
                                    c("nextitla", "escasez", "Nextitla"),
                                    c("modelo", "escasez", "Modelo"),
                                    c("san diego ocoyoacac", "Desabasto total", "San Diego Ocoyoacan"),
                                    c("torreblanca", "escasez", "Torre Blanca"))

# Tlahuac
afectacion_inc$tláhuac %<>% rbind(
                           c("las arboledas", "Desabasto total", "Arboledas"),
                           c("del mar", "Desabasto total", "Del Mar"),
                           c("ampl los olivos", "Desabasto total", "Ampliación Los Olivos"),
                           c("villa centroamericana y del caribe", "escasez", "Villa Centro Americana y del Caribe"),
                           c("villas la draga", "escasez", "La Draga"),
                           c("santa ana zapotitlan", "Desabasto total", "Barrio Santa Ana Zapotitlán"))
# Venustiano
afectacion_inc$`venustiano carranza` %<>% rbind(
                           c("ampl 20 de noviembre", "escasez", "Ampliación 20 de Noviembre"),
                           c("jardin balbuena", "escasez", "Balbuena"),
                           c("valentin gomez farias", "Desabasto total", "Valentín Gómez Farías"),
                           c("moctezuma 1ra secc", "Desabasto total", "Moctezuma Primera Sección"), 
                           c("moctezuma 2da secc", "Desabasto total", "Moctezuma Seguna  Sección"))
# Alvaro Obregon
afectacion_inc$`álvaro obregón` %<>% rbind(
                                    c("lomas de axomiatla", "escasez", "Lomas de Axiomiatla"),
                                    c("lomas de los angeles tetelpan", "escasez", "Lomas de los Ángeles"),
                                    c("la otra banda", "Desabasto total", "Barrio La Otra Banda"),
                                    c("carlos a madrazo", "escasez", "Carlos A. Madrazo"),
                                    c("ermita tizapan", "Desabasto total", "Ermita tizapán"),
                                    c("isidro fabela", "escasez", "Isidro Fabela"),
                                    c("camino real de tetelpan", "escasez", "Pueblo de Tetelpan"))
# Tlalpan
afectacion_inc$tlalpan %<>% rbind(
                           c("cruz del farol", "Desabasto total", "Cruz del Faro"),
                           c("los volcanes", "escasez", "Volcanes"),
                           c("san andres totoltepec", "escasez", "San Andrés Totoltpec Pueblo"),
                           c("pedregal santa ursula xitla", "escasez", "Pedregal de Santa Úrsula"),
                           c("pedregal de san nicolas 1a seccion", "escasez", "Pedregal de San Nicolás Primera Sección"),
                           c("pedregal de san nicolas 2da secc", "Desabasto total", "Pedregal de San Nicolás Segunda Sección"),
                           c("pedregal de san nicolas 3ra secc", "Desabasto total", "Pedregal de San Nicolás Tercera Sección"),
                           c("pedregal de san nicolas 4ta secc", "Desabasto total", "Pedregal de San Nicolás Cuarta Sección"),
                           c("nuevo renacimiento de axalco", "escasez", "Nuevo Renacimiento de Axialco"),
                           #c("la nopalera", "escasez"),
                           c("maria esther zuno de echeverria", "Desabasto total", "María Esther Zuno de Echeverría"),
                           c("ejidos de sn pedro martir", "escasez", "Ejido de San Pedro Mártir"),
                           c("bosques del pedregal", "Desabasto total", "Bosque del Pedregal"),
                           c("ampl miguel hidalgo 3a seccion", "Desabasto total", "Ampliación Miguel Hidalgo Tercera Sección"),
                           c("ampl miguel hidalgo 4ta secc", "Desabasto total", "Ampliación Miguel Hidalgo Cuarta Sección"),
                           c("el mirador 2da secc", "escasez", "El Mirador II"),                        
                           c("el mirador 3ra secc", "escasez", "El Mirador Tercera Sección"),
                           c("el mirador i", "escasez", "El Mirador"))

# guardado
#saveRDS(afectacion_inc, file = "../Datos/Colonias_afectadas.Rds", compress = FALSE)
