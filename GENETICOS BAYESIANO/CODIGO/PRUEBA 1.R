
#### Calculo del MDL ####
# Entrada: DataFrame y matriz de Adyacencias 
# Salida: Calculo del MDL
mdl = function(adj_matrix, data) {
  # Verificar que entra un data frame#
  stopifnot(is.data.frame(data))
  # Variables del dataframe
  vars = colnames(data)
  # Cantidad de filas
  n = nrow(data)
  # Acumulador del MDL
  total_mdl = 0
  # Aplicar ciclo a lo largo de la red
  for (i in seq_along(vars)) {
    # Probar con la variable i-esima
    xi = vars[i]
    # Tomar en cuenta los niveles del conjunto de datos
    xi_values = levels(data[[xi]])
    # Contar cuantos posibles valores son #
    ri = length(xi_values)
    
    # Detectar a los padres de Xi
    parent_idxs = which(adj_matrix[, i] == 1)
    parents = vars[parent_idxs]
    # Contabilizar por padres #
    if (length(parents) == 0) {
      # No tiene padres: solo frecuencia marginal
      counts = table(data[[xi]])
      probs = counts / sum(counts)
      LL = sum(counts * log2(probs))
      q_i = 1
    } else {
      # Tiene padres
      grouped = aggregate(rep(1, n), by = c(data[parents], data[xi]), FUN = length)
      colnames(grouped)[ncol(grouped)] = "count"
      # Calcular N_ijk y N_ij
      parent_combos = grouped[, parents, drop = FALSE]
      joint_combos = grouped[, c(parents, xi), drop = FALSE]
      key = apply(joint_combos[, parents, drop = FALSE], 1, paste0, collapse = "|")
      grouped$parent_key = key
      # Agrupar por combinación de padres (N_ij)
      Nij = aggregate(grouped$count, by = list(grouped$parent_key), FUN = sum)
      names(Nij) = c("parent_key", "Nij")
      # Agrupar de forma limpia evitando duplicados
      grouped_clean = grouped[, !(colnames(grouped) %in% colnames(Nij) & colnames(grouped) != "parent_key")]
      merged = merge(grouped_clean, Nij, by = "parent_key")
      merged$prob = merged$count / merged$Nij
      LL = sum(merged$count * log2(merged$prob))
      
      q_i = nrow(unique(grouped[, parents, drop = FALSE]))
    }
    
    # Penalización por complejidad
    penalty = 0.5 * log2(n) * (ri - 1) * q_i
    mdl_i = -LL + penalty
    total_mdl = total_mdl + mdl_i
  }
  # Reportar el MDL obtenido
  return(total_mdl)
}

#### Categorizar los datos ####
# Entrada: Dataframe discretizado
# Salida: Dataframe convertido en factor por variable
cate = function(X){
  # Ciclo para volver todo categorias #
  for(i in 1:ncol(X)){
    # Convertir la variable a factor
    X[,i] = as.factor(X[,i])
  }
  # Devolver el resultado
  return(X)
}

#### Función para crear una matriz de adyacencias ####
# Entrada: un dataset 
# Salida: Una matriz de Adyacencias 
adjmat = function(X){
  # Obtenr la cantidad de variables p
  p = ncol(X)
  # Crear una matriz de adyacencias de tamaño PxP
  adj_matrix = matrix(0, nrow = p, ncol = p)
  colnames(adj_matrix) = rownames(adj_matrix) = names(X)
  # Agrega P aristas random
  for(i in 1:p){
    # Agregar a la matriz de adyacencias #
    adj_matrix[sample(1:p,1),sample(1:p,1)] = 1
  }
  # Devolver el resultado #
  return(adj_matrix)
}



#### Revisar aciclidiad ####
aciclicidad = function(adj_matrix) {
  # Revisar la cantidad de filas #
  n = nrow(adj_matrix)
  # Copiar la matriz de adyacencias
  power_mat = adj_matrix
  # Acumulador 
  total_mat = adj_matrix 
  # Ciclo for para revisar que se cumpla la aciclicidad
  for (k in 2:n) {
    # Aplicar el cuadrado de la matriz
    power_mat = power_mat %*% adj_matrix  # A^k
    # Primera condición, que no haya valores en la diagonal
    if (any(diag(power_mat) > 0)) {
      return(FALSE)  # ciclo detectado
    }
    # Contar los caminos
    total_mat = total_mat + power_mat
  }
  return(TRUE)  # si nunca hubo ciclo
}


#### Generar sujeto ###
# Se representa la matriz de adyacencia
# Como un solo vector
# Entra: La cantidad N de variables del dataframe
# Sale: Un vector con valores 0 y 1 de tamaño n^2
sujeto =  function(n) {
  # Crea una matriz de n x n con valores aleatorios entre 0 y 1
  mat = matrix(runif(n * n), nrow = n, ncol = n)
  # Eliminar autoloops (diagonal = 0)
  diag(mat) = 0
  # Convertir en vector por filas (flatten row-wise)
  return(as.vector(t(mat)))
}

#### Decodificar al sujeto ####
# Entrada: sujeto generado de la población
# Salida: Una matriz de adyacencias por sujeto
decodificar = function(sujeto, umbral = 0.5) {
  ## Contar cuantos elementos hay en el vector sujeto ##
  n = sqrt(length(sujeto))
  if (n %% 1 != 0) stop("No es una matriz cuadrada")
  # Convertir el vector en matriz por filas
  mat = matrix(sujeto, nrow = n, byrow = TRUE)
  # Aplicar umbral sobre los valores de la matriz
  adj = (mat > umbral) * 1
  # Asegurar que no haya autoloops
  diag(adj) = 0
  # Agregar los nombres 
  rownames(adj) = colnames(adj) = nombres
  # Devolver la matriz de adyacencias
  return(adj)
}

#### Generador de la población ####
# Entradas:
  #n = tamaño del sujeto
  #tamaño = Tamaño de la población
# Salida: Una lista de vectores que representan a los sujetos
pob = function(n, tamaño) {
  # Crear un vector lista de tamaño pobsize
  poblacion = vector("list", tamaño)
  # Aplicar un ciclo para guardar cada sujeto como 
  for (i in 1:tamaño) {
    poblacion[[i]] = sujeto(n)
  }
  return(poblacion)
  
}

#### Evaluar el fitnes poblacional ####
evaluarpob = function(poblacion, data, umbral){
  # Crear el vector lista de tamaño igual a la población
  evaluada = vector("list", length(poblacion))
  # Hacer el ciclo sobre cada elemento de la población
  for (i in seq_along(poblacion)) {
    # Extraer el sujeto i-esimo
    sujeto = poblacion[[i]]
    # Convertiro a su forma de matriz de adyacencias
    # Y desfuzzificado #
    adj = decodificar(sujeto, umbral)
    # Revisar la aciclicidad de la cosa
    if(aciclicidad(adj)==F){
      # Penalización si el sujeto no es valido #
      fitness = Inf  # penalización por ser inválido
    } else {
      # Computar el mdl si el sujeto es valido
      fitness = mdl(adj, data)
    }
    # Agregar a cada sujeto su fitnes y su matriz de adyacencia transformada
    evaluada[[i]] = list(
      vector = sujeto,
      adj = adj,
      fitness = fitness
    )
  }
  return(evaluada)
}

#### Seleccionar a los elites ####
seleccion = function(poblacion_eval, pe){
  # Tamaño de la población 
  pobsize = length(poblacion_eval)
  # Selección de cuantos de la elite seran seleccionados #
  cantidad_elite = ceiling(pe*pobsize)
  # Ordenarlos en función de su fitnes
  ordenados = poblacion_eval[order(sapply(poblacion_eval, function(x) x$fitness))]
  # Seleccionar a los elites
  elites = ordenados[1:cantidad_elite]
  # Devolver solo los indices elites
  return(elites)
}

#### Generar las mutaciones ####
mutantes = function(cantidad, n){
  # Vector de tamaño pobsize
  mutantes = vector("list", cantidad)
  # Aplicar sobre cada posible nuevo sujeto #
  for (i in 1:cantidad) {
    # Crea un sujeto nuevo
    vec = sujeto(n)
    # Guardaa su matriz de adyacencia decodificada
    adj = decodificar(vec,umbral)
    # Guardar los mutantes nuevos y sin evaluar#
    mutantes[[i]] = list(
      vector = vec,
      adj = adj,
      fitness = NA  # se evaluarán luego
    )
  }
  return(mutantes)
}

#### Operador de cruza SESGADO ####
cruza = function(elite, no_elite, rho = 0.7){
  #Verificar si las longitudes coinciden#
  if (length(elite) != length(no_elite)) {
    stop("Longitud de cromosomas no coincide")
  }
  # Se crea un vector vacio del tamaño de los padres #
  hijo = numeric(length(elite))
  # Para cada uno de los elementos del vector hijo 
  for (i in 1:length(elite)) {
    # Si es menor que el umbral rho/p, toma del elite
    if (runif(1) < rho) {
      hijo[i] = elite[i]
    # Si no, toma del no-elite
    } else {
      hijo[i] = no_elite[i]
    }
  }
  
  return(hijo)
}

#### Generador de hijos con cruza sesgada ####
generar_hijos = function(elites, no_elites, cantidad_hijos, rho = 0.7){
  # Vector lista par guardar a los hijos #
  hijos = vector("list", cantidad_hijos)
  # Ciclo para cada uno de los posibles hijos #
  for (i in 1:cantidad_hijos) {
    # Seleccionar elite y no-elite al azar
    elite = sample(elites, 1)[[1]]$vector
    no_elite = sample(no_elites, 1)[[1]]$vector
    
    # Crossover sesgado
    hijo_vec = cruza(elite, no_elite, rho)
    
    # Decodificación
    hijo_adj = decodificar(hijo_vec,umbral)
    
    # Guardar hijo (sin evaluar aún)
    hijos[[i]] = list(
      vector = hijo_vec,
      adj = hijo_adj,
      fitness = NA
    )
  }
  
  return(hijos)
}

#### Crear a la siguiente generación ####
nuevapob = function(poblacion_eval, n, 
                     tamano_total,porcentaje_elite = 0.2,
                     porcentaje_mutante = 0.2,rho = 0.7){
  # Obtener la cantidad de sujetos elite
  cantidad_elite = ceiling(porcentaje_elite * tamano_total)
  # Definir la cantidad de mutantes 
  cantidad_mutante = ceiling(porcentaje_mutante * tamano_total)
  # Definir la cantidad de hijos resultantes
  cantidad_hijos = tamano_total - cantidad_elite - cantidad_mutante
  # 1. Selección
  elites = seleccion(poblacion_eval, porcentaje_elite)
  no_elites = setdiff(poblacion_eval, elites)
  # 2. Generación
  hijos = generar_hijos (elites, no_elites, cantidad_hijos, rho = rho)
  mutantes = mutantes(cantidad_mutante, n)
  # 3. Unir todos
  nueva_pob = c(elites, hijos, mutantes)
  return(nueva_pob)
  }


