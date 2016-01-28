# Aquí están funciones utiles
elim_Acent <- function(texto, matriz_trans) {
                 nom_trans <- texto
                 for (i in seq_len(nrow(caract_trans))) {
                 nom_trans <-  str_replace_all(string = nom_trans, pattern = matriz_trans[i, 1], replacement = matriz_trans[i, 2])
                 }
                 return(nom_trans)
              }