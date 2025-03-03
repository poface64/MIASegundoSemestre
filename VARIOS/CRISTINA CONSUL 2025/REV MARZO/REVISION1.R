rm(list=ls())
# Pasar los datos a limpio #
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

########## Revisar los minis  y los datos modificados ####
#write.csv(mini,"cristilimpiosCAT.csv",row.names = F)
#write.csv(mini2,"cristilimpiosNUM.csv",row.names = F)

#### Explorar el MCA ####
ruta1 = "cristilimpiosCAT.csv"
mini = read.csv(ruta1)


#### sexo, edad, CAR, TICS consumos ###
# Para hacer el correspondencias MULTIPLES
P1 = mini[,c(2,1,4,5,6,7,8)]
names(P1)

### Explorar los MCA con todas las variables ####
library(FactoMineR)
library(factoextra)
ACM = MCA(P1,graph = T)
# Gráfico de sedimentos con etiquetas
fviz_screeplot(ACM, addlabels = TRUE)

# Gráfico biplot
fviz_mca_biplot(ACM) 

### Exploración sin ninguna etiqueta
fviz_mca_biplot(ACM, label = "none")

### Exploración sin las etiquetas azules ###
fviz_mca_biplot(ACM, 
                label = "var",  # Muestra solo las etiquetas de las variables
                repel = TRUE)   # Evita que las etiquetas se sobrepongan

#### SEPARAR A LOS 3 SUJETOS DE HASTA ARRIBA 116,115 Y 203
ACM1 = MCA(P1[-c(115,116,203),],graph = T)
fviz_mca_biplot(ACM1, 
                label = "var",
                repel = T)   # Evita que las etiquetas se sobrepongan


#### Separar a otros 3 sujetos c(641,371,159,708) ####
ACM2 = MCA(P1[-c(115,116,203,
                 641,371,159,708),],graph = T)
fviz_mca_biplot(ACM2, 
                label = "var",  # Muestra solo las etiquetas de las variables
                repel =T)   # Evita que las etiquetas se sobrepongan

# Marihuana-CAR
# Alcohol-car
# CAR-TICS
-c(115,116,203,
   641,371,159,708)

ACM3 = MCA(P1[-c(115,203),c("MARIHUANA","CAR","TIC","ALCOHOL") ],graph = T)
fviz_mca_biplot(ACM3, 
                label = "var",
                repel =F)   # Evita que las etiquetas se sobrepongan

#### Extraer a los sujetos ####
ACM3C = ACM3$ind$coord
ACM3C[ACM3C[,1]>=4 & ACM3C[,2]>=1.5, ]


#### Exploración de Ecuaciones estructurales ####
library(lavaan)
library(semPlot)
ruta2 = "cristilimpiosNUM.csv"
mini2 = read.csv(ruta2)

names(mini2)
#### Posible variable latente ####

#Estilo de Vida = CAR, TIC, ALCOHOL (relaciones causales).
# Modelo de ecuaciones estructurales con una variable latente
modelo <- '
  # Parte estructural
  EstiloDeVida =~ CAR + TIC + ALCOHOL # La variable latente EstiloDeVida está influenciada por CAR, TIC y ALCOHOL
  # Parte de medición (opcional en este caso ya que tenemos solo observadas)
  # (Aquí no hay variables latentes adicionales, pero puedes agregar si lo deseas)'

# Ajuste del modelo de ecuaciones estructurales
ajuste <- sem(modelo, data = mini2, ordered = c("CAR", "TIC","ALCOHOL"))

# Resumen de los resultados
summary(ajuste, fit.measures = TRUE)
semPaths(ajuste, 
         what = "est",          
         whatLabels = "est",    
         edge.label.cex = 0.8,  
         edge.color = "blue",   
         node.color = "lightblue",  # Color de los nodos
         node.width = 1.5,      # Ancho de los nodos
         fade = FALSE,
         sizeMan = 10,          # Tamaño de las variables observadas
         sizeLat = 15)          # Tamaño de las variables latentes

8.5 + 7.9


