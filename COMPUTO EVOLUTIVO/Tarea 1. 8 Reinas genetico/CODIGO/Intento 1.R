

#### Función generadora de una solución ####
# Esta función genera las componentes de las posiciones de las reinas
# Se hace de una forma NAIVE de tal forma que las reinas pueden estar 
# en cualquier posición del tablero
#### Propuesta para evitar casos repetidos



#### Selección de padres ####
#Mecanismo de selección ###

padreselect = function(){
  # Generar la matriz de resultados de los padres con indices
  candidatos = cbind(aptitudes,indices)
  # Ordenar los posibles candidatos
  candidatos = candidatos[order(candidatos[,1],decreasing = F),];
  #### Propuesta para calcular la cosa, Para el calculo de su prob
  ###  Sumarle 1 pero a un nuevo vector basado en el numero de ataques originales
  ### Calcular el inverso de eso y luego, estanndarizar las probs
  probs = candidatos[,1] + 1
  probs = 1/probs
  #### Sacar a los seleccionados
  #### Seleccionar a 50 (dado que el numero )
  ns = sort(sample(1:100,50,replace = T,prob = probs/sum(probs)))
  seleccionados = cbind(candidatos[ns,],ns);seleccionados
  # Devolver los seleccionados
  return(seleccionados)
}

#### Operador de cruza para generar hijos ####
#PC = 0.50
cruza = function(seleccionados,PC){
  #### Entran las probabilidades de cruza
  #### Y el objeto que contiene el mapeo de los seleccionados
  #### Crear la parejas al azar ####
  A1  = seleccionados[1:25,2]
  A2  = seleccionados[26:50,2]
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
      hijos[[i]] = pobla[[parejas[i,volado1]]]
    }
    #### Si el volado fue 1, que se crucen dando la mitad de cada uno ####
    if(parejas[i,3]==1){
      ### Tomar a los padres
      P1 = pobla[[parejas[i,1]]]
      P2 = pobla[[parejas[i,2]]]
      ### Crear al hijo dando mitad y mitad
      hijos[[i]] = rbind(P1[1:4,],P2[5:8,])
    }
  }
  return(hijos)
}

#### Operador de mutación ####
# Recibe los hijos #
PM = 0.05
i = 1
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











aptitudes1 = rep(0,25) # Vector para vaciar las aptitudes
indices = 1:25
# Ciclo para obtener las aptitudes
for(i in 1:25){
  aptitudes1[i] = APTataques(hijos[[i]])
}
sort(aptitudes1)








m1 = pobla[[40]]
APTataques(m1)
table(X = factor(m1[,1],levels = 1:8),
      Y = factor(m1[,2],levels = 1:8))








