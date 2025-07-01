rm(list=ls())

##### Resultados de oro ####
### Cargar toda mi libreria con el genetico ####
source("BNSL.R")
library(igraph)
library(bnlearn)

#### Cargar la carpeta de bases ####
rutas = c("GOLD STANDAR/survey.rda",
          "GOLD STANDAR/asia.rda",
          "GOLD STANDAR/child.rda",
          "GOLD STANDAR/earthquake.rda",
          "GOLD STANDAR/sachs.rda",
          "GOLD STANDAR/insurance.rda",
          "GOLD STANDAR/cancer.rda")



### Definir los parametros ####
##### Exploración de las redes de oro ####
# Defino mis parametros
ngen = 50 # Numero de generaciones
pobsize = 30 # Tamaño de la población
pe = 0.2 # porcentaje de elitismo
pm = 0.2 # porcentaje de muta
rho = 0.7 # Probabilidad de escoger un cromosoma elite o no
umbral = 0.5 # Decision para desfuzificar
verbose = T # Ir mostrando en pantalla el registro

#### Va a ocurrir otra vez el asunto ####
i = 1
# Resultados oro ##3
reso = data.frame(KL = 0,SDH = 0 )

for(i in 1:length(rutas)){
  #### Cargar la red de oro ####
  print(rutas[i])
  load(rutas[i])
  #### Gráficar la red y obtener sus datos ####
  set.seed(12) # Obtener mil instancias
  data = rbn(bn, 1000)
  #### Calcular la red con mi algoritmo ###
  resultado = algoritmo_genetico(data, ngen , pobsize ,
                                 pe , pm , 
                                 rho , umbral, verbose = TRUE) 
  ### Gráfico de Convergencia ###
  png(paste0(i,"gc.png") , width = 800, height = 600, res = 100)
  plot(sapply(resultado$historial, function(x) x$fitness),
       type = "l", ylab = "Fitness (MDL)", xlab = "Generación")
  dev.off()
  #### Gráfico de la red obtenida ####
  png(paste0(i,"gr.png") , width = 800, height = 600, res = 100)
  g = graph_from_adjacency_matrix(resultado$mejor$adj, mode = "directed")
  # 3. Plot your graph to the opened device
  plot(g, vertex.size = 30, edge.arrow.size = 0.5)
  dev.off()
  #### Convertir la matriz a un objeto bn
  mejor_adj = resultado$mejor$adj
  bn_estructura <- empty.graph(nodes = colnames(mejor_adj))
  amat(bn_estructura) <- mejor_adj
  #### Aprender la red usando la matriz de adyacencias y bnlearn #
  bn_entrenada = bn.fit(bn_estructura, data, method = "mle")
  #### Diferencia con grados de libertad de la red de oro.
  loro = logLik(bn, data  )
  lentrenada = logLik(bn_entrenada, data  )
  ### Hacer el calculo con ayuda de BN learn ###
  reporte = KL(bn_entrenada, bn)
  ### Distancia de Hamming ###
  bn_estructura # La aprendida 
  bn_oro = bn.net(bn) # La de oro
  dife = shd(bn_oro, bn_estructura)
  ### Guardar los resultados ###
  reso[i,] = c(reporte,dife)
  print(reporte)
}

### Exportar los resultados
res0 = cbind.data.frame(reso,rutas)
res0

### Exportar los resultados
write.csv(res0,"Resultadosoro.csv",row.names = F)







