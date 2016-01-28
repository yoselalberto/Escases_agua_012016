# preprocesado de las colonias
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(rvest)
library(magrittr)
library(stringr)

# cargado de datos
colonias_texto <- readLines(con = "../Datos/Colonias.txt")[-1]
# eliminare "escases" y "Desabasto total" del nombre de la colonia
# caracteres conflictivos
caract_de <- c("á", "é", "í", "ó", "ú", "Á", "Ú")
caract_to <- c("a", "e", "i", "o", "u", "A", "U")
caract_trans <- matrix(c(caract_de, caract_to), ncol = 2)
#colnames(caract_trans) <- c("de", "to")

colonias_nombre <- colonias_texto %>% 
                   str_replace(pattern = "Desabasto total|escasez", replacement = "") %>%
                   str_trim(side = "right")  %>%
                   str_to_lower()
# quito el acento
colonias <- sapply(X = colonias_nombre, mat_tran = caract_trans, 
                   FUN = function(texto, mat_tran) {
                            nom_trans <- texto
                            for (i in nrow(mat_tran)) {
                            nom_trans <-  str_replace_all(nom_trans, mat_tran[i, 1], mat_tran[i, 2])
                            }
                            return(nom_trans)
                         })
names(colonias) <- NULL
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
               c(sum(length(colonias_nombre), 1))
# magia
for (i in seq_along(delegaciones)) {
    afect_local <- seq(from = sum(rengl_deleg[i], 1), to = sum(rengl_deleg[i + 1], -1))
    delegaciones[[i]] <- colonias_nombre[afect_local]
    rm(afect_local)
}

# agrupo la info
afectacion <- data.frame(delegacion = names(delegaciones), total = total, sin_agua = sin_agua,
                         escases = escases)

