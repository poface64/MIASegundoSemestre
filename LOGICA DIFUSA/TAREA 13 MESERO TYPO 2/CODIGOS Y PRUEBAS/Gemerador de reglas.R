
# Hacer un script que me haga la combinatoria de la cosa

#### Entrada ####
### Servicio ###
servicio_maloMF
servicio_regularMF
servicio_buenoMF
### Comida ###
comida_maloMF
comida_normalMF
comida_buenaMF
comida_excelenteMF
### Comida ###
lugar_maloMF
lugar_aceptableMF
lugar_agradableMF
lugar_excelenteMF
### PROPINA ###
propina_pesimaMF
propina_bajaMF
propina_regularMF
propina_altaMF

#### Hacer la matriz de reglas ###
servicio = c("servicio_maloMF",
             "servicio_regularMF",
             "servicio_buenoMF") 
comida = c("comida_maloMF",
           "comida_normalMF",
           "comida_buenaMF",
           "comida_excelenteMF")
lugar = c("lugar_maloMF",
          "lugar_aceptableMF",
          "lugar_agradableMF",
          "lugar_excelenteMF")
propina = c("propina_pesimaMF",
            "propina_bajaMF",
            "propina_regularMF",
            "propina_altaMF")

library(combinat)


#### Matriz de combinatorias ###
combinaciones = expand.grid(servicio, comida,lugar,propina, stringsAsFactors = FALSE)
#write.csv(combinaciones,"combinaciones.csv")

#### Reglas seleccionadas ###
base = read.csv("base select.csv")

#### Seleccionar las combinaciones seleccionadas ####
base1 = combinaciones[base$Indice,]

#### Hacer las lineas de codigo que automatizan esta historia
i = 1
paste0("sistema.add_rule([('Servicio',",base1$Var1[i],
       "),('Comida',",base1$Var2[i],"),('Lugar',",base1$Var3[i],
       ")],[('Propina',",base1$Var4[i],")])")


M = paste0("sistema.add_rule([('Servicio',",base1$Var1,
           "),('Comida',",base1$Var2,"),('Lugar',",base1$Var3,
           ")],[('Propina',",base1$Var4,")])")

DM = data.frame(Reglas = M)
write.csv(DM,"reglasP.csv")









