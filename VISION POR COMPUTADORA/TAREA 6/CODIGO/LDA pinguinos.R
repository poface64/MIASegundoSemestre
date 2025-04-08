rm(list=ls())

#### Cargar la base de iris ####
library(ggplot2)
library(rgl)
datos = iris
datos2 = datos[datos$Species!="setosa",]
datos2$Species = as.character(datos2$Species) |> as.factor() 

#### Gráficar el caso ####
ggplot(datos2,aes(x = Sepal.Length,
                  y = Sepal.Width,
                  color = Species)) + 
  geom_point()+
  theme_bw() + 
  theme(legend.position = "bottom")
plot3d(x = datos$Sepal.Length,
    y = datos$Sepal.Width,
    z = datos$Petal.Length)

# Separar en 2 la base de datos
D1 = datos[datos$Species=="versicolor",-5] |> as.matrix()
D2 = datos[datos$Species=="virginica",-5] |> as.matrix()

# Extraer los vectors de medias
m1 = colMeans(D1)
m2 = colMeans(D2)

# Matriz de varianzas y covarianzas dentro de clases
SB = t(t(m1-m2)) %*% t(m1-m2)

# Entre clases #
S1 = (t(D1)-m1) %*% t(t(D1)-m1)
S2 = (t(D2)-m2) %*% t(t(D2)-m2)
Sw = S1+S2

# Definir la matriz con ambas varianzs

S = solve(Sw)%*%SB

# Obtener los eigenvalores #
A = eigen(S)
round(100*A$values/sum(A$values))

# Mostrar el resultado de los LDA
dataP = as.matrix(datos2[,-5]) %*% A$vectors

plot(dataP[,1],pch = 16,
    col = datos2$Species)

