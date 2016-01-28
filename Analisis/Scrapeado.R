# escrapeare los datos del desabasto de agua del df, enero 2015
setwd("~/Datos/Desabasto agua/Enero 2016/Analisis")
library(rvest)
library(magrittr)

# cargo la pagina
url <- "http://media.eleconomista.com.mx/contenido/especiales/ee_especiales/2016/04_DesabastoAgua/index.html"
pagina <- read_html(url)

# descargo las colonias afectadas
datos <- html_text(pagina)
gsub(x = datos, pattern = "[\r\n\t]+", replacement = "\n") %>%
cat(file = "../Datos/Colonias.txt")

    
