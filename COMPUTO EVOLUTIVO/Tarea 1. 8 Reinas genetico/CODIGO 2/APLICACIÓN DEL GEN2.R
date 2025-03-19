rm(list=ls())
# Cargar la función del genetico #
source("GEN2 REV2 FUNCIONANDO.R")
#### Parámetros de inicio ####
pobsize = 100 # Tamaño de la población inicial
NP = 1 # Cantidad de parejas (1 pareja = 2 padres)
PC = 1 # Porcentaje de cruza
PM = 0.8 # Porcentaje de mutación
LIM = 10000 # Criterio de paro: Evaluaciones 10,000 o solución encontrada
A = reinas2(pobsize,NP,PC,PM,LIM)
K = nrow(A)
table(1:8,as.matrix(A[K,4:11]))




