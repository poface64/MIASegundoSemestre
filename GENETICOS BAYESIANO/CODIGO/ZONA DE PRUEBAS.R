rm(list=ls())
### Zona de pruebas ###
library(igraph)
# Ruta #
ruta =  "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\GENETICOS BAYESIANO\\BASES DEPURADAS\\1IrisD.csv"
# datos #
datos = cate(read.csv(ruta))
X = datos
i = 1
# Generar una matriz de adyacencias random #
adj = adjmat(X)
aciclicidad(adj)

# Convertir matriz a grafo dirigido
g = graph_from_adjacency_matrix(mejor_global$adj, mode = "directed")
plot(g, vertex.size = 30, edge.arrow.size = 0.5)

# Computar el MLD 
mdl(adj,X)

### Computar el MLD con bnlearn
dag = empty.graph(nodes = names(X))
amat(dag) = adj
# Score BIC (equivalente a MDL)
-score(dag, data = X, type = "bic") * log2(exp(1))

#### Segunda parte de pruebas con el genetico ####
# Ruta #
ruta =  "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\GENETICOS BAYESIANO\\BASES DEPURADAS\\1IrisD.csv"
# datos #
datos = cate(read.csv(ruta))
X = datos
n = ncol(X)
n
# Agregar el pobsize de una #
pobsize = 10
sujeto(n)
pob(n,pobsize)

#### Probar hasta aqui el genetico 
X = datos
data = X
# Parametros del genetico
## Aplica elitismo 
n = ncol(X)
pobsize = 50
pmut = 0.2
phijos = 0.6
pe = 0.2

# Generar la población inicial
poblacion = pob(n,pobsize)

# Evaluar a la población inicial
evaluados = evaluarpob(poblacion,X)

# Aplicar aquí la selección por elitismo #
selecionados = seleccion(evaluados,pe)

# Mutantes (20% de la población original)
mutantes = mutantes(cantidad = 2, n = 5)

#### Zona de pruebas ####
# Primera generación (evaluada)
p0 = pob(5, 10)
p0_eval = evaluarpob(p0, data)
# Crear la nueva generación (sin evaluar aún)
gen1 = nuevapob(p0_eval, n = 5, tamano_total = 10)
# Luego: evalúas gen1
gen1_eval = evaluarpob(lapply(gen1, `[[`, "vector"), data)

#### Implementación del bucle de trabajo ####
ruta =  "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\GENETICOS BAYESIANO\\BASES DEPURADAS\\10Zoo.csv"
# datos #
datos = cate(read.csv(ruta))
X = datos
data = X # Datos de entrada categoricos
ngen = 50 # Numero de generaciones
pobsize = 20 # Tamaño de la población
pe = 0.2 # porcentaje de elitismo
pm = 0.2 # porcentaje de muta
rho = 0.7 # Probabilidad de escoger un cromosoma elite o no
umbral = 0.5 # Decision para desfuzificar
verbose = T # Ir mostrando en pantalla el registro
alpha = 100000
###
# Generar sujeto
#suj = sujeto(ncol(X))
# Decodificarlo y revisar si hay ciclo
#adj = decodificar(suj)
#g = graph_from_adjacency_matrix(adj, mode = "directed")
#plot(g, vertex.size = 30, edge.arrow.size = 0.5)
#detectar_ciclo(adj)  # Debe devolver FALSE

# Ciclo del genetico #
resultado = algoritmo_genetico(data, ngen , pobsize ,
                               pe , pm , 
                               rho , umbral, verbose = TRUE) 
#g = graph_from_adjacency_matrix(adj, mode = "directed")
g = graph_from_adjacency_matrix(resultado$mejor$adj, mode = "directed")
resultado$mejor$fitness
?graph_from_adjacency_matrix

plot(g, vertex.size = 30, edge.arrow.size = 0.5)
plot(sapply(resultado$historial, function(x) x$fitness), type = "l", ylab = "Fitness (MDL)", xlab = "Generación")



resultado$mejor$adj

###########
library(bnlearn)
# Convertir la matriz a un objeto bn
vars <- colnames(data)
dag <- empty.graph(nodes = vars)
amat(dag) <- resultado$mejor$adj


#### Aprender los parametros con bnlearn ####
mejor_adj = resultado$mejor$adj
bn_estructura <- empty.graph(nodes = colnames(mejor_adj))
amat(bn_estructura) <- mejor_adj
# Aprender
bn_entrenada <- bn.fit(bn_estructura, data, method = "bayes")  # puedes usar "mle" o "bayes"

###  Clasificar ####
nuevos_datos = X[,-ncol(X)]
# Predecir Class
predicciones <- predict(bn_entrenada, node = "class", data = nuevos_datos, method = "bayes-lw")
### Hacer la matriz de confusión ###
table(real = X$class,
      Pred = predicciones)
predicciones



###
bn_pc <- pc.stable(datos, alpha = 0.05)
print(bn_pc)
plot(bn_pc)
