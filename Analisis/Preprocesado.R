# preprocesado de las colonias
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(rvest)
library(magrittr)
library(stringr)

# cargado de datos
colonias_texto <- readLines(con = "../Datos/Colonias.txt")[-1]
# eliminare "escases" y "Desabasto total" del nombre de la colonia 
colonias_nombre <- colonias_texto %>% 
                  str_replace(pattern = "Desabasto total|escasez", replacement = "") %>%
                  str_trim(side = "right")

# creo una lista de las delegaciones con colonias afectadas
info_deleg <- grep(pattern = "[0-9]{1,2}.\\|.[1-9]{1,2}$", x = colonias_nombre, value = FALSE)
resumen_deleg <- colonias_nombre[info_deleg]

# Afectacion
afectados <- str_replace_all(resumen_deleg, pattern = '[a-zA-Z]+|[áÁóé]', replacement = "") %>%
             str_trim(side = "left")
# total de colonias afectadas
total <- as.integer(str_extract_all(string = afectados, pattern = "^[0-9]{1,2}", simplify = TRUE))
# sin_agua
sin_agua <- as.integer(str_extract_all(string = afectados, pattern = "[0-9]{1,2}$", simplify = TRUE))
# escases
escases <- total - sin_agua
# agrupo la info
afectacion <- data.frame(delegacion = names(delegaciones), total = total, sin_agua = sin_agua,
                         escases = escases)

# Colonias afectadas por delegacion
delegaciones <- vector(mode = "list", length = length(resumen_deleg))
names(delegaciones) <- str_replace_all(resumen_deleg, pattern = '[0-9]{1,2}|\\|', replacement = "") %>%
                       str_replace(pattern = "   ", replacement = "")
# vector con la ubicacion de las delegaciones + num.final
rengl_deleg <- grepl(pattern = "[0-9]{1,2}.\\|.[1-9]{1,2}$", x = colonias_nombre) %>%
               which() %>%
               c(length(colonias_nombre))
# magia
for (i in seq_along(delegaciones)) {
    afect_local <- seq(from = sum(rengl_deleg[i], 1), to = sum(rengl_deleg[i + 1], -1))
    delegaciones[[i]] <- colonias_nombre[afect_local]
    rm(afect_local)
}
# 

