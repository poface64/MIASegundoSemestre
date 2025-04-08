rm(list=ls())
# Armar la base #
CPR = c(40, 11.1, 30.0, 21.4, 10.7, 3.4, 42.0, 31.1, 50, 60.4, 45.7, 17.3)
Temp = c(36.0, 37.2, 36.5, 39.4, 39.6, 40.7, 37.6, 42.2, 38.5, 39.4, 38.6, 42.7)
Label = c('viral', 'viral', 'viral', 'viral', 'viral', 'viral', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial', 'Bacterial')
datos = data.frame(CPR,Temp,Label)

# Separar los datos
Dk = as.matrix(datos[,-3]) 
D1 = as.matrix(datos[datos$Label=="viral",-3]) 
D2 = as.matrix(datos[datos$Label!="viral",-3])

# Obtener las medias 
m = colMeans(Dk);m
m1 = colMeans(D1);m1
m2 = colMeans(D2);m2

# Matriz de dispersión dentro de la clase
S1 = (t(D1)-m1) %*% t(t(D1)-m1);S1
S2 = (t(D2)-m2) %*% t(t(D2)-m2);S2
Sw = S1 + S2;Sw

# Varianza total sin información de clase 
St = (t(Dk)-m) %*% t(t(Dk)-m)

# Varianza entre clases de la matriz #
Sb = St-Sw

# Armando la matriz de varianzas invertidas
S =  solve(Sw) %*% Sb;S

# Calcular los eigenvalores 
A = eigen(S);

# Varianza explicada 
round(100*A$values/sum(A$values),4)

# Vectores 
A$vectors

# Crear el vector de proyecciones
Z = Dk %*% t(t(A$vectors[,1]))

# Proyectar en 2 dimensiones

plot(x = Z,y = rep(0,length(Z)) ,col = factor(datos$Label),pch = 16)

plot(datos[,1:2],col = factor(datos$Label),pch = 16)

