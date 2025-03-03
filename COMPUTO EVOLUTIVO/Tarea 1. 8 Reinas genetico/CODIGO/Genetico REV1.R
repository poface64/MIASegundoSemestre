rm(list=ls())

#### Funciones necesarias para que funcione ####

#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
sol1 = function(){
  # Crear una sola solución de 8 filas
  cm1 = round(runif(8,min = 1,max = 8))
  cm2 = round(runif(8,min = 1,max = 8))
  # Juntar todo en una matriz
  sol = cbind(X = cm1,Y = cm2);sol
  # Revisar si existen casos repetidos
  ### Hacer la tabla cruzada tipo tablero ###
  checador = table(X = factor(sol[,1],levels = 1:8),
                   Y = factor(sol[,2],levels = 1:8))
  ### Identificar la posición donde estan los repetidos
  posiciones = which(checador>=2,arr.ind = T)
  # Revisar la cantidad de sujetos repetidos
  sn = length(posiciones)
  #### Checador de repetidas ###
  #### Existen casos donde se siguen repitiendo valores ####?
  while(sn>=1){
    # Asumir que no solo voy a encontrar un repetido, entonces
    # modificar los valores de cada repetido
    for(i in 1:nrow(posiciones)){
      # Identificar a aquellos que se repiten 1 por uno
      s1 = posiciones[i,] # Extraer las coordenadas repetidas i-esimas
      # Cambiar dichos valores al azar 
      cond1 = sol[,1]==s1[1] # Verificar en filas
      cond2 = sol[,2]==s1[2] # Verificar en columnas
      # Revisar cuantos de ese tipo hay
      nr =  length(sol[cond1 & cond2 ,]) 
      sol[cond1 & cond2 ,] = round(runif(nr,min = 1, max = 8))
    }
    # Recalcular las posiciones
    ### Hacer la tabla cruzada tipo tablero ###
    checador = table(X = factor(sol[,1],levels = 1:8),
                     Y = factor(sol[,2],levels = 1:8))
    ### Identificar la posición donde estan los repetidos
    posiciones = which(checador>=2,arr.ind = T)
    # Revisar la cantidad de sujetos repetidos
    sn = length(posiciones)
  }
  # Devolver dicha solución LIBRE DE REPETIDOS
  return(sol)
}
pob = function(n){
  # Crear el objeto/lista donde seran guardadas las soluciones
  pob1 = list()
  # Generar las n posibles soluciones
  for(i in 1:n){
    # Generar las soluciones proceduralmente
    pob1[[i]] = sol1()
  }
  # Devolver la solución
  return(pob1)
}
#### 2.- Función de aptitud (ataques) ####
APTataques = function(solucion){
  #### Entra una posible solución y se evalúa ###
  m1 = solucion
  #### Calcular los ataques Horizontales (X)###
  AX = table(factor(m1[,1],levels = 1:8))
  NX =  sum(ifelse((AX-1)>=1,(AX-1),0))
  #### Revisar los ataques veritcales (Y) ###
  AY = table(factor(m1[,2],levels = 1:8))
  NY =  sum(ifelse((AY-1)>=1,(AY-1),0))
  #### Ataques diagonales ###
  n = nrow(m1)
  # Cantidad de ataques
  ataques =  0
  # Moverse diagonalmente
  for (i in 1:(n-1)) {
    for (j in (i+1):n) {
      # Extraer coordenadas
      fila_i <- m1[i, 1]
      col_i <- m1[i, 2]
      fila_j <- m1[j, 1]
      col_j <- m1[j, 2]
      # Verificar diagonal si la cosa es diagonal o no para contabilizarlo
      if (abs(fila_i - fila_j) == abs(col_i - col_j)) {
        ataques <- ataques + 1
      }
    }
  }
  # Sumar los ataques y reportar
  ataques = ataques + NX+ NY   
  return(ataques)
}
### 3.- Selector de padres ####
# Aptitudes = Vector que contiene las aptitudes de los individuos
# indices = Vector que indica a que sujeto corresponde cada aptitud
# NP = porcentaje de la población que seran padres
padreselect = function(aptitudes,indices,NP ){
  # Generar la matriz de resultados de los padres con indices
  candidatos = cbind(aptitudes,indices)
  # Ordenar los posibles candidatos
  candidatos = candidatos[order(candidatos[,1],decreasing = F),]
  #### Propuesta para calcular la cosa, Para el calculo de su prob
  ###  Sumarle 1 pero a un nuevo vector basado en el numero de ataques originales
  ### Calcular el inverso de eso y luego, estanndarizar las probs
  probs = candidatos[,1] + 1
  probs = 1/probs
  #### En base a su desempeño, generar la ruleta ####
  #### Seleccionar al 50% de padres
  ns = sort(sample(1:length(probs),round(length(probs)*PC),
                   replace = T,prob = probs/sum(probs)))
  seleccionados = cbind(candidatos[ns,],ns);seleccionados
  # Devolver los seleccionados
  return(seleccionados)
}

### 4.- Aplica el operador de cruza ####
# Seleccionados = Padres seleccionados en el paso 3
# PC = Porcentaje de cruza
# NP = porcentaje de la población que seran padres
cruza = function(seleccionados,PC){
  #### Entran las probabilidades de cruza
  #### Y el objeto que contiene el mapeo de los seleccionados
  # Revisar si el numero de sujetos es par o impar
  ndp = nrow(seleccionados)
  # Sí el caso es par, toma por mitades
  if(ndp%%2==0){
    # Seleccionar por mitades
    A1  = seleccionados[1:(ndp/2) ,2]
    A2  = seleccionados[(ndp/2+1):(ndp),2]
  }else{
    # Si no es el caso, arreglalo de tal manera que puedas 
    # incluir al que no tiene pareja
    A1  = seleccionados[1:floor(ndp/2+1) ,2]
    A2  = seleccionados[floor((ndp/2+1)):(ndp),2]
  }
  ## Barajar los individuos y juntarlos con una pareja ###
  P1 = sample(A1,length(A1))
  P2 = sample(A2,length(A2))
  parejas = cbind(P1,P2) 
  # Aplicar el porcentaje de cruza #
  Reproduce = sample(c(0,1),nrow(parejas),
                     replace = T,prob = c(1-PC,PC))
  parejas = cbind(parejas,Reproduce)
  #### Ciclo para la reproducción ###
  hijos = list()
  for(i in 1:nrow(parejas)){
    #### Si el volado fue 0, lanza otro volado y clona a un padre
    if(parejas[i,3]==0){
      # Lanza un volado para saber con cual padre nos quedamos
      volado1 = sample(c(1,2),1)
      hijos[[i]] = poblacion[[parejas[i,volado1]]]
    }
    #### Si el volado fue 1, que se crucen dando la mitad de cada uno ####
    if(parejas[i,3]==1){
      ### Tomar a los padres
      P1 = poblacion[[parejas[i,1]]]
      P2 = poblacion[[parejas[i,2]]]
      ### Crear al hijo dando mitad y mitad
      hijos[[i]] = rbind(P1[1:4,],P2[5:8,])
    }
  }
  return(hijos)
}
#### 5.- Operador de mutación ####
# hijos = lista de hijos resultantes del paso 4
# PM = porcentaje de mutación
mutacion = function(hijos,PM){
  # Recibe a los hijos y les aplica una muta pequeña
  for(i in 1:length(hijos)){
    # Sujeto a mutar
    SZ = hijos[[i]]
    for(j in 1:nrow(SZ)){
      # Lanzar una moneda con 0.05 prob de ser favorable
      moneda2 = sample(c(0,1),1,prob = c(1-PM,PM))
      # Si se cumple, cambiar de posición los valores
      if(moneda2 ==1){
        SZ[j,] = rev(SZ[j,])
      }
    }
    ### Cambiar el hijo mutado
    hijos[[i]] = SZ
  }
  return(hijos)
}

### 6.- Selector de población de reemplazo ####
# megamix = población formada por padres e hijos
# pobsize = tamaño de la población
reempplazo = function(megamix,pobsize){
  # Calcular aptitudes y ruleta
  aptitudes = rep(0,length(megamix)) # Vector para vaciar las aptitudes
  indices = 1:length(megamix)
  # Ciclo para obtener las aptitudes
  for(i in 1:length(megamix)){
    aptitudes[i] = APTataques(megamix[[i]])
  }
  # Generar la matriz de resultados de los padres con indices
  candidatos = cbind(aptitudes,indices)
  # Ordenar los posibles candidatos
  candidatos = candidatos[order(candidatos[,1],decreasing = F),]
  #### Propuesta para calcular la cosa, Para el calculo de su prob
  ###  Sumarle 1 pero a un nuevo vector basado en el numero de ataques originales
  ### Calcular el inverso de eso y luego, estanndarizar las probs
  probs = candidatos[,1] + 1
  probs = 1/probs
  #### En base a su desempeño, generar la ruleta ####
  ns = sort(sample(1:length(probs),pobsize,
                   replace = T,prob = probs/sum(probs)))
  nuevapob = cbind(candidatos[ns,],ns)
  # Devolver los seleccionados
  return(nuevapob)
}

#### Tratando de armar el ciclo completo ####

# Parametros de inicio
pobsize = 100 # Tamaño de la población
PC = 0.5 # Porcentaje de cruza
NP = 0.5 # Número de padres
PM = 0.05 # Porcentaje de mutación
maxgen = 110

### Inicialiar el número de generaciones ###
ngen = 0
while(ngen <= maxgen){
  #### 1.- Inicializar la población
  if(ngen == 0){
    poblacion = pob(pobsize)
  }
  #### 2.- Evaluar la población ####
  ### Calcular sus aptitudes ###
  aptitudes = rep(0,pobsize) # Vector para vaciar las aptitudes
  indices = 1:pobsize
  # Ciclo para obtener las aptitudes
  for(i in 1:length(poblacion)){
    aptitudes[i] = APTataques(poblacion[[i]])
  }
  #### 3.- Seleccionar a los padres ####
  seleccionadosp = padreselect(aptitudes = aptitudes,
                               indices = indices,
                               NP = NP)
  #### 4.- Operador de CRUZA ####
  #### Operador de cruza para generar hijos ####
  #PC = 0.50
  hijos = cruza(seleccionadosp,PC)
  
  #### 5.- Operador de mutación ####
  #### Operador de mutación sobre los hijos ####
  hijos = mutacion(hijos,PM)
  #### 6.- Evaluar a los hijos
  ### Calcular sus aptitudes ###
  aptitudesh = rep(0,length(hijos)) # Vector para vaciar las aptitudes
  indicesh = 1:length(hijos)
  # Ciclo para obtener las aptitudes
  for(i in 1:length(hijos)){
   aptitudesh[i] = APTataques(hijos[[i]])}
  hijosr = cbind(indicesh,aptitudesh)
  hijosr = hijosr[order(hijosr[,2],decreasing = F),]
  print(hijosr[1:3,])
  ### 7 Formar una nueva población seleccionando de entre los hijos y los padres ###
  megamix = c(poblacion[seleccionadosp[,2]],
              hijos)
  ### Seleccionar a los que conformaran la siguiente población
  npobla = reempplazo(megamix = megamix,
                      pobsize = pobsize)
  #### Asignar la nueva población y repetir
  poblacion = megamix[npobla[,2] ]
  #### Actualizar y repetir
  ngen = ngen + 1
  #print(npobla[1:3,])
}

table(X = megamix[[npobla[1,2]]][,1],
      Y = megamix[[npobla[1,2]]][,2])


