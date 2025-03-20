rm(list = ls())
# Cargar el codigo fuente #
source("GEN1.R")
#### Parámetros de inicio ####
pobsize = 100 # Tamaño de la población inicial
NP =0.5 # Cantidad de parejas (1 pareja = 2 padres)
PC = 0.5 # Porcentaje de cruza
PM = 0.3 # Porcentaje de mutación
LIM = 10000 # Criterio de paro: Evaluaciones 10,000 o solución encontrada

reinas(pobsize,NP,PC,PM,LIM)


# No converge #
resu = data.frame(Gen = 0,APT = 0, Eval = 0)
MS = list()

#Hacer las 30 iteraciones#
for(i in 1:30){
  AZ = reinas(pobsize,NP,PC,PM,LIM)
  AZ1 = AZ[[1]]
  resu[i,] = AZ1[nrow(AZ1),]
  # Guarda tambien la lista de mejores sujetos
  MS[[i]] = AZ[[2]]
}

# Separar al mejor sujeto y hacerlo tablero
ms = MS[[which.min(resu$APT)[1]]]
#write.csv(resu,"resualgo1.csv",row.names = F)
#write.csv(ms,"sujeto1.csv",row.names = F)

# Volver a cargar los datos para hacer estadísticas
resu = read.csv("resualgo1.csv")
ms = read.csv("sujeto1.csv")
table(factor(ms[,1],1:8),factor(ms[,2],1:8) )

#### Resultados para el algoritmo 1 ####
# Estadísticas #
estadisticas <- function(df){
  exitosas <- df[df[,2] == 0, "Eva"]  # Casos donde encontró solución
  no_exitosas <- df[df[,2] > 0, "APT"]  # Casos donde no encontró solución
  #### Contabilizar llos casos exitosos ####
  exitos = if (length(exitosas) > 0) {
    c(min(exitosas), mean(exitosas), median(exitosas), sd(exitosas), max(exitosas))
  } else {
    rep(NA, 5)
  }
  #### No exitoso ####
  noexitosas <- if (length(no_exitosas) > 0) {
    c(min(no_exitosas), mean(no_exitosas), median(no_exitosas), sd(no_exitosas), max(no_exitosas))
  } else {
    rep(NA, 5)
  }
  # Devolver una lista ordenada con
  return(list(
    exitosas = exitos,
    no_exitosas = noexitosas,
    num_exitosas = length(exitosas),
    num_no_exitosas = length(no_exitosas)
  ))
}
estadisticas(resu)

#######################





#### Para gráficar ####

#### Valores del APT ####
lista_resultados = vector("list", 30)
# Realizar 30 ejecuciones y guardar el historial completo de cada una

for(ij in 1:30){
  AZ1 = reinas(pobsize, NP, PC, PM, LIM)  # Suponiendo que reinas2 devuelve un dataframe con Gen, Apt, Eval.
  lista_resultados[[ij]] = AZ1[[1]]  # Guardar el historial completo de cada ejecución
}
# Crear un dataframe resumen con los últimos valores de cada ejecución
resu = data.frame(
  id = 1:30, 
  Apt_final = sapply(lista_resultados, function(df) df$APT[nrow(df)])
)
# Ordenar las ejecuciones por Apt_final y seleccionar la mediana
library(dplyr)
library(ggplot2)
resu_ordenado = resu %>% arrange(Apt_final)
id_mediana = resu_ordenado$id[15]  # Seleccionamos la ejecución en la posición 15
# Extraer el dataframe correspondiente a la ejecución mediana
df_mediana = lista_resultados[[id_mediana]]
# Graficar la convergencia (Aptitud vs Generación)
M1 = ggplot(df_mediana, aes(x = Gen, y = APT)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red") +
  labs(title = "Gráfica de Convergencia - Ejecución Mediana",
       x = "Generación",
       y = "Mejor Aptitud") +
  theme_classic()

### Exportar ###
library(rsvg)
library(jpeg)
ggsave("M2.svg", M1, 
       width = 5, height = 5,
       dpi = 1000)
sv = rsvg("M2.svg",
          height = 700,
          width = 700)
### Exportar en jpeg
writeJPEG(sv, "M2.jpg", quality = 12)



