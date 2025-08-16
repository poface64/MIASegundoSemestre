rm(list=ls())
# Librerias necesarias
library(factoextra)
library(cluster)
library(purrr)
library(ggplot2)

#### Cargar la base de datos ###
ruta = "Caracteristicas2.csv"
datos = read.csv(ruta)
set.seed(1234)
datos1 = datos[sample(1:nrow(datos),800),]
datos1 = datos1[order(datos1$imagen),]
datos1 = datos1[,-1]
#row.names(datos1) = 1:nrow(datos1)
datos1 = datos1[-c(596),]
#######################################################

#### Cluster K-means tradicional ####

### Determinar el número optimo de clusters ###
# Gráfico de codos de Janbu-Distancia Euclidiana #
G1 = fviz_nbclust(x = datos1, FUNcluster = kmeans, method = "wss", k.max = 10, 
             diss = get_dist(datos1, method = "euclidean"), nstart = 50)
Z1 = G1 +
  ggtitle("Número optimo de Clusters K-means") +
  labs(x = "Número de Clusters",
       y = "Intravarianza")

ggsave("R1.png",Z1,dpi = 400)

### Gráfico de la silueta ###
#G2 = fviz_nbclust(x = datos1, FUNcluster = kmeans, method = "silhouette", k.max = 10, 
#             diss = get_dist(datos1, method = "euclidean"), nstart = 50)

### Armar el cluster Kmeans ###
#### Caso para 3 Clusters ####
# La gráfica reporta que entre 3 y 4 Clusters seria ideal
set.seed(64)
km_clusters = kmeans(x = datos1, centers = 3, nstart = 50)
etiq<-km_clusters$cluster
etiq = as.factor(etiq)
datos2 = datos1
datos2$etiq = etiq 
R2 = fviz_cluster(object = km_clusters, data = datos2[,-c(513)],
             show.clust.cent = TRUE,  # Muestra los centros del clúster
             ellipse.type = "none",   # Deshabilita las elipses
             star.plot = FALSE,       # Deshabilita el gráfico de estrellas
             repel = F) +          # Mantiene la repulsión de etiquetas
  labs(title = "Resultados clustering K-means") +
  theme_bw() +
  theme(legend.position = "none")

ggsave("R2.svg", R2, 
       width = 6, height = 6,
       dpi = 4000)
sv = rsvg("R2.svg",
          height = 600,
          width = 600)
### Exportar en jpeg
writeJPEG(sv, "R2.jpg", quality = 20)


#### Parte de Fuzzy C means ####
library(e1071)

#### Calcular la intra varianza ####
wse = c()
for(i in 2:11){
  fcm_resultado <- cmeans(x = datos1,
                          centers = i,
                          m = 2,           # Exponente de fuzzificación (valor común)
                          iter.max = 100, # Número máximo de iteraciones
                          dist = "euclidean")
  wse[i-1] = fcm_resultado$withinerror
}
plot(wse,type = "o")



#### Cluster para el fuzzy Cmeans ####
fcm_resultado <- cmeans(x = datos1,
                        centers = 3,
                        m = 1.9,           # Exponente de fuzzificación (valor común)
                        iter.max = 1000, # Número máximo de iteraciones
                        dist = "euclidean")

table(fcm_resultado$cluster )

datos1[fcm_resultado$cluster==4,1:3] 

fcm_resultado$membership

#### Objeto provisional para el clustering ####
fcm_para_fviz <- list(
  cluster = fcm_resultado$cluster,   # Las asignaciones "duras" de los clústeres
  centers = fcm_resultado$centers,   # Los centros de los clústeres
  size = fcm_resultado$size          # El tamaño de cada clúster (opcional, pero útil)
)
class(fcm_para_fviz) <- "kmeans"

### Gráficar el Cluster ###
R3 = fviz_cluster(object = fcm_para_fviz, data = datos1,
             show.clust.cent = TRUE,  # Muestra los centros del clúster
             ellipse.type = "none",   # Deshabilita las elipses
             star.plot = FALSE,       # Deshabilita el gráfico de estrellas
             repel = F) +          # Mantiene la repulsión de etiquetas
  labs(title = "Resultados clustering Fuzzy C-means") +
  theme_bw() +
  theme(legend.position = "none")


ggsave("R3.svg", R3, 
       width = 6, height = 6,
       dpi = 4000)
sv = rsvg("R3.svg",
          height = 600,
          width = 600)
### Exportar en jpeg
writeJPEG(sv, "R3.jpg", quality = 20)

library(rsvg)
library(svglite)
library(jpeg)

### Comparar las intravarianzas ##


#### Intravarianza ####

## Intravarianza Fuzzy ##
fcm_resultado$withinerror
table(fcm_resultado$cluster)

## Intravarianza K-Means ##
km_clusters$totss
table(km_clusters$cluster)




sum(km_clusters$totss)
sum(km_clusters$withinss)








