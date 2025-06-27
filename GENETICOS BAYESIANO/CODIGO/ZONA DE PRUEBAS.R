rm(list=ls())
### Zona de pruebas ###
library(igraph)
# Ruta #
ruta =  "C:\\Users\\Angel\\Desktop\\GENETICOS BAYESIANO\\BASES DEPURADAS\\1IrisD.csv"
# datos #
datos = cate(read.csv(ruta))
X = datos
i = 1
# Generar una matriz de adyacencias random #
adj = adjmat(X)
aciclicidad(adj)
# Convertir matriz a grafo dirigido
g <- graph_from_adjacency_matrix(adj, mode = "directed")
plot(g, vertex.size = 30, edge.arrow.size = 0.5)

# Computar el MLD 
mdl(adj,X)

### Computar el MLD con bnlearn
dag <- empty.graph(nodes = names(X))
amat(dag) <- adj
# Score BIC (equivalente a MDL)
-score(dag, data = X, type = "bic") * log2(exp(1))

#### Segunda parte de pruebas con el genetico ####
# Ruta #
ruta =  "C:\\Users\\Angel\\Desktop\\GENETICOS BAYESIANO\\BASES DEPURADAS\\1IrisD.csv"
# datos #
datos = cate(read.csv(ruta))
X = datos
n = ncol(X)
n

sujeto(n)
