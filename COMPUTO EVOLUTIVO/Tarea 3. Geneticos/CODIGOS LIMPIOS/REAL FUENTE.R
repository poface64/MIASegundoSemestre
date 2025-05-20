# Fijar que Dn = 10
# Pero permitir que pueda variar
#### Funciones necesarias para que funcione ####
# Función para generar el Beta
generar_beta <- function(a, b) {
  # Generar un aleatorio uniforme
  u <- runif(1)
  # Decidir cual caso aplicar
  if (u <= 0.5) {
    return(a + b * log(2 * u))     # Negativo
  } else {
    return(a - b * log(2 * (1 - u)))  # Positivo
  }
}

#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
sol1 = function(Dn = 10,problema){
  # Para el problema 1 o problema 2
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  # Crear un vector de tamaño 
  sol = runif(Dn,min = limites[1],max =  limites[2])
  # Devolver la solución en función del problema
  return(sol)
}

# Generador de la población #
pob = function(pobsize,problema, Dn = 10){
  # Matriz para guardar a la población
  pob1 = matrix(0, nrow = pobsize, ncol = Dn)
  # Crear pobsize sujetos para PROBLEMA y guardarlos
  for(i in 1:pobsize){
    pob1[i,] = sol1(Dn, problema)
  }
  # Reportar la población generada #
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
    # Caso para el problema 2 #
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
padreselect = function(pobsize,aptitud){
  # seleccionar pobsize padres
  # Vector para guardar a los seleccionados
  ganadores = c()
  # Aplicarlo para seleccionar a los nuevos individuos #
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
cruza = function(ganadores, poblacion,PC,b,problema){
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
    if (parejas[i, 3] == 0) {
      # Si no se cruzan, cada padre se clona en un hijo
      hijos[(2 * i - 1),] = padre1
      hijos[(2 * i),] = padre2
    } else {
      ## Se genera un nuevo numero por cada dimensión ##
      #b = 0.15
      for(j in 1:np){
        # Generar un valor del laplaciano para cada hijo
        # con alfa = 0 y b fijo
        betas = generar_beta(0, b)
        # Calcular la diferencia
        dife = abs(padre1[j] - padre2[j])
        # Generar a los hijos 
        hijos[(2*i - 1),j] = padre1[j] + betas*dife
        hijos[(2*i),j] = padre2[j] + betas*dife
      }
    }
  }
  ### Reparador de hijos ###
  # Selecciona los limites Para el problema 1 o problema 2
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  # Reparar a los hijos si exceden el umbral dependiendo el problema #
  ## Verificar que los hijos no se salgan de los rangos ##
  # Topar al limite inferior
  hijos[hijos<limites[1]] = limites[1]
  # Topar al limite superior
  hijos[hijos>limites[2]] = limites[2] 
  # Devolver a los hijos
  return(hijos)
}

### 5.- Operador de mutacion ###
mutacion = function(hijos, PM,problema){
  # Selecciona los limites Para el problema 1 o problema 2
  limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
  # Establecer el número de dimensiones del vector
  nh = ncol(hijos)
  # Para el hijo i-esimo
  for(i in 1:nrow(hijos)){
    # Lanzar los volados con PM de mutación por atributo
    muta = rbinom(nh, 1, PM)
    # Generar un vector de valores uniformes
    vu = runif(sum(muta),min = limites[1] , max = limites[2])
    # Aplicar la mutación sobre los vectores
    hijos[i,muta==1] = vu
  }
  # Devolver a los hijos mutados
  return(hijos)
}

#### Codigo principal ####
optimizar = function(problema,pobsize,ngen,PC,PM,b,tol,Dn = 10,mostrar = 1){
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
  poblacion = pob(pobsize,problema,Dn)
  aptitudes = apply(poblacion,1,fx,problema)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos

  ### PARA EL REPORTE US ###
  # Ordenar las aptitudes
  mapt = which.min(aptitudes)
  sujetom =  cbind.data.frame(ngenaux,aptitudes[mapt],t(poblacion[mapt,]))
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
      hijos = cruza(ganadores, poblacion,PC,b,problema)
      ### 4.- Operador de mutación
      hijosm = mutacion(hijos, PM,problema)
      ## 5.- Generar a la nueva población ##
      poblacion = hijosm
      # 6.- Evaluar SOLO los hijos
      aptitudes = apply(poblacion,1,fx,problema)
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
      mapt = which.min(aptitudes)
      sujetom =  cbind.data.frame(ngenaux,aptitudes[mapt],t(poblacion[mapt,]))
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


