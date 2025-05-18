rm(list=ls())
# Fijar que Dn = 10
# Pero permitir que pueda variar

#### Funciones necesarias para que funcione ####
# Función para generar el Beta
generar_beta <- function(a, b) {
  # Generar un aleatorio uniforme
  u <- runif(1)
  # Decicir cual caso aplicar #
  if (u <= 0.5) {
    return(a - b * log(u))
  } else {
    return(a + b * log(u))
  }
}

#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
sol1 = function(Dn = 10,problema){
  # Crear un vector de tamaño Dn
  ## Para el problema 1
  if(problema == 1){
    # Con uniforme  entre [-10, 10]
    sol = runif(Dn,min = -10,max =  10)
    # Devolver la solución
    return(sol)
    ## Para el problema 2
  }else{
    # Con uniforme  entre [-5.12, 5.12]
    sol = runif(Dn,min = -5.12,max =  5.12)
    # Devolver la solución
    return(sol)
  }
}
# Generador de la población #
pob = function(n,problema, Dn = 10){
  # Generar una solución base
  pob1 = sol1(Dn,problema)
  # Generar n-1 soluciones #
  for(i in 1:(n-1)){
    # Agregar n-1 soluciones
    pob1 = rbind(pob1,sol1(Dn,problema))
  }
  # Reportar la salida de posibles soluciones #
  # Cambiar los nombres
  row.names(pob1) = NULL
  # Reportar la población generada #
  # Devolver la solución
  return(pob1)
}

#### 2.- Funciónes de aptitud 1 y 2 ####
#problema: selector entre problema 1 o 2
# Si es problema 1, el valor varia en [-10,10]
# Si es problema 2, el valor varia en [-5.12,5.12]
fx = function(X,problema){
  # Caso para el problema 1
  if(problema==1){
    # Cada valor al cuadrado se eleva y se suma.
    res = sum(X^2)
    return(res)
  }else{
    # PARTE CONSTANTE
    D = length(X)
    dc = 10*D
    # Parte de la suma de cosenos
    pc = sum(X^2 - 10*cos(2*pi*X))
    # Resultado
    res = dc + pc
    return(res)
  }
}

### 3.- Selector de padres por torneo binario determinista ####
# Aptitudes = Vector que contiene las aptitudes de los individuos
# indices = Vector que indica a que sujeto corresponde cada aptitud
padreselect = function(pb,aptitud){
  # seleccionar pobsize padres
  # Vector para guardar a los seleccionados
  ganadores = c()
  # Aplicarlo para generar a la nueva población #
  for(i in 1:pobsize){
    # Seleccionar 2 padres aleatorios
    peleadores = sample(1:pobsize,2)
    # Seleccionar al que minimiza más la aptitud
    # Compara a ambos peleadores, selecciona la posición del que minimiza la función
    # y devuelve dicha posición de entre las 2.
    ganadores[i] = peleadores[which.min(aptitud[peleadores])]  
  }
  # Devolver el vector de ganadores
  return(ganadores)
}

### 4.- Aplica el operador de cruza ####
# ganadores = Padres seleccionados en el paso 3
# pb = poblacion
# PC = Porcentaje de cruza
cruza = function(ganadores, pb,PC,b){
  # Renombrar la población #
  poblacion = pb
  # Calcular la cantidad de ganadores #
  Di = length(ganadores)
  # Obtener la cantidad de parejas individuos
  ndp =  Di/2
  # Hacer random los vectores de padres
  selectos = sample(1:Di,Di)
  A1 = selectos[1:(Di/2)]
  A2 = selectos[(Di/2+1):Di]
  # Barajar y emparejar
  P1 = sample(A1)
  P2 = sample(A2)
  parejas = cbind(P1, P2)
  # Determinar quiénes se cruzan con volados
  Reproduce = rbinom(nrow(parejas), 1, PC)
  parejas = cbind(parejas, Reproduce)
  # Generar 2 hijos por pareja
  hijos = matrix(0,nrow = Di, ncol = 10)
  # Aplicar el ciclo para generar hijos #
  for (i in 1:(nrow(parejas))) {
    # Preparar a los padres por iteración #
    padre1 = poblacion[parejas[i, 1], ]
    padre2 = poblacion[parejas[i, 2], ]
    # Caso donde no se cruzan #
    if (parejas[i, 3] == 0) {
      # Si no se cruzan, cada padre se clona en un hijo
      hijos[(2 * i - 1),] = padre1
      hijos[(2 * i),] = padre2
    } else {
      ### Se genera un nuevo numero por cada dimensión ##
      #b = 0.15
      for(j in 1:10){
        # Generar un valor del laplaciano para cada hijo
        # con alfa = 0 y b fijo
        betas = generar_beta(0, b)
        # Generar a los hijos 
        hijos[(2*i - 1),j] = padre1[j] + betas*abs(padre1[j] - padre2[j])
        hijos[(2*i),j] = padre2[j] + betas*abs(padre1[j] - padre2[j])
      }
    }
  }
  ### Reparador de hijos ###
  ## Verificar que los hijos no se salgan de los rangos ##
  # Para los que se pasan del +10, fjarlos en 10
  hijos[hijos>10] = 10 
  # Para los que se pasan del -10, fjarlos en -10
  hijos[hijos<(-10)] = -10
  return(hijos)
}

### 5.- Operador de cruza ###
mutacion = function(hijos, PM){
  # Para el hijo i-esimo
  for(i in 1:nrow(hijos)){
    # Lanzar los volados con PM de mutación por atributo
    nh = ncol(hijos)
    muta = rbinom(nh, 1, PM)
    # Generar un vector de valores uniformes
    vu = runif(sum(muta),min = -10, max = 10 )
    # Aplicar la mutación sobre los vectores
    hijos[i,muta==1] = vu
  }
  # Devolver a los hijos mutados
  return(hijos)
}





#### Función principal ####
#### Parámetros de inicio ####
problema = 1 # Problema a resolver (1 o 2)
pobsize = 50 # Tamaño de la población inicial
PC = 0.7 # Porcentaje de cruza
PM = 0.1 # Porcentaje de mutación
b = 0.1 # Parametro para el laplaciano
LIM = 10000 # Criterio de paro: Evaluaciones 10,000 o solución encontrada
# Parametro adicional #
# Dn

optimizar = function(problema,pobsize,PC,PM,Dn = 10){
  
  # Contadores del proceso #
  contadoreval = 0
  ### 1.- Inicializar la población y evaluar sus aptitudes solo una vez ####
  poblacion = pob(pobsize,problema)
  aptitud = apply(poblacion,1,fx,problema)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos
  ### 2.- Seleccionar a los padres ####
  ganadores = padreselect(poblacion,aptitud)
  ### 3.- Operador de CRUZA
  hijos = cruza(ganadores, poblacion,PC,b)
  ### 4.- Operador de mutación
  hijos = mutacion(hijos, PM)
  ## 5.- Generar a la nueva población ##
  poblacion = hijos
  min(aptitud)
  
  # Actualizar generación
  ngen = ngen + 1
  mejorsol[ngen + 1] = min(aptitudes)

}



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
