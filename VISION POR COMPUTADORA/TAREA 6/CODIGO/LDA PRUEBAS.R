rm(list=ls())

# Cargar la base de datos y la libreria #
library(MASS)
library(palmerpenguins)
datos = as.data.frame(palmerpenguins::penguins)[,-c(2,7,8)]
datos1 = datos[is.na(datos$bill_length_mm)==F, ]
datos2 = datos1[datos1$species!="Gentoo",]
datos2$species = as.factor(as.character(datos2$species))
# Aplicar el LDA que viene de formulazo #
modelo = lda(species~.,datos1)
modelo

#### Expansión limpia del programa para hacer LDA multiclases ####
# Generar la matriz #
X = datos2[,-1]
Y = datos2[,1]

# Armar la base #
CPR = c(40, 11.1, 30.0, 21.4, 10.7, 3.4, 42.0, 31.1, 50, 60.4, 45.7, 17.3)
Temp = c(36.0, 37.2, 36.5, 39.4, 39.6, 40.7, 37.6, 42.2, 38.5, 39.4, 38.6, 42.7)
Label = c('viral', 'viral', 'viral', 'viral', 'viral', 'viral', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial')
datos = data.frame(CPR,Temp,Label)
X = datos[,1:2]
Y = datos[,3]

X = datos1[,-1]
Y = datos1[,1]

X = datos2[,-1]
Y = datos2[,1]
dim(X)

LDA = function(X,Y){
  # Entra la matriz X
  X = as.matrix(X)
  #### Generar la matriz de medias ####
  nc = ncol(X) # Numero P de variables
  clas = unique(Y) # K Clases
  nr = length(clas)  # Cantidad K de clases
  medias = matrix(0,nr,nc) # Matriz de medias vacia
  Sw = matrix(0,nc,nc) # Matriz de varianza Sw vacia
  for(i in 1:nr){
    # Separar los datos por clase #
    mini1 = X[Y==clas[i],] # Subconjunto para la clase k-esima
    # Calcular las medias
    medias[i,] = colMeans(mini1) # Vector de medias K-esimo
    # Calcular las matrices de covarianzas
    Sn = (t(mini1)-medias[i,]) %*% t(t(mini1)-medias[i,]) #Matriz de varianza k-esima
    # Acumuar la varianza
    Sw = Sw + Sn # Matriz de dispersión dentro de la clase
  }
  # Dispersión total de los datos # 
  m = colMeans(X) # Vector de medias global
  St = (t(X)-m) %*% t(t(X)-m)
  # Varianza entre clases de la matriz #
  Sb = St-Sw
  # Armando la matriz de varianzas invertidas
  S =  solve(Sw) %*% Sb
  # Calcular los eigenvalores de la matriz
  A = eigen(S)
  # Varianza explicada con los eigenvalores
  VE = round(100*A$values/sum(A$values),4)
  # Eigenvectores para proyectar los datos en el nuevo espacio de k-1 dimensiones
  DS = (VE>0.0001)
  # Vectores seleccionados
  SV = t(t(A$vectors[,DS]))
  # Crear el vector de proyecciones k-1 dimensional
  Z = X %*% SV
  colnames(Z) = paste0("ND",1:ncol(SV))
  # Comprimir y reportar la salida
  resu = list(varianza = VE,
              coeficientes = SV,
              proyecciones = Z)
}








