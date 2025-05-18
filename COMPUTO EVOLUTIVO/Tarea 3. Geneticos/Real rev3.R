rm(list=ls())

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
  pob1 = matrix(0, nrow = n, ncol = Dn)
  for(i in 1:n){
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
  selectos = sample(1:Di,Di)
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
      ### Se genera un nuevo numero por cada dimensión ##
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
  ## Caso para el problema 1
  if(problema==1){
    ## Verificar que los hijos no se salgan de los rangos ##
    # Para los que se pasan del +10, fiarlos en 10
    hijos[hijos>10] = 10 
    # Para los que se pasan del -10, fiarlos en -10
    hijos[hijos<(-10)] = -10
  }else{
    # Caso para el problema 2
    ## Verificar que los hijos no se salgan de los rangos ##
    # Para los que se pasan del +5.12, fiarlos en 5.12
    hijos[hijos>5.12] = 5.12
    # Para los que se pasan del -5.12, fiarlos en -5.12
    hijos[hijos<(-5.12)] = -5.12
  }
  # Devolver a los hijos
  return(hijos)
}

### 5.- Operador de mutacion ###
mutacion = function(hijos, PM,problema){
  ## Caso para el problema 1
  if(problema==1){
    ## Verificar que los hijos no se salgan de los rangos ##
    # Para los que se pasan del -10, fiarlos en -10
    # Para los que se pasan del +10, fiarlos en 10
    limites = c(-10,10)
  }else{
    # Caso para el problema 2
    ## Verificar que los hijos no se salgan de los rangos ##
    # Para los que se pasan del +5.12, fiarlos en 5.12
    # Para los que se pasan del -5.12, fiarlos en -5.12
    limites = c(-5.12,5.12)
  }
  
  # Establecer el número de dimensiones del vector
  nh = ncol(hijos)
  # Para el hijo i-esimo
  for(i in 1:nrow(hijos)){
    # Lanzar los volados con PM de mutación por atributo
    muta = rbinom(nh, 1, PM)
    # Generar un vector de valores uniformes
    vu = runif(sum(muta),min = limites[1] , max = limites[2] )
    # Aplicar la mutación sobre los vectores
    hijos[i,muta==1] = vu
  }
  # Devolver a los hijos mutados
  return(hijos)
}
