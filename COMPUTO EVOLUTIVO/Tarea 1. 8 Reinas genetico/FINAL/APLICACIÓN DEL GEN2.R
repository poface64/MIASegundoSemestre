rm(list=ls())
# Cargar la función del genetico #
source("GEN2 REV2 FUNCIONANDO.R")
#### Parámetros de inicio ####
pobsize = 100 # Tamaño de la población inicial
NP = 1 # Cantidad de parejas (1 pareja = 2 padres)
PC = 1 # Porcentaje de cruza
PM = 0.8 # Porcentaje de mutación
LIM = 10000 # Criterio de paro: Evaluaciones 10,000 o solución encontrada
reinas2(pobsize,NP,PC,PM,LIM)

### Si converge ###
resu = data.frame(Gen = 0,APT = 0, Eval = 0, R1= 0,R2= 0,
                  R3= 0,R4= 0,R5= 0,R6= 0,R7= 0,R8= 0)
# Guardar los resultados #
#Hacer las 30 iteraciones#

for(i in 1:30){
  AZ1 = reinas2(pobsize,NP,PC,PM,LIM)
  resu[i,] = AZ1[nrow(AZ1),]
}
# Representar al mejor sujeto
write.csv(resu,"resualgo2.csv",row.names = F)
# Cargar los datos 
resu = read.csv("resualgo2.csv")
mj = as.vector(as.matrix(resu[which.min(resu$Eval),4:11]))
APTataques(mj)
table(1:8,as.matrix(mj))

#### Resultados para el algoritmo 2 ####
# Estadísticas #
estadisticas = function(df){
  exitosas = df[df[,2] == 0, "Eval"]  # Casos donde encontró solución
  no_exitosas = df[df[,2] > 0, "APT"]  # Casos donde no encontró solución
  #### Contabilizar llos casos exitosos ####
  exitos = if (length(exitosas) > 0) {
    c(min(exitosas), mean(exitosas), median(exitosas), sd(exitosas), max(exitosas))
  } else {
    rep(NA, 5)
  }
  #### No exitoso ####
  noexitosas = if (length(no_exitosas) > 0) {
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
resultados = estadisticas(resu)

#### Para gráficar ####

#### Valores del APT ####
lista_resultados = vector("list", 30)
# Realizar 30 ejecuciones y guardar el historial completo de cada una
for(i in 1:30){
  AZ1 = reinas2(pobsize, NP, PC, PM, LIM)  # Suponiendo que reinas2 devuelve un dataframe con Gen, Apt, Eval.
  lista_resultados[[i]] = AZ1  # Guardar el historial completo de cada ejecución
}
# Crear un dataframe resumen con los últimos valores de cada ejecución
resu = data.frame(
  id = 1:30, 
  Apt_final = sapply(lista_resultados, function(df) df$APT[nrow(df)])
)
# Ordenar las ejecuciones por Apt_final y seleccionar la mediana
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
ggsave("M1.svg", M1, 
       width = 5, height = 5,
       dpi = 1000)
sv = rsvg("M1.svg",
          height = 700,
          width = 700)
### Exportar en jpeg
writeJPEG(sv, "M1.jpg", quality = 12)




#### Resultados del eval ####
# Crear un dataframe resumen con los últimos valores de cada ejecución
resu = data.frame(
  id = 1:30, 
  Apt_final = sapply(lista_resultados, function(df) df$Eval[nrow(df)])
)
# Ordenar las ejecuciones por Apt_final y seleccionar la mediana
resu_ordenado = resu %>% arrange(Apt_final)
id_mediana = resu_ordenado$id[15]  # Seleccionamos la ejecución en la posición 15
# Extraer el dataframe correspondiente a la ejecución mediana
df_mediana = lista_resultados[[id_mediana]]
# Graficar la convergencia (Aptitud vs Generación)
M2 = ggplot(df_mediana, aes(x = Gen, y = Eval)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red") +
  labs(title = "Gráfica de Convergencia - Ejecución Mediana",
       x = "Generación",
       y = "Evaluaciones") +
  theme_classic()

ggsave("M2.svg", M2, 
       width = 5, height = 5,
       dpi = 1000)
sv = rsvg("M2.svg",
          height = 700,
          width = 700)
### Exportar en jpeg
writeJPEG(sv, "M2.jpg", quality = 12)





# Encontramos la ejecución en la mediana
### Cargar ambos ###
resu1 = read.csv("resualgo1.csv")
resu2 = read.csv("resualgo2.csv")[,1:3]


