rm(list=ls())
# Librerias necesarias
library(factoextra)
library(cluster)
library(purrr)
library(ggplot2)

#### Cargar la base de datos ###
ruta = "Caracteristicas.csv"
datos = read.csv(ruta)
datos1 = datos[order(datos$imagen),]
datos1 = datos[-624,]

### Hacer el proceso de
# Metodo para decidir cuantos clusters se requieren
# Euclidiana
fviz_nbclust(x = datos1, FUNcluster = kmeans, method = "wss", k.max = 10, 
             diss = get_dist(datos, method = "euclidean"), nstart = 50)
## Silueta ##
#fviz_nbclust(x = datos1, FUNcluster = kmeans, method = "silhouette", k.max = 10, 
#             diss = get_dist(datos, method = "euclidean"), nstart = 50)

### Armar el cluster ###

#### Caso para 3 Clusters ####
# La gráfica reporta que entre 3 y 4 Clusters seria ideal
set.seed(64)
km_clusters =   kmeans(x = datos1[,-1], centers = 3, nstart = 50)
etiq<-km_clusters$cluster
etiq = as.factor(etiq)
datos2 = datos1
datos2$etiq = etiq 

fviz_cluster(object = km_clusters, data = datos2[,-c(1,514)],
             show.clust.cent = TRUE,  # Muestra los centros del clúster
             ellipse.type = "none",   # Deshabilita las elipses
             star.plot = FALSE,       # Deshabilita el gráfico de estrellas
             repel = F) +          # Mantiene la repulsión de etiquetas
  labs(title = "Resultados clustering K-means") +
  theme_bw() +
  theme(legend.position = "none")

### Quienes son del verde ####



#### Parte de Fuzzy C means ####
library(e1071)

# Realizar el Fuzzy C-means
wse = c()
i = 10
for(i in 2:11){
  fcm_resultado <- cmeans(x = datos1[,-1],
                          centers = i,
                          m = 2,           # Exponente de fuzzificación (valor común)
                          iter.max = 100, # Número máximo de iteraciones
                          dist = "euclidean")
  wse[i-1] = fcm_resultado$withinerror
}

plot(wse,pch = 16,type = "o")

#### C-Cluster 1 ####
#### C-Cluster 2 ####
fcm_resultado <- cmeans(x = datos1[,-1],
                        centers = 6,
                        m = 1.3,           # Exponente de fuzzificación (valor común)
                        iter.max = 100, # Número máximo de iteraciones
                        dist = "euclidean")
fcm_resultado$withinerror
fdatos = datos1

fviz_cluster(object = fcm_para_fviz,
             data = fdatos[,-1] ,
             show.clust.cent = TRUE,
             ellipse.type = "none",   # Quita las elipses
             star.plot = FALSE,       # Quita las estrellas
             repel = F)



fcm_para_fviz <- list(
  cluster = fcm_resultado$cluster,   # Las asignaciones "duras" de los clústeres
  centers = fcm_resultado$centers,   # Los centros de los clústeres
  size = fcm_resultado$size          # El tamaño de cada clúster (opcional, pero útil)
)

# 2. Asignar la clase "kmeans" a esta lista.
#    Esto engaña a fviz_cluster para que use su método para objetos kmeans.
class(fcm_para_fviz) <- "kmeans"

