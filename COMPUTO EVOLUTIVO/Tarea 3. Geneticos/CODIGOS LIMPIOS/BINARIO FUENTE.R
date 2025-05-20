# Trabajando de izquierda a derecha
# Donde el primer bite tiene menos peso
# y los consiguientes tienen mayor paso

#### Función para convertir enteros a bits ####
# X: valor entero a convertir
# nbits: cantidad de bits para representar el entero
e2b = function(x,nbits){
  # Numero a convertir
  entero = x
  # Vector donde guardar los residuos 
  residuos =  character() 
  actual = entero
  # Ciclo para 
  while (actual > 0) {
    residuo = actual %% 2 # Obtenemos el residuo de la división por 2
    residuos = c(as.character(residuo), residuos) #Agregar al vector de residuos
    actual = floor(actual / 2) # Actualizamos el número dividiéndolo por 2 (parte entera)
  }
  # Contar los elementos que hay en residuos #
  nd = length(residuos)
  # Contar la diferencia entre los nbits y los residuos
  dif = nbits-nd
  # Agregar con dif cantidad de 0's para acompletar hasta nbits elementos
  resu = as.integer(c(rev(residuos),rep("0",dif))) # Resu es un vector de tamaño 15
  return(resu) 
}

#### Función para convertir de bits a enteros ####
# vbits: Vector de bits
b2e = function(vbits) {
  # Calcular el tamaño del vector #
  nd =  length(vbits)
  # Potencias de 2 
  posiciones = (2^(0:(nd-1)))
  # Aplicar a cada elemento del vector y sumar
  resultante  = sum(vbits*posiciones)
  # reportar el resultado
  return(resultante)
}

#### Función que convierte de reales a bits ####
# X: valor real a convertir
# nbits: cantidad de bits para representar el entero
# a = limite inferior
# b = limite superior

r2b = function(x,nbits,problema){
  # Verificar si es un problema u otro #
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  a = limites[1]
  b = limites[2]
  # Convertir el valor a un número uniforme de 0 a 1
  u = (x-a)/(b-a)
  # Calcular el máximo entero con nbits
  max_ent <- 2^nbits - 1
  # Convertir el valor uniforme en entero:
  entero <- round(u * max_ent)
  bin <- e2b(entero,nbits)
  # Devolver la cadena de bits
  return(bin)
}

#### Función que convierte bits a reales ####
# bin: cadena de bits a converir
# nbits: cantidad de bits para representar el entero
# a = limite inferior
# b = limite superior
b2r = function(bin ,nbits,problema){
  # Verificar si es un problema u otro #
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  a = limites[1]
  b = limites[2]
  # Convertir el binario a entero
  entero = b2e(bin)
  # Calcular el máximo entero
  max_ent = (2^nbits)-1
  # Normalizar el entero entre el máximo
  u = entero/max_ent
  # Aplicar la transformación uniforme pero alreves #
  resu = a + u*(b-a)
  # Devolver redondeado a 3 decimales 
  return(round(resu,3))
}

## Función para determinar la cantidad de bits ##
# problema = problemas a elegir (1 o 2)
# precisión = Precisión de la representación, 3 decimales
n_bits = function(problema,precision = 3){
  # Para el problema 1 o problema 2
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
    # Calcular el numero de bits dependiendo el problema
  nposibles = (limites[2]-limites[1])/(1/10^precision)
  # Devolver los nbits
  return(ceiling(log2(nposibles)))
}




#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
sol1 = function(problema,nbits,Dn = 10){
  # Para el problema 1 o problema 2
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  # Generar la solución random con  Dn numeros reales # 
  reales = round(runif(Dn,min = limites[1],max =  limites[2]),3)
  # Vectorizar la conversión para la cadena #
  # Convierte a lista cada posible salida y luego la convierte a vector
  # Aplica una función tipo lambda
  bits =  unlist(lapply(reales, function(x) r2b(x, nbits, problema)))
  # Devolver la cadena
  return(bits)
}

# Generador de la población #
pob = function(pobsize,problema,nbits, Dn = 10){
  pob1 = matrix(0, nrow = pobsize, ncol = Dn*nbits)
  for(i in 1:pobsize){
    pob1[i,] = sol1(problema,nbits,Dn = 10 )
  }
  # Reportar la población generada #
  return(pob1)
}


#### 2.- Funciones de aptitud 1 y 2 ####
#problema: selector entre problema 1 o 2
# Si es problema 1, el valor varia en [-10,10]
# Si es problema 2, el valor varia en [-5.12,5.12]
# Decofificador de sujeto de bits a reales #
db2r = function(X,problema,nbits){
  # Definir limites del problema segun sea el caso:
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  # Dividir X en segmentos de nbits
  segmentos = length(X)/nbits
  # Hacer una matriz con segmentos
  msegmentos = matrix(X,nrow = nbits,ncol = segmentos)
  # Cada columna como un subvector de bits
  vresu = apply(msegmentos,2,function(bits){
    b2r(bits,nbits,problema)})
  # Devolver el resultado
  return(vresu)
}

fx = function(X,problema,nbits){
  # Enmtra el sujeto en bits y se decodifica a real #
  vresu = db2r(X,problema,nbits)
  # Devolver la aptitud #
  # Problema 1
  if(problema==1){
    # Problema de la esfera
    resu = sum(vresu^2)
    # Devolver el valor
    return(resu)
  }else{
    # Problema 2
    # PARTE CONSTANTE
    D = length(vresu)
    dc = 10*D
    # Parte de la suma de cosenos
    pc = sum(vresu^2 - 10*cos(2*pi*vresu))
    # Resultado
    res = dc + pc
    return(res)
  }
}


### 3.- Selector de padres por muestreo deterministico ###
#pobsize = tamaño de la población
#aptitud = vector de aptitudes
padreselect = function(pobsize,aptitud){
  # Convertir las aptitudes
  # restando la aptitud_i al peor sujeto.
  aptr = max(aptitud)-aptitud
  ## Calcular la aptitud relativa ##
  apr = aptr/sum(aptr)
  # Hacerlo como matriz por facilidad
  # indice;aptitud;entero;residuo#
  selec = cbind(1:pobsize,apr,floor(apr*pobsize),(apr*pobsize)%%1)
  # Seleccionando los mejores enteros:
  enteros = selec[selec[,3]>0,]
  # Enteros seleccionados
  ganadores = rep(enteros[,1],enteros[,3])
  # Obtener la diferencia entre los seleccionados y los que faltan
  dife = pobsize-length(ganadores)
  # Sacar los dif mejores en base al residuo
  rs = selec[order(selec[,4],decreasing = T),][1:dife ,1]
  # Reportar a los ganadores finales #
  ganadores = c(ganadores,rs)
  # Devolver el vector de ganadores
  return(ganadores)
}

### 4.- Aplica el operador de cruza uniforme ####
# ganadores = Padres seleccionados en el paso 3
# poblacion = poblacion
# PC = Porcentaje de cruza
# problema: problema que se esta resolviendo
cruza = function(ganadores, poblacion,PC){
  # Calcular la dimensión de las soluciones
  np = ncol(poblacion)
  # Calcular la cantidad de ganadores #
  Di = length(ganadores)
  # Obtener la cantidad de parejas individuos
  ndp =  Di/2
  # Escoger aleatorios los padres
  selectos = sample(ganadores,Di)
  P1 = selectos[1:(Di/2)]
  P2 = selectos[(Di/2+1):Di]
  parejas = cbind(P1, P2)
  # Determinar quiénes se cruzan con volados
  Reproduce = rbinom(nrow(parejas), 1, PC)
  parejas = cbind(parejas, Reproduce)
  # Generar 2 hijos por pareja
  hijos = matrix(0,nrow = Di, ncol = np)
  # Aplicar el ciclo para generar hijos #
  for (i in 1:(nrow(parejas))) {
    # Preparar a los padres por iteración #
    padre1 = poblacion[parejas[i, 1], ]
    padre2 = poblacion[parejas[i, 2], ]
    # Caso donde no se cruzan #
    if(parejas[i, 3] == 0) {
      # Si no se cruzan, cada padre se clona en un hijo
      hijos[(2 * i - 1),] = padre1
      hijos[(2 * i),] = padre2
    } else {
      ### Aplica La cruza uniforme ###
      #Genero la mascara de tamaño np
      mascara = sample(c(0,1),np,replace = T)
      # Crea al hijo 1
      hijo1 = ifelse(mascara==1,padre1,padre2)
      # Crea al hijo 2
      hijo2 = ifelse(mascara==1,padre2,padre1)
      # Agregar a la población #
      # Generar a los hijos 
      hijos[(2*i - 1),] = hijo1
      hijos[(2*i),] = hijo2
    }
  }
  # Devolver a los hijos
  return(hijos)
}



### 5.- Operador de mutacion ###
mutacion = function(hijos, PM){
  # Establecer el número de dimensiones del vector
  nh = ncol(hijos)
  # Para el hijo i-esimo
  for(i in 1:nrow(hijos)){
    # Lanzar los volados con PM de mutación por atributo
    muta = rbinom(nh, 1, PM)
    # Aplicar el bitflip para aquellos que resultaron seleccionados
    hijos[i,muta==1] = abs(hijos[i,muta==1]-1)
  }
  # Devolver a los hijos mutados
  return(hijos)
}

############################
#### Función principal ####
#### Parámetros de inicio ####
#problema = 1 # Problema a resolver (1 o 2)
#pobsize = 30 # Tamaño de la población inicial
#ngen = 1200 # Número de generaciones
#PC = 0.8 # Porcentaje de cruza
#PM = 0.1 # Porcentaje de mutación
#tol = 3 # Tolerancia permitida
#Dn = 10 # Numero de dimensiones
#mostrar = 0 # Parametro para mostrar el resultado
# Parametro adicional #

optimizar = function(problema,pobsize,ngen,PC,PM,mostrar = 0,Dn = 10){
  # Esto se genera solo
  nbits = n_bits(problema) # Cantidad de bits a usar
  # Contadores del proceso #
  contadoreval = 0 # Contador de evaluaciones
  ngenaux = 0 # Contador de generaciones
  mejorsol = c() # Guardar la aptitud de la mejor solución
  ### Inicializar los reportes como dataframes ###
  # Reporte interno #
  reporte = data.frame(gen = 1,apt = 0.1, eval = 1 )[-1,]
  # Reporte para mostrar #
  reporteUS = data.frame(gen = integer(), 
                         apt = numeric(),
                         matrix(nrow = 0, ncol = Dn))
  colnames(reporteUS)[-(1:2)] = paste0("X", 1:Dn)
  
  ### 1.- Inicializar la población y evaluar sus aptitudes solo una vez ####
  poblacion = pob(pobsize,problema,nbits, Dn = 10)
  aptitudes = apply(poblacion,1,fx,problema,nbits)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos
  ### PARA EL REPORTE US ###
  # Ordenar las aptitudes
  mapt = which.min(aptitudes)
  # Decoficar al sujeto antes de introducirlo #
  decosuj = db2r(poblacion[mapt,],problema,nbits)
  sujetom =  cbind.data.frame(ngenaux,aptitudes[mapt],t(decosuj))
  reporteUS[ngenaux+1,] = sujetom
  
  ### Para el reporte interno ###
  # Agregar al reporte la solución inicial #
  mejorsol[ngenaux + 1] = min(aptitudes) # Mejor solución por generación
  isj = c(ngenaux,mejorsol[ngenaux + 1],contadoreval)
  reporte[ngenaux + 1,] = isj
  ### Aquí inicia el ciclo while ###
  # Caso 1: La mejor solución esta en la población inicial
  if (mejorsol[1] == 0) {
    # Mostrar progreso
    print("Terminó al inicio con la solución óptima:")
  } else {
    # Bucle para iterar el genetico
    # Condición de respaldo tolerancia
    #min(aptitudes) > (10^-tol)
    while (ngenaux < ngen ){
      # Aplicar el elitismo de forma discreta
      elite =  c(min(aptitudes),poblacion[which.min(aptitudes),])
      ### 2.- Seleccionar a los padres ####
      ganadores = padreselect(pobsize,aptitudes)
      ### 3.- Operador de CRUZA
      hijos = cruza(ganadores, poblacion,PC)
      ### 4.- Operador de mutación
      hijosm = mutacion(hijos, PM)
      ## 5.- Generar a la nueva población ##
      poblacion = hijosm
      # 6.- Evaluar SOLO los hijos
      aptitudes = apply(poblacion,1,fx,problema,nbits)
      contadoreval = contadoreval + length(aptitudes)  
      # Agregar la mejor solución de la población y eliminar a la peor
      mj = which.max(aptitudes)
      poblacion[mj,] = elite[-1]
      aptitudes[mj] = elite[1]
      # Actualizar generación# 
      ngenaux = ngenaux + 1
      ## Guardar progreso para ##
      ## PARA EL REPORTE US ##
      # Ordenar las aptitudes
      # Ordenar las aptitudes
      mapt = which.min(aptitudes)
      # Decoficar al sujeto antes de introducirlo #
      decosuj = db2r(poblacion[mapt,],problema,nbits)
      sujetom =  cbind.data.frame(ngenaux,aptitudes[mapt],t(decosuj))
      reporteUS[ngenaux+1,] = sujetom
      
      ### Para el reporte interno ###
      # Agregar al reporte la solución inicial #
      mejorsol = min(aptitudes) # Mejor solución por generación
      isj = c(ngenaux,mejorsol,contadoreval)
      reporte[ngenaux + 1,] = isj
    }
  }
  # Reportar los resultados internos #
  reporte = round(reporte,4)
  # Reportar los resultados externos
  reporteUS = round(reporteUS,4)
  # Ciclo para proyectar 
  if(mostrar==1){
    # Mostrar todo desde el primer sujeto para reporte us
    for(i in 1:ngen){
      print(round(reporteUS[i,],3))
    }
  }else{
    # Proyectar solo el primero y el ultimo de la corrida
    for(i in c(1,ngen)){
      print(round(reporteUS[i,],3))
    } 
  }
  # Devolver los reportes
  # Reporte int para mis debugeos 
  # ReporteUS para proyectarlo y sacar estadísticas 
  return(list(reporteint = reporte,reporteUS = reporteUS))
}
  
