#Histogram Equalization
#(a) Write a computer program for computing the histogram of
#an image.
# (b) Implement the histogram equalization technique discussed
# in Section 3.3.1.
#(c) Download figures 3.15(1,2,3) and perform histogram
#equalization on them.
#As a minimum, your report should include the original
#image, a plot of its histogram, a plot of the histogramequalization
## transformation function, the enhanced image,
## and a plot of its histogram. Use this information to explain
## why the resulting image was enhanced as it was.


### Factor de conversión para los grises ###
# Convertir a escala de grises usando la fórmula estándar
#grayscale <- 0.299 * datos[,,1] + 0.587 * datos[,,2] + 0.114 * datos[,,3]

#### Cargar las imágenes en escala de grises ####
library(png)
library(jpeg)
library(grid)
ruta = "IMG/IM4_gray.jpg"
#ruta = "IMG/Fig3.15(a)1.jpg"
#datos1 = readJPEG(ruta) # 330 Filas; 423 columnas
#datos1 <- 0.299 * datos[,,1] + 0.587 * datos[,,2] + 0.114 * datos[,,3]
datos = readJPEG(ruta) # 330 Filas; 423 columnas
grid.raster(datos) # Proyectar la imagen rapido
datos[1:400,1:400] |> grid.raster()

#### Función para crear el histograma ####
datos1 = datos*255 # Convertir a rango de 255
tabla = (table(Pixel = factor(datos1,levels = 0:255 )))
barplot(tabla)
plot(as.numeric(tabla),type = "l",
     ylab = "Suma acumulada")

tabla

#### Dividir entre el total de pixeles ####
n = sum(tabla)
pp = tabla/n
ppc = pp
for(i in 1:length(pp)){
  # Si i = 1
  if(i > 1){
    ppc[i] = ppc[i] + ppc[i-1]  
  }
}
# El histograma ya esta con la suma acumulada
plot(as.numeric(ppc)*255,type = "l",
     ylab = "Suma acumulada")


255*ppc




nuevo = 255 *(ppc-ppc[1])/(255-ppc[1])





#### Notación
(X,Y): Pares ordenados en la matriz de pixeles
f(X,Y): Valor de gris para el pixel en la posición (X,Y) de la matriz.

############

bilineal = function(){}

#### Dimensiones originales de la matriz  
Oaltura = dim(datos1)[1]  
Oancho  = dim(datos1)[2]
  
#### Donde se va a guardar la nueva matriz ####
n1 = 1024
n2 = 1024
nueva = matrix(0,nrow = n1,ncol = n2)

#### Relación entre los tamaños
escalaX = (Oancho-1)/(n1-1)
escalaY = (Oaltura-1)/(n1-1)

#### Hacer el ciclo que vaya escaneando la matriz ####
for(i in 1:n1){
  for(j in 1:n2){
    # Coordenadas de la imagen original
    X = escalaX*(j-1) + 1 # 1 adelante del borde
    Y = escalaY*(i-1) + 1 # 1 adelante del borde
    #### Datos para el interpolado ####
    x1 = floor(X)
    x2 = min(x1+1,Oancho)
    y1 = floor(Y)
    y2 = min(y1+1,Oaltura)
    
    # Pesos para la interpolación
    dx = X-x1
    dy = Y-y1
    
    #### Extraer los valores de los 4 pixeles vecinos
    Q11 = datos1[y1,x1]
    Q12 = datos1[y2,x1]
    Q21 = datos1[y1,x2]
    Q22 = datos1[y2,x2]
    #### Nueva imagen, pixel a pixel con la interpolación
    nueva[i,j] =  (1-dx) * (1-dy)*Q11 +
                  dx*(1-dy)*Q21 + 
                  (1-dx)*dy*Q12 +
                  dx*dy*Q22
  }
}

grid.raster(datos1)
grid.raster(nueva)
datos1 = nueva
dim(nueva)
