rm(list=ls())

# Entran 3 variables: 
# X: [0, 10]
# Y: [0, 10]
# Ya no fue posible agregar los casos para los 4 operaciones, solo la suma
# OP: c("+","-","*","/")

# Se definio una base de 19 reglas para la salida de la suma #

# Defino mi función triangular
trian = function(x,a,b,c){
  # Hacer la versión compacta
  resu = max(min((x-a)/(b-a),(c-x)/(c-b)),0)
}

# Instancio las variables para ir haciendo pruebas #
calculadora = function(x,y){
  ### Definir los niveles para X y Y ####
  # Defino 5 posibles niveles para X #
  x_minima = 0
  x_bajo = 0
  x_medio = 0
  x_alto = 0
  x_maxi = 0
  
  # Defino 5 posibles niveles para y #
  y_minima = 0
  y_bajo = 0
  y_medio = 0
  y_alto = 0
  y_maxi = 0
  
  #### Defino las funciones de membresia de entradas ####  
  ## Para X #
  xmminima = trian(x,0,1,3)
  xmbajo = trian(x,1,3,4)
  xmmedio = trian(x,3,5,7)
  xmalto = trian(x,6,8,9)
  xmmaxi = trian(x,7,8.5,10)
  ## Para Y #
  ymminima = trian(y,0,1,3)
  ymbajo = trian(y,1,3,4)
  ymmedio = trian(y,3,5,7)
  ymalto = trian(y,6,8,9)
  ymmaxi = trian(y,7,8.5,10)
  
  #### Funciones de membresia para el caso de la suma ####
  ## Para Z la salida#
  
  Singletons = c(0,6,10,16,20,
                 11,11,14,14,
                 8,8, 13,13,
                 17,17,3,3,
                 12,12)
  # Reglas asociadas #
  r1 = min(xmminima ,ymminima ) #min y min 0
  r2 = min(xmbajo,ymbajo) #bajo y bajo 6
  r3 = min(xmmedio,ymmedio) #med y med 10
  r4 = min(xmalto,ymalto) #alto y alto 16
  r5 = min(xmmaxi,ymmaxi) #maxi y maxi 20
  r6 = min(xmminima,ymmaxi) #min y maxi 11
  r7 = min(xmmaxi,ymminima) #max y min 11
  r8 = min(xmbajo,ymmaxi) #bajo y maxi 14
  r9 = min(xmmaxi,ymbajo) #maxi y bajo 14
  r10 = min(xmmedio,ymbajo) #medio y bajo 8
  r11 = min(xmbajo,ymmedio) #bajo y medio 8
  r12 = min(xmalto,ymmedio) #maxi y maxi 13
  r13 = min(xmmedio,ymalto) #maxi y maxi 13
  r14 = min(xmmaxi,ymalto) #maxi y maxi 17
  r15 = min(xmalto,ymmaxi) #maxi y maxi 17
  r16 = min(xmminima,ymbajo) #maxi y maxi 3
  r17 = min(xmbajo,ymminima) #maxi y maxi 3
  r18 = min(xmbajo,ymalto) #maxi y maxi 12
  r19 = min(xmalto,ymbajo) #maxi y maxi 12
  
  # Procesar la salida
  n = length(Singletons)
  lista = mget(paste0("r",1:n))
  # Definir el vector con las reglas
  reglasV = unlist(lista)
  
  # Aplicar el centro de masas #
  SumaW = sum(reglasV);SumaW
  resu = sum(Singletons*reglasV)/SumaW
  
  # Devolver el resultado del singleton
  return(resu)
}


#### Corridas de prueba ####
calculadora(0,0) # Caso minimo no salio bien
calculadora(1,5) # 
calculadora(3,7) # Caso minimo no salio bien
calculadora(10,10) # Caso maximo no salio bien




