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




#### Función principal ####
#### Parámetros de inicio ####
problema = 1 # Problema a resolver (1 o 2)
pobsize = 30 # Tamaño de la población inicial
ngen = 2000# Número de generaciones
PC = 0.8 # Porcentaje de cruza
PM = 0.1 # Porcentaje de mutación
b = 0.001 # Parametro para el laplaciano
tol = 3 # Tolerancia permitida
Dn = 10 #Parametro Dn para las dimensiones
mostrar = 0 # Parametro para mostrar el resultado


optimizar = function(problema,pobsize,ngen,PC,PM,b,tol,Dn = 10,mostrar = 1){
  # Contadores del proceso #
  contadoreval = 0 # Contador de evaluaciones
  ngenaux = 0 # Contador de generaciones
  mejorsol = c() # Guardar la aptitud de la mejor solución
  #### Convertir el reporte interno en un data frame ####
  reporte = as.data.frame(matrix(0,nrow = 1,ncol = 3))[-1,] # Reporte interno
  ## REPORTE US PARA MOSTRAR POR ITERACIÓN ##
  reporteUS = as.data.frame(matrix(0,nrow = 1,ncol = Dn+2)[-1,])
  
  ### 1.- Inicializar la población y evaluar sus aptitudes solo una vez ####
  poblacion = pob(pobsize,problema,Dn)
  aptitudes = apply(poblacion,1,fx,problema)
  contadoreval = contadoreval + pobsize  # Se evaluaron pobsize sujetos
  mejorsol[ngenaux + 1] = min(aptitudes) # Guardar las soluciones a lo largo del tiempo
  ## PARA EL REPORTE US ##
  # Ordenar de mejor a peor
  pobapt = round(cbind(ngenaux,aptitudes,poblacion),3)
  # Mostrar el mejor #
  reporteUS = rbind.data.frame(reporteUS,pobapt[order(pobapt[,2]),][1,])
  colnames(reporteUS) = NULL
  print(reporteUS[1,])
  # Agregar al reporte la solución inicial #
  reporte = rbind.data.frame(reporte,c(ngenaux,mejorsol[ngenaux + 1],contadoreval))
  ### Aquí inicia el ciclo while ###
  # Caso 1: La mejor solución esta en la población inicial
  if (mejorsol[1] == 0) {
    # Mostrar progreso
    print("Terminó al inicio con la solución óptima:")
  } else {
    # Bucle para iterar el genetico
    while (min(aptitudes) > (10^-tol) & ngenaux < ngen ){
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
      # Actualizar generación# Actualizar y reportar #
      ngenaux = ngenaux + 1
      mejorsol[ngenaux + 1] = min(aptitudes)
      # Mostrar progreso #
      ## PARA EL REPORTE US ##
      # Ordenar de mejor a peor
      pobapt = round(cbind(ngenaux,aptitudes,poblacion),4)
      # Mostrar el mejor #
      reporteUS = rbind.data.frame(reporteUS,pobapt[order(pobapt[,2]),][1,])
      # Reportar #
      colnames(reporteUS) = NULL
      # Condición para reportar o no
      if(mostrar==1){print(reporteUS[reporteUS[,1]==ngenaux,])}
      ## Reporte interno ##
      mejor_individuo = poblacion[which.min(aptitudes),]
      reporte = rbind.data.frame(reporte, c(ngenaux, mejorsol[ngenaux + 1], contadoreval))
    }
  }
  # Reportar los resultados internos #
  colnames(reporte) = c("gen","apt","eval")
  reporte = round(reporte,4)
  # Reportar los resultados externos
  colnames(reporteUS) = c("gen","apt",paste0("X",1:Dn) )
  return(list(reporteint = reporte,reporteUS = reporteUS))
}


#### REPORTERIA ####
#### Parámetros de inicio ####
problema = 1 # Problema a resolver (1 o 2)
pobsize = 30 # Tamaño de la población inicial
ngen = 2000# Número de generaciones
PC = 0.8 # Porcentaje de cruza
PM = 0.1 # Porcentaje de mutación
b = 0.001 # Parametro para el laplaciano
tol = 3 # Tolerancia permitida
Dn = 10 #Parametro Dn para las dimensiones
mostrar = 0

#### Correr el algoritmo 30 veces ####
cn = 30
problema = 2
recopilar = matrix(0,nrow = 1,ncol = 2 + Dn )[-1,]

for(i in 1:cn){
  # Obtener con los mismos parametros #
  aux = optimizar(problema,pobsize,ngen,PC,PM,b,tol ,Dn,mostrar)$reporteUS
  # Ordenar respecto a la aptitud y tomar al primero
  recopilar = rbind(recopilar,aux[nrow(aux),])  
}

salida = optimizar(problema,pobsize,ngen,PC,PM,b,tol ,Dn,mostrar)
salida$reporteUS
plot(salida$reporteUS[,2])
salida$reporteUS[,2] |> min()
salida$reporteUS[,]
salida$reporteUS[,2]

#### Prueba de wilcoxon ####

datos1 = read.csv("eva.csv")
datos2 = read.csv("eva2.csv")

ex = data.frame(apt = c(datos1$apt,datos2$apt),probl = factor(rep(c("P1","P2"),each = 30)))

wilcox.test(ex$apt~ex$probl)


tapply(ex$apt,ex$probl,shapiro.test)










head(reporte$reporteint)
head(reporte$reporteUS)
plot(reporte$reporteint[,2],type = "l")
min(reporte$reporteint [,2])
max(reporte$reporteint [,1])
