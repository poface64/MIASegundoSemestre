#### Funciones necesarias para que funcione ####
#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
sol1 = function(){
  # Crear una sola solución de 8 filas
  cm1 = sample(1:8, 8, replace = TRUE)
  cm2 = sample(1:8, 8, replace = TRUE)
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
  NX = sum(choose(table(m1[,1]), 2))
  #### Revisar los ataques veritcales (Y) ###
  NY = sum(choose(table(m1[,2]), 2))
  #### Ataques diagonales ###
  n = nrow(m1)
  # Cantidad de ataques en diagonal
  ataques = sum(choose(table(m1[,1] - m1[,2]), 2)) + 
    sum(choose(table(m1[,1] + m1[,2]), 2))
  
  # Sumar los ataques y reportar
  ataques = ataques + NX+ NY   
  return(ataques)
}

### 3.- Selector de padres ####
# Aptitudes = Vector que contiene las aptitudes de los individuos
# indices = Vector que indica a que sujeto corresponde cada aptitud
# NP = porcentaje de la población que seran padres
padreselect = function(aptitudes,indices,NP ){
  # Ordenar los posibles candidatos
  orden = order(aptitudes)
  # Convertirlos en matriz
  candidatos = cbind(aptitudes[orden], indices[orden])
  #### Propuesta para calcular la cosa, Para el calculo de su prob
  ###  Sumarle 1 pero a un nuevo vector basado en el numero de ataques originales
  ### Calcular el inverso de eso y luego, estanndarizar las probs
  probs = 1/(aptitudes[orden] + 1)
  
  #### En base a su desempeño, generar la ruleta ####
  #### Seleccionar al 50% de padres
  ns = sample(seq_along(probs), size = floor(length(probs) * NP),
              replace = TRUE, prob = probs)
  # Devolver los seleccionados
  seleccionados = cbind(candidatos[ns,],ns)
  return(seleccionados)
}

### 4.- Aplica el operador de cruza ####
# Seleccionados = Padres seleccionados en el paso 3
# PC = Porcentaje de cruza
# NP = porcentaje de la población que seran padres
cruza = function(seleccionados, poblacion,PC) {
  # Obtener la cantidad de parejas
  ndp = nrow(seleccionados)
  
  # Particionar en dos grupos lo más equilibrados posible
  mitad = ceiling(ndp / 2)
  A1 = seleccionados[1:mitad, 2]
  A2 = seleccionados[(mitad+1):ndp, 2]
  
  # Si es impar, duplicar el último de A2 para emparejar 
  if (length(A2) < length(A1)) {
    A2 = c(A2, A2[length(A2)])
  }
  
  # Barajar y emparejar
  P1 = sample(A1)
  P2 = sample(A2)
  parejas = cbind(P1, P2)
  
  # Determinar quiénes se cruzan con volados
  Reproduce = rbinom(nrow(parejas), 1, PC)
  parejas = cbind(parejas, Reproduce)
  
  # Generar 2 hijos por pareja
  hijos = vector("list", 2 * nrow(parejas))
  
  # Aplicar el ciclo para generar hijos #
  for (i in 1:(nrow(parejas))) {
    # Preparar a los padres por iteración #
    padre1 = poblacion[[parejas[i, 1]]]
    padre2 = poblacion[[parejas[i, 2]]]
    
    # Caso donde no se cruzan #
    if (parejas[i, 3] == 0) {
      # Si no se cruzan, cada padre se clona en un hijo
      hijos[[2 * i - 1]] = padre1
      hijos[[2 * i]] = padre2
    } else {
      # Caso donde si se cruzan y dan la mitad del material genetico #
      hijos[[2 * i - 1]] = rbind(padre1[1:4, ], padre2[5:8, ])
      hijos[[2 * i]] = rbind(padre2[1:4, ], padre1[5:8, ])
    }
  }
  return(hijos)
}

#### 5.- Operador de mutación ####
# hijos = lista de hijos resultantes del paso 4
# PM = porcentaje de mutación
mutacion = function(hijos, PM) {
  # Apllicar el proceso para cada uno de los hijos
  for (i in 1:length(hijos)) {
    SZ = hijos[[i]]  # Obtener el hijo
    # Doble ciclo for para lanzar un volado por cada par de coordenadas
    for (j in 1:(nrow(SZ))) {
      if (runif(1) < PM) {  # lanzar volados
        SZ[j, ] = rev(SZ[j, ])  # Invertir la fila
      }
    }
  }
  # Devolver a los hijos mutados
  return(hijos)
}


#### Función principal ####
reinas = function(pobsize,NP,PC,PM,LIM){
  # Contadores del proceso
  contadoreval = 0
  ngen = 0
  mejorsol = c()
  reporte = matrix(0,nrow = 1,ncol = 3)[-1,]
  # Inicializar la población y evaluar sus aptitudes solo una vez
  poblacion = pob(pobsize)
  aptitudes = sapply(poblacion, APTataques)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos
  mejorsol[ngen + 1] = min(aptitudes)
  # Caso 1: La mejor solución esta en la población inicial
  if (mejorsol[1] == 0) {
    # Mostrar progreso
    reporte = rbind(reporte,c(ngen,mejorsol[ngen + 1],contadoreval)) 
    print("Terminó al inicio con la solución óptima:")
  } else {
    # Bucle para iterar el genetico
    while (min(aptitudes) > 0 & contadoreval < LIM) {
      # 3.- Seleccionar a los padres
      indices = 1:pobsize
      seleccionadosp = padreselect(aptitudes,indices,NP)
      
      # 4.- Operador de CRUZA
      hijos = cruza(seleccionadosp,poblacion, PC)
      
      # 5.- Operador de mutación
      hijos = mutacion(hijos, PM)
      
      # 6.- Evaluar SOLO los hijos
      aptitudesh = sapply(hijos, APTataques) # Se evaluaron 50 hijos
      contadoreval = contadoreval + length(aptitudesh)  
      
      # 7.- Formar una nueva población
      poblacion = c(poblacion, hijos)
      aptitudes = c(aptitudes, aptitudesh)
      
      # Eliminar a los peores 
      indice = order(aptitudes)[1:pobsize] 
      # Actualizar la lista con los menos peores #
      poblacion = poblacion[indice]
      aptitudes = aptitudes[indice]  # Mantener las aptitudes correspondientes

      # Actualizar generación
      ngen = ngen + 1
      mejorsol[ngen + 1] = min(aptitudes)
      # Mostrar progreso
      
      mejor_individuo = poblacion[[which.min(aptitudes)]]
      reporte = rbind(reporte, c(ngen, mejorsol[ngen + 1], contadoreval))
      #print(reporte)
    }
    # Caso 2: Si no se encontró la solución óptima antes de llegar a LIM
    if (min(aptitudes) > 0) {
      print("No se encontró la solución óptima dentro del límite de evaluaciones.")
      print("Última mejor solución encontrada:")
      #print(reporte)
    }
  }
  # Reportar solo lo ultimo
  nf = nrow(reporte)
  print(reporte[nf,]) #Mostrar el ultimo reporte
  # Tunearlo para que salga en forma de tabla
  reporte1 = as.data.frame(reporte)
  names(reporte1) = c("Gen","APT","Eval")
  # Extraer el mejor sujeto #
  salidas = list(reporte1,mejor_individuo)
  return(salidas) # Devolver todo el reporte
}










