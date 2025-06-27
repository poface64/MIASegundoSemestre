#### Función para identificar cual es la variable con las clases y separar ####
# los atributos de la variable de clases #
# datos = Matriz de datos
# VarClas = Nombre exacto de la variable que contiene las clases
detector = function(datos,VarClas){
  # Guardar los indices originales y los nombres
  indices = 1:ncol(datos)
  nombres = names(datos)
  # Identificar del conjunto el indice de la variable
  idClass = which(names(datos)==VarClas,nombres)
  # Regresar el conjunto de indices de los atributos F_i
  atributos = setdiff(indices,idClass)
  atributos1 = atributos
  # Identificar variables que sean valores numericos
  for(i in 1:length(atributos) ){
    # Si la variable es NO numerica, sacala del conjunto
    if((class(datos[,atributos[i]])== "numeric" | class(datos[,atributos[i]])== "integer")){
      # Todo bien
    }else{
      # Quita esa variable de los atributos
      atributos1 = setdiff(atributos1,atributos[i])
    }
  }
  # junto con la posición donde esta la clase
  resultado = c(Atributos=atributos1,Clase = idClass)
  return(resultado)
}

#### Función CAIMp para calcular el CAIM a partir de la matriz Cuanta ####
# Inter = Valores discretizados por los intervalos propuestos
# Clase = La cantidad de clases que hay en variable de clase
CAIMp = function(Inter,clase){
  #Sacar la matriz Quanta base con sus marginales
  quanta = addmargins(table(Clase = clase,Intervalo = Inter))
  # Dimensiones de la cuanta
  DQ = dim(quanta)
  # Sacar el critero de CAIM con un for
  SumaC = 0
  for(i in 1:(DQ[2]-1)){ # La cantidad de intervalos -1 para evitar el marginal
    # Extraer el maximo de la columa i-esima
    SumaC = SumaC + max(quanta[-DQ[1],i]^2/quanta[DQ[1],i])
  }
  CAIMr = SumaC/(DQ[2]-1) #Le quito la columna del marginal
  # Devolver el valor del CAIM para este esquema
  return(CAIMr)
}

#### FUNCIÓN CAIM COMPLETA PARA DISCRETIZAR ####
CAIM = function(datos,VarClas){
  # Primero aplica el detector para identificar a la variable clase
  # de los atributos y quitar las variables NO numéricas
  detecta = detector(datos,VarClas)
  # Separa la clase
  ClaseS = detecta[length(detecta)]
  # Separa los atributos considerados numéricos
  atributos = setdiff(detecta,ClaseS)
  # Ya tengo separativos los atributos y la variable clase
  #### Inicializar el algoritmo para que itere sobre cada variable ####
  # Genero los objetos con los resultados que van a ser guardados para la salida
  resultados = list()
  # Aplicar esto para el atributo i-esimo
  for(i in atributos){ # Moverse sobre todos los indices de atributos validos
    #### PASO 1 ####
    # Paso 1.1 Encuentra el valor máximo (dn) y el valor mínimo(d0) del atributo
    d0 = min(datos[,i],na.rm = T )
    dn = max(datos[,i],na.rm = T)
    # Paso 1.2 Forma un conjunto de todos los valores distintos de F_i en orden
    # ascendente, inicializa todos los posibles limites de los intervalos B con
    # minimo, maximo y todos los puntos medios de todas las parejas adyacentes
    unicos = sort(unique(datos[,i]))
    B = c()
    # Sacar las parejas
    for(pi in 2:length(unicos)){
      # Sacar las mitades
      B[pi-1] = (unicos[pi]+unicos[pi-1])/2
    }
    ### Paso 1.3 Define el esquema de discretización inicial como D: {[d0,dn]}
    # y define el GlobalCaim = 0#
    D = c(d0,dn) # Esquema de discretización base
    GlobalCaim = 0 #Global Caim Base
    #### PASO 2 ####
    # Paso 2.1 Inicializa k = 1
    k = 1
    # Inicializo otras variables para hacer funcionar el while
    maxCaim = 0
    while((maxCaim > GlobalCaim) | (k<length(unique(datos[,ClaseS])))){
      # 2.2 Tentativamente agrega un intervalo interno de B,
      # el cual no se encuentre en D y calculale el correspondiente CAIM
      # Indices de CAIM para elegir un esquema
      ICAIM = c()
      # Ciclo para probar con todas las posibles mitades como candidatos
      # a ser parte del esquema
      for(posi in 1:length(B)){
        # Crea el esquema i-esimo
        Di = sort(c(D,B[posi]))
        # Discretiza con el esquema i-esimo
        Inter = cut(datos[,i],
                    breaks = Di,
                    include.lowest = TRUE,
                    right = TRUE)
        # Calcula el CAIM
        ICAIM[posi] = CAIMp(Inter,datos[,ClaseS])
      }
      # 2.3 Una vez probadas todas las adiciones provisionales,
      # aceptar la que tenga el valor más alto de de CAIM
      # Extraigo el indice máximo y de caim y su posición
      maxCaim = max(ICAIM) # Maximo Caim en la iteración i-esima
      maxCaimPos = which.max(ICAIM) # Posición del maximo Caim
      #2.4 Si (CAIM > GlobalCAIM O k<S) Actualiza D con la propuesta
      #de intervalo aceptada en el paso 2.3 y configura GlobalCAIM = CAIM,
      #si no termina
      # Actualizar el esquema
      D = sort(c(D,B[maxCaimPos])) # Actualización del esquema
      #Quito el valor seleccionado de la bolsa de mitades B
      B = B[-maxCaimPos]
      # Actualiza el valor del global
      GlobalCaim = maxCaim
      k = k+1
    }
    # Reporta y guarda el resultado de la iteración
    # Crear el resultado como un vector
    vr = c(D,GlobalCaim,k,i)
    resultados = append(resultados,list(vr))
  }
  # Ya estando fuera de la función, puedo operar los resultados
  # para reportar las salidas necesarias
  ### Colapsar en una matriz la lista de resultados
  resultados = do.call(rbind, resultados)
  # Separar los esquemas
  esquemas = resultados[,1:(ncol(resultados)-3)]
  # Caim por variable
  Caim =cbind.data.frame(Variables = names(datos[,atributos]),
                         Caim = resultados[,(ncol(resultados)-2)])
  # Usar los intervalos para discretizar por variable
  datosR = datos
  # Discretizar solo las variables que se les obtuvo el esquema
  for(i in 1:length(atributos)){
    # Aplicar la discretización para el atributo i-esimo dentro
    # los permitidos
    datosR[,atributos[i]] = cut(datosR[,atributos[i]],
                                breaks = esquemas[i,],
                                include.lowest = TRUE,
                                right = TRUE)
  }
  #Teniendo todo, se reporta en un solo objeto todo lo depurado
  resultadoF = list(Discretizados = datosR,
                    CAIM = Caim,
                    Esquemas = esquemas)
  return(resultadoF)
}


