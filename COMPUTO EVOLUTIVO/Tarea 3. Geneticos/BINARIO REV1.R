rm(list=ls())

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
r2b = function(x,nbits,a = -10,b = 10){
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
b2r = function(bin ,nbits,a = -10,b = 10){
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
  ## Para el problema 1
  if(problema == 1){
    # Con limites  entre [-10, 10]
    limites = c(-10,10)
    ## Para el problema 2
  }else{
    # Con limites  entre [-5.12, 5.12]
    limites = c(-5.12,5.12)
  }
  # Calcular el numero de bits dependiendo el problema
  nposibles = (limites[2]-limites[1])/(1/10^precision)
  # Devolver los nbits
  return(ceiling(log2(nposibles)))
}




#### 1.-  GENERADOR DE POBLACIÓN ####
# Generar N cantidad de posibles soluciones
# n es la cantidad de sujetos que componen a la población
# Generador de sujetos SIN problemas de repetir casillas
nbits = n_bits(1,3)


sol1 = function(Dn = 10,problema){
  # Crear un vector de tamaño Dn
  ## Para el problema 1
  if(problema == 1){
    # Con uniforme  entre [-10, 10]
    limites = c(-10,10)
  }else{
    # Con uniforme  entre [-5.12, 5.12]
    limites = c(-5.12,5.12)
  }
  # Generar la solución
  sol = round(runif(Dn,min = limites[1],max =  limites[2]),3)
  # Convertir cada valor en una cadena que luego se va a pegar
  cadena = c()
  for(i in 1:Dn){
    # Aplicar  la función por cada real y agregarlo al vector de bits
    cadena = c(cadena,r2b(sol[i],nbits, a = limites[1],b = limites[2]))
  }
  # Devolver la cadena
  return(cadena)
}















### Zona de pruebas ####
nbits = 15
x = -0.1947
a = -10
b = 10

paste("Entra:",x)
paste("Representación normalizada en bits")
r2b(x,nbits)
paste("Representación normalizada de bits a reales")
z = r2b(x,nbits)
b2r(z,nbits)
