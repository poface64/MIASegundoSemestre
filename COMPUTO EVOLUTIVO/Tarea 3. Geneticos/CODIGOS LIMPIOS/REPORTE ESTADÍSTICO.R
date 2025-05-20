rm(list=ls())
# Análisis estadísticos de la cosa #

#### Función para calcular las 30 corridas e ir guardando los reportes ####
recolectorNR = function(cn){
  # Crear un objeto para ir guardando  los reportes
  repo1 = list()
  mejoresN = list()
  # Ciclo para extraer info de hasta N corridas
  for(i in 1:cn){
    # Semilla fija del 1 al 30 #
    set.seed(i)
    # Corrida n
    C1 =  optimizar(problema,pobsize,ngen,PC,PM,b,tol,Dn,mostrar)
    # Extraer la info de los reportes
    repo =cbind.data.frame(C1$reporteint,C1$reporteUS[,-c(1,2)])  
    # Guardarlo en la lista
    repo1[[i]] = repo
    # Extraer al mejor sujeto de esta corrida
    mejoresN[[i]] = repo[which.min(repo$apt),]
  }
  # Compactar en un solo objeto:
  A1 = do.call(rbind, mejoresN) 
  ### Estadísticas para la tabla 2 ###
  tabla2 = round(cbind.data.frame(min(A1$apt),max(A1$apt),mean(A1$apt),
                                  median(A1$apt),sd(A1$apt)),4)
  names(tabla2) = c("Mejor","Peor","Media","Mediana","Desviación")
  
  #### Seleccionar la mediana de las corridas ####
  indices = order(A1$apt)
  posi = round((length(indices)+1)/2)
  indioriginal = (1:cn)[indices[posi]]
  
  ### Seleccionar el conjunto de datos del indice original ###
  grafi = repo1[[indioriginal]]
  
  #### Seleccionar los elementos a devoler ####
  resu = list(grafimed = grafi,
              mejores30 = A1,
              estadisticas = tabla2
  )
  #### Devolver la salida ####
  return(resu)
}
recolectorNB = function(cn){
  # Crear un objeto para ir guardando  los reportes
  repo1 = list()
  mejoresN = list()
  # Ciclo para extraer info de hasta N corridas
  for(i in 1:cn){
    # Semilla fija del 1 al 30 #
    set.seed(i)
    # Corrida n
    C1 =  optimizar(problema,pobsize,ngen,PC,PM,mostrar,Dn)
    # Extraer la info de los reportes
    repo =cbind.data.frame(C1$reporteint,C1$reporteUS[,-c(1,2)])  
    # Guardarlo en la lista
    repo1[[i]] = repo
    # Extraer al mejor sujeto de esta corrida
    mejoresN[[i]] = repo[which.min(repo$apt),]
  }
  # Compactar en un solo objeto:
  A1 = do.call(rbind, mejoresN) 
  ### Estadísticas para la tabla 2 ###
  tabla2 = round(cbind.data.frame(min(A1$apt),max(A1$apt),mean(A1$apt),
                                  median(A1$apt),sd(A1$apt)),4)
  names(tabla2) = c("Mejor","Peor","Media","Mediana","Desviación")
  
  #### Seleccionar la mediana de las corridas ####
  indices = order(A1$apt)
  posi = round((length(indices)+1)/2)
  indioriginal = (1:cn)[indices[posi]]
  
  ### Seleccionar el conjunto de datos del indice original ###
  grafi = repo1[[indioriginal]]
  
  #### Seleccionar los elementos a devoler ####
  resu = list(grafimed = grafi,
              mejores30 = A1,
              estadisticas = tabla2
  )
  #### Devolver la salida ####
  return(resu)
}

#### Parametros para los binarios ####
source("BINARIO FUENTE.R")

#### Corridas para el problema 1 ####
problema=1
pobsize=30
ngen = 2000
PC=0.8
PM=0.01
Dn = 10
mostrar = 0

### Problema 1 ###

P1B = recolectorNB(30)
G1B =P1B$grafimed$apt 
P130 = P1B$mejores30
P1E = P1B$estadisticas






### Problema 2 ####
problema=2
P2B = recolectorNB(30)

G2B =P2B$grafimed$apt 
P230 = P2B$mejores30
P2E = P2B$estadisticas

#### Pegar objetos similares
# Gráficos #
graficosbin = cbind.data.frame(apt = c(G1B,G2B),
                               problema=factor(rep(c("BP1","BP2"),each = 2001)))
# Estadísticas #
binEST = rbind.data.frame(P1E,P2E)
binEST$PROBLEMA = c("BP1","BP2")
# Mejores 30 
bin30 = rbind.data.frame(P130,P230)
bin30$problema =  rep(c("BP1","BP2"),each = 30)


# REPORTAR AL EXCEL
library(xlsx)

write.xlsx(graficosbin,"BINres.xlsx",row.names = F )
write.xlsx(bin30 , file = "BINres.xlsx", sheetName = "Mejores30",
           append = TRUE)
write.xlsx(binEST , file = "BINres.xlsx", sheetName = "Esatadisticas",
           append = TRUE)



#### Corridas para el problema 2 ####
#### Parametros para los binarios ####
source("REAL FUENTE.R")
recolectorNR = function(cn){
  # Crear un objeto para ir guardando  los reportes
  repo1 = list()
  mejoresN = list()
  # Ciclo para extraer info de hasta N corridas
  for(i in 1:cn){
    # Semilla fija del 1 al 30 #
    set.seed(i)
    # Corrida n
    C1 =  optimizar(problema,pobsize,ngen,PC,PM,b,tol,Dn,mostrar)
    # Extraer la info de los reportes
    repo =cbind.data.frame(C1$reporteint,C1$reporteUS[,-c(1,2)])  
    # Guardarlo en la lista
    repo1[[i]] = repo
    # Extraer al mejor sujeto de esta corrida
    mejoresN[[i]] = repo[which.min(repo$apt),]
  }
  # Compactar en un solo objeto:
  A1 = do.call(rbind, mejoresN) 
  ### Estadísticas para la tabla 2 ###
  tabla2 = round(cbind.data.frame(min(A1$apt),max(A1$apt),mean(A1$apt),
                                  median(A1$apt),sd(A1$apt)),4)
  names(tabla2) = c("Mejor","Peor","Media","Mediana","Desviación")
  
  #### Seleccionar la mediana de las corridas ####
  indices = order(A1$apt)
  posi = round((length(indices)+1)/2)
  indioriginal = (1:cn)[indices[posi]]
  
  ### Seleccionar el conjunto de datos del indice original ###
  grafi = repo1[[indioriginal]]
  
  #### Seleccionar los elementos a devoler ####
  resu = list(grafimed = grafi,
              mejores30 = A1,
              estadisticas = tabla2
  )
  #### Devolver la salida ####
  return(resu)
}

#### Corridas para el problema 1 ####
problema=1
pobsize=30
ngen = 2000
PC=0.8
PM=0.01
b = 0.001
Dn = 10
mostrar = 0
### Problema 1 ###
P1R = recolectorNR(30)
G1R =P1R$grafimed$apt 
P130 = P1R$mejores30
P1E = P1R$estadisticas


### Problema 2 ####
problema=2
P2R = recolectorNR(30)
G2R =P2R$grafimed$apt 
P230 = P2R$mejores30
P2E = P2R$estadisticas

#### Pegar objetos similares
# Gráficos #
graficosbin = cbind.data.frame(apt = c(G1R,G2R),
                               problema=factor(rep(c("RP1","RP2"),each = 2001)))
# Estadísticas #
binEST = rbind.data.frame(P1E,P2E)
binEST$PROBLEMA = c("RP1","RP2")
# Mejores 30 
bin30 = rbind.data.frame(P130,P230)
bin30$problema =  rep(c("RP1","RP2"),each = 30)


# REPORTAR AL EXCEL
library(xlsx)

write.xlsx(graficosbin,"Rres.xlsx",row.names = F )
write.xlsx(bin30 , file = "Rres.xlsx", sheetName = "Mejores30",
           append = TRUE)
write.xlsx(binEST , file = "Rres.xlsx", sheetName = "Esatadisticas",
           append = TRUE)


#### Análisis estadisticos #### 
rm(list=ls())
library(readxl)
library(ggplot2)
### Gráficos ###
BING = as.data.frame(read_excel("BINres.xlsx"))
REALG = as.data.frame(read_excel("Rres.xlsx"))
X = rep(1:2001,each = 2)
BING$gen = X-1
REALG$gen = X-1

### Separar por el tipo de problemas ###
# Problema1
problema1 = rbind.data.frame(BING[BING$problema=="BP1",],
                             REALG[REALG$problema=="RP1",])
# Problema2
problema2 = rbind.data.frame(BING[BING$problema=="BP2",],
                             REALG[REALG$problema=="RP2",])

### Hacer el gráfico de lineas con ggplot2 ###
G1 = ggplot(problema1,aes(x = gen,
                     y = apt,
                     group = problema,
                     color = problema)) + 
  geom_point(color = "black") + 
  geom_line() +
  theme_classic() +
  scale_color_discrete(name = "Problema 1", 
                      labels = c("Binario","Real"))+
  theme(legend.position = "inside")
ggsave("CP1.pdf",G1)
### Hacer el gráfico de lineas con ggplot2 ###
G2 = ggplot(problema2,aes(x = gen,
                     y = apt,
                     group = problema,
                     color = problema)) + 
  geom_point(color = "black") + 
  geom_line() +
  theme_classic() +
  scale_color_discrete(name = "Problema 2", 
                       labels = c("Binario","Real"))+
  theme(legend.position = "inside")
ggsave("CP2.pdf",G2)


####### Pruebas de wilcoxon #####
BINGW = as.data.frame(read_excel("BINres.xlsx",sheet = "Mejores30"))
REALGW = as.data.frame(read_excel("Rres.xlsx",sheet = "Mejores30"))

# PRUEBA PARA EL PROBLEMA 1 #
problema1 = rbind.data.frame(BINGW[BINGW$problema=="BP1",],
                             REALGW[REALGW$problema=="RP1",])
problema1$problema = factor(problema1$problema)
wilcox.test(problema1$apt~problema1$problema)


# P2
problema2 = rbind.data.frame(BINGW[BINGW$problema=="BP2",],
                             REALGW[REALGW$problema=="RP2",])
wilcox.test(problema2$apt~problema2$problema,
            alternative = "two.sided" )








