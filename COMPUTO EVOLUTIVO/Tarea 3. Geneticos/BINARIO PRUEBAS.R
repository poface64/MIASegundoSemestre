
# Zona de pruebas #
problema = 1
Dn = 10
n = 30
pobsize = n
nbits = n_bits(problema)
PC = 0.8
PM = 0.1
# Generar la población
poblacion = pob(n,problema,Dn)
# Generar las aptitudes
aptitud = apply(poblacion,1,fx,problema)
min(aptitud)

# Selector de padres 
ganadores = padreselect(pobsize,aptitud)

# Aplicar cruza
hijos = cruza(ganadores,poblacion,PC)

# Aplicar la mutación #
poblacion1 = mutacion(hijos,PM)
aptitud1 = apply(poblacion1,1,fx,problema)
min(aptitud1)


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



