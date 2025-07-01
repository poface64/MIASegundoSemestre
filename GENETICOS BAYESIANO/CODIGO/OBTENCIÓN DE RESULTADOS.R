rm(list=ls())
### Cargar toda mi libreria con el genetico ####
source("BNSL.R")
library(igraph)
library(bnlearn)

#### Cargar la carpeta de bases ####
rutas =  list.files(path = "bases/", full.names = TRUE, recursive = TRUE)[c(2:10,1)]
i = 1

# Guardar los resultados #
resultados = data.frame(Base = 0,MDL = 0, Precision = 0,Tiempo = 0)
set.seed(27)
#### Definir el flujo de trabajo ####
for(i in 1:length(rutas)){
  ## Cargar la primera base ##
  datos = cate(read.csv(rutas[i]))
  # Decirle que la ultima variable se llama class
  names(datos)[ncol(datos)] = "Class"
  ## Separar en prueba y entrenamiento ##
  np = nrow(datos)
  tn = round(nrow(datos)*0.8)
  tt = np-tn
  ## Datasets ##
  indices = sort(sample(1:np,tn))
  train = datos[indices,]
  test = datos[-indices,]
  ## Llamar al algoritmo para que haga la red ##
  # Defino mis parametros
  data = train # Datos de entrada categoricos
  ngen = 50 # Numero de generaciones
  pobsize = 30 # Tamaño de la población
  pe = 0.2 # porcentaje de elitismo
  pm = 0.2 # porcentaje de muta
  rho = 0.7 # Probabilidad de escoger un cromosoma elite o no
  umbral = 0.5 # Decision para desfuzificar
  verbose = T # Ir mostrando en pantalla el registro
  # Entrenar la red con el dataset de train
  # Medir el tiempo #
  t <- proc.time() # Inicia el cronómetro
  # Proceso del genetico #
  resultado = algoritmo_genetico(data, ngen , pobsize ,
                                 pe , pm , 
                                 rho , umbral, verbose = TRUE) 
  # Terminar de medir el proceso
  tiempo = proc.time()-t    # Detiene el cronómetro
  
  # 1. Define the filename and dimensions
  png(paste0(i,"RED.png") , width = 800, height = 600, res = 100) # You can adjust width, height, and resolution (res)
  # 2. Recreate your graph object (assuming 'resultado' is available)
  g = graph_from_adjacency_matrix(resultado$mejor$adj, mode = "directed")
  # 3. Plot your graph to the opened device
  plot(g, vertex.size = 30, edge.arrow.size = 0.5)
  # 4. Close the graphics device
  dev.off()
  # Gráfico de convergencia #
  # 1. Define the filename and dimensions
  png(paste0(i,"Convergencia.png") , width = 800, height = 600, res = 100) # You can adjust width, height, and resolution (res)
  # 2.- Lanzo el gráfico
  plot(sapply(resultado$historial, function(x) x$fitness), type = "l", ylab = "Fitness (MDL)", xlab = "Generación")
  # Lo mando a renderizar al backend
  dev.off()
  
  #### Aprender los pesos con bnlearn ####
  # Convertir la matriz a un objeto bn
  mejor_adj = resultado$mejor$adj
  bn_estructura <- empty.graph(nodes = colnames(mejor_adj))
  amat(bn_estructura) <- mejor_adj
  #### Aprender los parametros con bnlearn ####
  # Aprender #
  bn_entrenada = bn.fit(bn_estructura, train, method = "mle")
  ###  Clasificar ####
  nuevos_datos = test[,-ncol(test)]
  # Predecir Class
  predicciones <- predict(bn_entrenada, node = "Class",
                          data = nuevos_datos, method = "bayes-lw")
  ### Hacer la matriz de confusión ###
  confusion = table(Real = test$Class,
                    Prediccion = predicciones )
  # Precision
  pres = round(100*sum(diag(confusion))/sum(confusion),1)
  # Guardar el precisión #
  resultados[i,] = c(i, resultado$mejor$fitness,pres,tiempo)
}

resultados
# Escribir el dataframe con los resultados #
write.csv(resultados,"Metricas.csv",row.names = F)


##### Exploración de las redes de oro ####
# Defino mis parametros
data = train # Datos de entrada categoricos
ngen = 50 # Numero de generaciones
pobsize = 30 # Tamaño de la población
pe = 0.2 # porcentaje de elitismo
pm = 0.2 # porcentaje de muta
rho = 0.7 # Probabilidad de escoger un cromosoma elite o no
umbral = 0.5 # Decision para desfuzificar
verbose = T # Ir mostrando en pantalla el registro
### Red survey	6 nodos
load("C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\GENETICOS BAYESIANO\\CODIGO\\GOLD STANDAR\\survey.rda")
# Checar la bn
bn1 = bn
set.seed(27)
data1 = rbn(bn1, 1000)
# Proceso del genetico #
data1 =  cate(read.csv(rutas[i]))
resultado = algoritmo_genetico(data1, ngen , pobsize ,
                               pe , pm , 
                               rho , umbral, verbose = TRUE) 
# Convergencia #
plot(sapply(resultado$historial, function(x) x$fitness), type = "l", ylab = "Fitness (MDL)", xlab = "Generación")
# Forma de la red #
# 2. Recreate your graph object (assuming 'resultado' is available)
g = graph_from_adjacency_matrix(resultado$mejor$adj, mode = "directed")
# 3. Plot your graph to the opened device
plot(g, vertex.size = 30, edge.arrow.size = 0.5)

#### Probar mi algoritmo genetico ####


### Red Asia, 8 nodos 
### Red child	20 nodos

?asia

# create and plot the network structure.
dag = model2network("[A][S][T|A][L|S][B|S][D|B:E][E|T:L][X|E]")

# Simular datos desde la estructura (estructura + CPTs aleatorios)
set.seed(123)
datos <- rbn(asia, n = 1000)

# Ajustar parámetros (CPTs) desde esos datos simulados
fit_oro <- bn.fit(asia, data = datos, method = "bayes")  # o method = "mle"


