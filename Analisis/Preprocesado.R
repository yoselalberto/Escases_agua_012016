# preprocesado de las colonias
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(rvest)
library(magrittr)
library(stringr)
# funciones utiles
source("Funciones.R")

# cargado de datos
colonias_texto <- readLines(con = "../Datos/Colonias.txt")[-1]
# eliminare "escases" y "Desabasto total" del nombre de la colonia
# caracteres conflictivos
caract_de <- c("á", "é", "í", "ó", "ú", "Á", "Ú")
caract_to <- c("a", "e", "i", "o", "u", "a", "u")
caract_trans <- matrix(c(caract_de, caract_to), ncol = 2)
#colnames(caract_trans) <- c("de", "to")

colonias_nombre <- colonias_texto %>% 
                   str_replace(pattern = "Desabasto total|escasez", replacement = "") %>%
                   str_trim(side = "right")  %>%
                   str_to_lower()
# quito el acento
colonias <- elim_Acent(colonias_nombre, caract_trans)
# creo una lista de las delegaciones con colonias afectadas
info_deleg <- grep(pattern = "[0-9]{1,2}.\\|.[1-9]{1,2}$", x = colonias_texto, value = FALSE)
resumen_deleg <- colonias_texto[info_deleg]

# Afectacion
afectados <- str_replace_all(resumen_deleg, pattern = '[a-zA-Z]+|[áÁóé]', replacement = "") %>%
             str_trim(side = "left")
# total de colonias afectadas
total <- as.integer(str_extract_all(string = afectados, pattern = "^[0-9]{1,2}", simplify = TRUE))
# sin_agua
sin_agua <- as.integer(str_extract_all(string = afectados, pattern = "[0-9]{1,2}$", simplify = TRUE))
# escases
escases <- total - sin_agua

# Colonias afectadas por delegacion
delegaciones <- vector(mode = "list", length = length(resumen_deleg))
names(delegaciones) <- str_replace_all(resumen_deleg, pattern = '[0-9]{1,2}|\\|', replacement = "") %>%
                       str_replace(pattern = "   ", replacement = "")
# vector con la ubicacion de las delegaciones + num.final
rengl_deleg <- grepl(pattern = "[0-9]{1,2}.\\|.[1-9]{1,2}$", x = colonias_nombre) %>%
               which() %>%
               c(sum(length(colonias), 1))
# magia
for (i in seq_along(delegaciones)) {
    afect_local <- seq(from = sum(rengl_deleg[i], 1), to = sum(rengl_deleg[i + 1], -1))
    delegaciones[[i]] <- colonias[afect_local]
    rm(afect_local)
}
# guardo las colonias afectadas por delegacion
#saveRDS(delegaciones, file = "../Datos/Delegacion_colonias.Rds", compress = FALSE)


# agrupo la info de las afectaciones
afectacion <- data.frame(delegacion = names(delegaciones), total = total, sin_agua = sin_agua,
                         escases = escases)
#saveRDS(afectacion, file = "../Datos/Resumen_afectacion.Rds", compress = FALSE)

