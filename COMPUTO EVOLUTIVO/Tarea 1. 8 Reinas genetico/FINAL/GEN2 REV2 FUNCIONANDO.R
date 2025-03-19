#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
# Representación de Permutaciones [1,2,3,4,....,8]
sol1 = function(){
  # Crear una permutación
  permu = sample(1:8,8);permu 
  
}
pob = function(n){
  # Crear una matriz vacia de tamaño 8*n
  pob1 = matrix(0,nrow = n,ncol = 8)
  # Generar las n posibles soluciones
  for(i in 1:n){
    # Generar las soluciones proceduralmente
    pob1[i,] = sol1()
  }
  # Devolver la solución
  return(pob1)
}
#### 2.- Función de aptitud (ataques) ####
APTataques = function(solucion){
  #### Entra una posible solución, se expande y evalua###
  m1 = cbind(1:8,solucion)
  
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
  return(ataques)
}
### 3.- Función de selección de padres ####
padreselect = function(aptitudes,NP){
  # Extrae la cantidad de aptitudes #
  nk = length(aptitudes)
  # Crear la matriz con los padres escogidos
  # Cada fila es un potencial padre
  padres = matrix(0,nrow =  NP,ncol = 4)
  
  # Aqui va la parte iterativa desde 1 hasta nk*cantidadPadres
  for(i in 1:NP){
    # Genera 5 numeros random entre 1 y pobsize
    pran = sample(1:nk,5)
    # Revisar sus puntajes y ordenarlos
    grupo = aptitudes[pran]
    indor = sort(grupo,index.return = T)
    # Guardar como arreglo los padres escogidos
    padres[i,] = c(pran[indor$ix[1:2]],indor$x[1:2]) 
  }
  # Devuelve a los que fueron seleccionados para ser padres
  return(padres)
}
### 4.- Aplicar la cruza ####
cruza = function(seleccionados,poblacion,PC){
  # Obtener la cantidad de parejas que entran
  nk = nrow(seleccionados)
  # Crear una matriz donde almacenar a los hijos
  hijosres = matrix(0,nrow = 2,ncol = 8)[-c(1:2),]
  # lanzar un volado para ver si se cruzan
  voladoc = sample(c(1,0),size = nk,replace = T,prob = c(PC,1-PC))
  # Hacer el proceso de cruza para cada pareja
  for(i in 1:nk){
    # Creo un contenedor para los hijos en pequeño
    mini = matrix(0,nrow = 2,ncol = 8)
    ### Voy tomando parejas y creo 2 hijos ###
    # Esto se va a repetir pobsize*0.5 veces
    parejak = seleccionados[i,1:2]
    padres = poblacion[parejak,]
    #### Condición para ver si se reproducen o no ####
    if(voladoc[i]==0){
      # El padre 1 se convierte en el hijo 1
      # El padre 2 se convierte en el hijo 2
      mini = padres
    }else{
      # Dado que se van a reproducir si o si, no agrego la prob de cruza
      # Genero un numero random entre 2 y 8
      pr = sample(1:8,1) # Este es el punto donde se hace la cruza
      # Hacer un caso IF para 1 
      if (pr == 1) {
        # Agregarlos directamente
        mini[1,] = padres[2, ]
        mini[2,] = padres[1, ]
      } else if (pr == 8) {
        mini[1,] = padres[1, ]
        mini[2,] = padres[2, ]
      }else if (pr > 1 && pr < 8) {
        # Agregar la cruza junto con su reparador
        mini[1,] = c(padres[1,1:pr],padres[2,(pr+1):8])
        mini[2,] = c(padres[2,1:pr],padres[1,(pr+1):8])
        # Iniciar el ciclo del reparador
        base = 1:8
        i = 1
        for(i in 1:2){
          # Aplica el while para iterar la reparación sobre cada hijo
          # Contar cuales elementos se repiten #
          conteo = sort(table(factor(mini[i,],levels = 1:8)),decreasing = T)
          while(conteo[1]>1){
            # Obtener los nombres de los conteos #
            nomcon = as.numeric(names(conteo))
            # Sí Identificar despues del corte donde esta el repetido #
            posi = which(mini[i,] == nomcon[1] & 1:8>pr)
            mini[i,posi] = setdiff(base,mini[i,])[1]
            # Volver a contar y verificar para la condición del while
            conteo = sort(table(factor(mini[i,],levels = 1:8)),decreasing = T)
          }
          # Sale y repite para ambos hijos
        }
      }
    }
    # Agregar el resultado a la matriz de hijos resultantes
    hijosres = rbind(hijosres,mini)
  }
  # Reportar la salida de los hijos
  return(hijosres)
}
### 5.- Mutación ####
mutacion = function(hijos,PM){
  # Entra PM y los hijos
  # Lanzo un volado para cada hijo
  volados = sample(c(1,0),nrow(hijos),
                   prob = c(PM,1-PM),replace = T)
  # Para cada uno, aplico el operador o no
  for(i in 1:length(volados)){
    # Revisar si son candidatos a ser mutados
    if(volados[i]!=0){
      # Genera 2 numeros random entre 1 y 8 que no se repitan
      swap = sample(1:8,2)
      # Intercambia en el hijo i-esimo esas posiciones
      hijos[i,swap] = hijos[i,rev(swap)]
    }
  }
  # Devolver a los hijos mutados
  return(hijos)
}

#### Función principal ####
reinas2 = function(pobsize,NP,PC,PM,LIM){
  # Contadores del proceso
  contadoreval = 0
  ngen = 0
  mejorsol = c()
  reporte = matrix(0,nrow = 1,ncol = 11)[-1,]
  # Inicializar la población y evaluar sus aptitudes solo una vez
  poblacion = pob(pobsize)
  aptitudes = apply(poblacion, 1, APTataques)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos
  mejorsol[ngen + 1] = min(aptitudes)
  # Caso 1: La mejor solución esta en la población inicial
  if (mejorsol[1] == 0) {
    # Mostrar progreso
    reporte = rbind(reporte,c(ngen,mejorsol[ngen + 1],
                              contadoreval,poblacion[which.min(aptitudes),])) 
    print("Terminó al inicio con la solución óptima:")
  } else {
    # Bucle para iterar el genetico
    while (min(aptitudes) > 0 & contadoreval < LIM) {
      # 3.- Seleccionar a los padres
      seleccionadosp = padreselect(aptitudes, NP)
      
      # 4.- Operador de CRUZA
      hijos = cruza(seleccionadosp,poblacion, PC)
      
      # 5.- Operador de mutación
      hijos = mutacion(hijos, PM)
      
      # 6.- Evaluar SOLO los hijos
      aptitudesh = apply(hijos, 1, APTataques) # Se evaluaron 2 hijos
      contadoreval = contadoreval + length(aptitudesh)  
      
      # 7.- Formar una nueva población
      poblacion = rbind(poblacion, hijos)
      aptitudes = c(aptitudes, aptitudesh)
      
      # Eliminar a los peores 
      indice = sort(aptitudes, index.return = TRUE)$ix[1:pobsize]
      poblacion = poblacion[indice, ]
      aptitudes = aptitudes[indice]  # Mantener las aptitudes correspondientes
      
      # Actualizar generación
      ngen = ngen + 1
      mejorsol[ngen + 1] = min(aptitudes)
      # Mostrar progreso
      reporte = rbind(reporte,c(ngen,mejorsol[ngen + 1],contadoreval,poblacion[1,]))
    }
    # Caso 2: Si no se encontró la solución óptima antes de llegar a LIM
    if (min(aptitudes) > 0) {
      print("No se encontró la solución óptima dentro del límite de evaluaciones.")
      print("Última mejor solución encontrada:")
      print(reporte)
    }
  }
  # Reportar solo lo ultimo
  nf = nrow(reporte)
  print(reporte[nf,]) #Mostrar el ultimo reporte
  # Tunearlo para que salga en forma de tabla
  reporte1 = as.data.frame(reporte)
  names(reporte1) = c("Gen","APT","Eval",paste0("R",1:8))
  return(reporte1) # Devolver todo el reporte
}








