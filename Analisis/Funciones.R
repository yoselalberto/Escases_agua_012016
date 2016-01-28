# Aquí están funciones utiles
elim_Acent <- function(texto, mat_tran) {
                 nom_trans <- texto
                 for (i in seq_len(nrow(caract_trans))) {
                 nom_trans <-  str_replace_all(string = nom_trans, pattern = mat_tran[i, 1], replacement = mat_tran[i, 2])
                 }
                 return(nom_trans)
              }