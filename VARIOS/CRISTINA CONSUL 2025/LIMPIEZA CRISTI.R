
rm(list = ls())

#### CARGAR LA BASE DE DATOS ####
library(readxl)
ruta = "BASE DE DATOS CARDIS-1.xlsx"
datos = read_excel(ruta,
                   sheet = "Hoja1") |> as.data.frame()

#### Separar las variables de interés
vars = c(3:8,63:72,6)
datos1 = datos[,vars]
head(datos1)
table(datos1$`¿A qué región de la Universidad Veracruzana perteneces?.1`)

#### Nuevo esquema ####
#### Sección CAR ####
datos1$CAR...64 = factor(datos1$CAR...64,
                         levels = c("Sin riesgo",
                                    "Riesgo moderado",
                                    "Riesgo alto"))

#### Sección TICS ####
datos1$TIC...66 = factor(datos1$TIC...66,
                         levels = c("Inexistencia de problema",
                                    "Uso problemático",
                                    "Abuso",
                                    "Dependencia"))
#### SECCIÓN ALCOHOL ####
datos1$ALCOHOL...68 = factor(datos1$ALCOHOL...68,
                            levels = c("Riesgo bajo",
                                       "Riesgo medio",
                                       "Riesgo alto",
                                       "Adicción"))

#### MARIGUANA ####
datos1$MARIHUANA2 = factor(datos1$MARIHUANA2,
                           levels = c("Riesgo bajo",
                                      "Riesgo medio",
                                      "Riesgo alto" ))

#### TABACO
datos1$TABACO2 = factor(datos1$TABACO2,
                           levels = c("Dependencia baja",
                                      "Dependencia moderada"))

#### Edad ####
datos1$edad1 = datos$`¿Cuántos años cumplidos tienes?`
### Esquema de discretización ###
datos1$edad2[datos1$edad1<=18] = "18 o ménos"
datos1$edad2[datos1$edad1>=19 & datos1$edad1<=20] = "19 a 20"
datos1$edad2[datos1$edad1>=21 & datos1$edad1<=22] = "21 a 22"
datos1$edad2[datos1$edad1>=23 & datos1$edad1<=24] = "23 a 24"
datos1$edad2[datos1$edad1>24] = "24 o más"

####  Separar las variables de interes ####
mini = datos1[,c(19,1,4,8,10,12,14,16)]
names(mini) = c("Edad","Sexo","Región","CAR","TIC","ALCOHOL","MARIHUANA","TABACO")
#### Poza rica imputación del dato ####
mini[is.na(mini$Región)==T,3] = "Poza Rica-Tuxpan"

head(datos1)

#### Revisar los puntajes ####
mini2 = datos1[ ,c(7,9,11,13,15,18)]
names(mini2) = c("CAR","TIC","ALCOHOL","MARIHUANA","TABACO","EDAD")
### VERIFICAR LA NORMALIDAD DE LAS VARIABLES ####
shapiro.test(mini2$CAR) # No es normal
shapiro.test(mini2$TIC) # No es normal
shapiro.test(mini2$ALCOHOL) # No es normal
shapiro.test(mini2$TABACO) # No es normal
shapiro.test(mini2$EDAD) # No es normal

plot(mini2[,-6],
     pch = 16)


#### Correlación de SPEARMAN ####
library(corrplot)
cor(mini2[,-6])


corrplot(cor(mini2[,-6]),
         addCoef.col = 'black', tl.pos = 'd',
         cl.pos = 'n')



library(FactoMineR)
library(factoextra)
#### sexo, edad, CAR, TICS consumos ###
# Para hacer el correspondencias MULTIPLES
P1 = mini[,c(2,1,4,5,6,7,8)]
head(P1)
ACM1 = MCA(P1,graph = T)
table(datos$CFL.ÁREA.TRAB)

# Gráfico de sedimentos con etiquetas
fviz_screeplot(ACM, addlabels = TRUE)
# Gráfico biplot
fviz_mca_biplot(ACM1) 
  
#### sexo, edad, CAR, TICS consumos ####
# Para hacer el correspondencias MULTIPLES
P1 = mini[,c(3,4,5,6,7,8)]
ACM1 = MCA(P1,graph = T)

# Gráfico de sedimentos con etiquetas
fviz_screeplot(ACM1, addlabels = TRUE)
# Gráfico biplot
g1 = fviz_mca_biplot(ACM1) 

#### 
library(rsvg)
library(jpeg)
ggsave("g1.svg", g1, 
       width = 8, height = 6,
       dpi = 8000)
sv = rsvg("g1.svg",
          height = 2000,
          width = 3000)
### Exportar en jpeg
writeJPEG(sv, "g1.jpg",
          quality = 12)

#######################
#### Buscar la asociación entre las variables por edad
# Hago el contenedor de variables

varis = c("CAR",
          "TIC",
          "ALCOHOL",
          "MARIHUANA",
          "TABACO")

### Creo el contenedor 
contenedor =  data.frame(var1="H",var2="H" ,Ji = 0,G.l = 0,Pvalor = 0)
### Ciclo para la cosa ###
for(i in 1:length(varis)){
  #### Fijando la variable de sexo
  #### Hacer el recorrido ####
  sujeto = contenedor[1,]
  ### Extraer los nombres
  sujeto[,1:2] = c(varis[i],"Edad")
  ### Hago la tabla chi
  # Variables
  vrb = c(varis[i],"Edad")
  tabla = table(mini[,vrb])
  chicuad = chisq.test(tabla)
  ### Agregar al sujeto lo que falta
  sujeto[,3:5] = round(c(chicuad$statistic,
                         chicuad$parameter,
                         chicuad$p.value),6)
  ### Poner el sujeto en su lugar
  contenedor  = rbind.data.frame(contenedor,
                                 sujeto)
  
}



contenedor$Pvalor1 = round(contenedor$Pvalor,2)


table(mini$Edad,mini$TIC)
table(mini$Edad,mini$ALCOHOL)
table(mini$Edad,mini$MARIHUANA)
table(mini$Edad,mini$TABACO)



mini[c(115,208),]
table(mini$Región)

# Edad
# Sexo
# Región

# CAR
# TIC
# ALCOHOL
# MARIHUANA
# TABACO
names(datos1)




table(datos1$`¿A qué facultad perteneces?`)

names(datos1)





### CRUZAR TODAS CON TODAS ####

### CRUZAR TODAS CON TODAS ####

# Hago el contenedor de variables
varis = c("CAR...64",
          "TIC...66",
          "ALCOHOL...68",
          "MARIHUANA2",
          "TABACO2")

### Creo el contenedor 
contenedor =  data.frame(var1="H",var2="H" ,Ji = 0,G.l = 0,Pvalor = 0)
i = 1
j = 2

for(i in 1:length(varis)){
  for( j in 1:length(varis))
    if(i != j & i<j){
      #### Hacer el recorrido ####
      sujeto = contenedor[1,]
      ### Extraer los nombres
      sujeto[,1:2] = varis[c(i,j)]
      ### Hago la tabla chi
      tabla = table(datos[,varis[c(i,j)]])
      chicuad = chisq.test(tabla)
      ### Agregar al sujeto lo que falta
      sujeto[,3:5] = round(c(chicuad$statistic,
                       chicuad$parameter,
                       chicuad$p.value),6)
      ### Poner el sujeto en su lugar
      contenedor  = rbind.data.frame(contenedor,
                                     sujeto)

    }
}




library(xlsx)
write.xlsx(contenedor,
           "tablaschi1.xlsx",
           row.names = F)


#### Tablas de JI CUADRADO POR SEXO ####

# Hago el contenedor de variables
datos1$Sexo = datos$`¿Cuál es tu sexo?`

varis = c("edad2",
          "CAR...64",
          "TIC...66",
          "ALCOHOL...68",
          "MARIHUANA2",
          "TABACO2")

### Creo el contenedor 
contenedor =  data.frame(var1="H",var2="H" ,Ji = 0,G.l = 0,Pvalor = 0)

### Ciclo para la cosa ###
for(i in 1:length(varis)){
  #### Fijando la variable de sexo
  #### Hacer el recorrido ####
  sujeto = contenedor[1,]
  ### Extraer los nombres
  sujeto[,1:2] = c(varis[i],"Sexo")
  ### Hago la tabla chi
  # Variables
  vrb = c(varis[i],"Sexo")
  tabla = table(datos1[,vrb])
  chicuad = chisq.test(tabla)
  ### Agregar al sujeto lo que falta
  sujeto[,3:5] = round(c(chicuad$statistic,
                         chicuad$parameter,
                         chicuad$p.value),6)
  ### Poner el sujeto en su lugar
  contenedor  = rbind.data.frame(contenedor,
                                 sujeto)
  
}



contenedor$Pvalor1 = round(contenedor$Pvalor,2)




iris$Species  |> table()




