rm(list=ls())

#### Explorar el MCA ####
ruta1 = "cristilimpiosCAT.csv"
mini = read.csv(ruta1)
table(mini$Edad)


#### Crear una copia del objeto ####
D1 = mini

#### Volver ordinales las cosas ###
# 1.- Sin Riesgo, #2.- Riesgo Moderado #3.- Riesgo Alto
D1$CAR = factor(mini$CAR,levels = rev(c("Riesgo alto", "Riesgo moderado","Sin riesgo")))  |> as.numeric()

# 1.-Inexistencia de pproblema  2.-Uso problematico 3.- Abuso y 4.- Dependencia
D1$TIC = as.numeric(factor(mini$TIC, levels =  c("Inexistencia de problema",
                                                 "Uso problemático","Abuso",
                                                 "Dependencia"))) |> as.numeric()


# 4.- Adicción 3.- Riesgo alto 2.- Medio 1.- Riesgo bajo
D1$ALCOHOL = factor(mini$ALCOHOL, levels = c("Riesgo bajo","Riesgo medio",
                                             "Riesgo alto","Adicción")) |> as.numeric()

# 1.-Riesgo Bajo, 2 Riesgo medio, 3 riesgo alto
D1$MARIHUANA = factor(mini$MARIHUANA, levels = c("Riesgo bajo",
                                                 "Riesgo medio",
                                                 "Riesgo alto")) |> as.numeric()

# 1.-Riesgo Bajo, 2 Riesgo medio, 3 riesgo alto
D1$TABACO = factor(mini$TABACO, levels = c("Dependencia baja",
                                           "Dependencia moderada",
                                           "Dependencia alta")) |> as.numeric()




#### Armar las correlaciones ####

A = as.data.frame(round(cor(D1[,4:8],method = "spearman"),2))
# Calcular la matriz de valores P
SPr = matrix(2,nrow = 5,ncol = 5)
mn = D1[,4:8]
#cor.test(mn[,1],mn[,2] ,method = "spearman")
Z = matrix("Z",nrow = 5,ncol = 5)
for(i in 1:ncol(mn)){
  for(j in 1:ncol(mn)){
    # Armar la matriz de coeficientes
      # Sacar la matriz de corr
      resu = cor.test(mn[,i],mn[,j] ,method = "spearman")
      SPr[i,j] =  round(resu$p.value,3)
  }
}

for(i in 1:5){
  Z[,i]  = paste0(A[i,] ," (",SPr[i,],")")
}

write.csv(Z,"CORspear.csv")

##### Tau de Kendall ####
A = as.data.frame(round(cor(D1[,4:8],method = "kendall"),2))
# Calcular la matriz de valores P
SPr = matrix(2,nrow = 5,ncol = 5)
mn = D1[,4:8]
#cor.test(mn[,1],mn[,2] ,method = "spearman")
Z = matrix("Z",nrow = 5,ncol = 5)
for(i in 1:ncol(mn)){
  for(j in 1:ncol(mn)){
    # Armar la matriz de coeficientes
    # Sacar la matriz de corr
    resu = cor.test(mn[,i],mn[,j] ,method = "kendall")
    SPr[i,j] =  round(resu$p.value,2)
  }
}

for(i in 1:5){
  Z[,i]  = paste0(A[i,] ," (",SPr[i,],")")
}


write.csv(Z,"CORkendallr.csv")

#### RE-EXPLORAR LOS DATOS Y ACM ####
#### Explorar el MCA ####
ruta1 = "cristilimpiosCAT.csv"
mini = read.csv(ruta1)
table(mini$Edad)
#### Crear una copia del objeto ####
D1 = mini
#### Volver ordinales las cosas ###
# 1.- Sin Riesgo, #2.- Riesgo Moderado #3.- Riesgo Alto
D1$CAR = factor(mini$CAR,levels = rev(c("Riesgo alto", "Riesgo moderado","Sin riesgo"))) 
# 1.-Inexistencia de pproblema  2.-Uso problematico 3.- Abuso y 4.- Dependencia
D1$TIC = as.numeric(factor(mini$TIC, levels =  c("Inexistencia de problema",
                                                 "Uso problemático","Abuso",
                                                 "Dependencia")))
# 4.- Adicción 3.- Riesgo alto 2.- Medio 1.- Riesgo bajo
D1$ALCOHOL = factor(mini$ALCOHOL, levels = c("Riesgo bajo","Riesgo medio",
                                             "Riesgo alto","Adicción"))
# 1.-Riesgo Bajo, 2 Riesgo medio, 3 riesgo alto
D1$MARIHUANA = factor(mini$MARIHUANA, levels = c("Riesgo bajo",
                                                 "Riesgo medio",
                                                 "Riesgo alto")) 
# 1.-Riesgo Bajo, 2 Riesgo medio, 3 riesgo alto
D1$TABACO = factor(mini$TABACO, levels = c("Dependencia baja",
                                           "Dependencia moderada",
                                           "Dependencia alta"))

### Explorar los MCA con todas las variables ####
library(FactoMineR)
library(factoextra)
#P1 = D1
names(D1)
#P1 = D1[,c(2,4,5,6)];P1$TIC = factor(mini$TIC, levels =  c("Inexistencia de problema",
#                                                                      "Uso problemático","Abuso",
#                                                                      "Dependencia"))
P1 = D1

ACM = MCA(P1[,-5],graph = F)# Gráfico de sedimentos con etiquetas
#ACM = MCA(P1,graph = F)# Gráfico de sedimentos con etiquetas
fviz_screeplot(ACM, addlabels = TRUE)
fviz_contrib(ACM, choice ="var", axes = 1,top = 100)+
  ggtitle("Contribución de las variables a la dimensión 1")
fviz_screeplot(ACM, addlabels = TRUE)


# Gráfico biplot
fviz_mca_biplot(ACM,label = "var",select.var = list(contrib = 15),
                #select.ind = list(contrib = 600),
                col.var = "#18529D",
                col.ind = "#28AD56",
                labelsize = 3,
                pointsize = 1,
                xlim = c(-1,6),
                addEllipses = T)



### Revisar el kmeans
library(factoextra)
library(NbClust)
pru = ACM$ind$coord
#Grafico de codo de Janbu
fviz_nbclust(pru, kmeans, method = "wss")
fviz_nbclust(pru, kmeans, method = "silhouette")

# Hacer el cluster
#DECIDIMOS QUE NOS QUEDAMOS CON 2
clus1 <- kmeans(pru,
                centers = 5)
k1 = clus1$cluster

#GRAFICAMOS LOS CLUSTERS
#Grafico cluster de poligono
fviz_cluster(clus1, data = pru) +
  theme_bw()

######

fviz_mca_biplot(ACM,label = "var",
                labelsize = 3,
                pointsize = 1,
                xlim = c(-2,4),
                col.ind = as.factor(k1),
                addEllipses = T)

#### TABLA DE CHIS CUADRADAS #####

# Hago el contenedor de variables

P1$TABACO =  as.factor(as.character(P1$TABACO))
varis = names(P1)[-4]

### Creo el contenedor 
contenedor =  data.frame(var1="H",var2="H" ,Ji = 0,G.l = 0,Pvalor = 0)

### Ciclo para la cosa ###
for(i in 1:length(varis)){
  #### Fijando la variable de sexo
  #### Hacer el recorrido ####
  sujeto = contenedor[1,]
  ### Extraer los nombres
  sujeto[,1:2] = c(varis[i],"CAR")
  ### Hago la tabla chi
  # Variables
  vrb = c(varis[i],"CAR")
  tabla = table(P1[,vrb])
  chicuad = chisq.test(tabla)
  ### Agregar al sujeto lo que falta
  sujeto[,3:5] = round(c(chicuad$statistic,
                         chicuad$parameter,
                         chicuad$p.value),6)
  ### Poner el sujeto en su lugar
  contenedor  = rbind.data.frame(contenedor,
                                 sujeto)
}

contenedor[contenedor$Pvalor<0.05 ,]

table(P1$Edad,P1$CAR) |> chisq.test()

table(P1$Sexo,P1$CAR) 
table(P1$TIC,P1$CAR) 


