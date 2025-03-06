rm(list = ls())
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

#### Generar el histograma en base a las frecuencias ####
img1 = c(datos*255)
# Hacer el conteo de frecuencies
tabla = table(factor(img1,levels = 0:255))
barplot(tabla)

# Calcular las probabilidades #
pp = tabla/sum(tabla)
accum = pp
for(i in 2:length(pp)){
  # Acumular los valores 
  accum[i] = accum[i] + accum[i-1]
}

# Usar la probabilidad acumulada para asignar el nuevo valor de cada pixel #
salida =  round(255*accum[paste0(img1)])
plot(0:255,accum ,type = "l")

imgs = matrix(salida,nrow =dim(datos)[1] ,ncol = dim(datos)[2])
grid.raster(imgs/255) # Proyectar la imagen rapido

# Implementar la versión ajustada #
Fk = round(255*accum[paste0(img1)])
F0 = min(Fk)
salida =  round(255*(Fk-F0)/(255-F0))
imgs = matrix(salida,nrow =dim(datos)[1] ,ncol = dim(datos)[2])
grid.raster(imgs/255) # Proyectar la imagen rapido

plot(table(salida))

















Histogram Equalization
(a) Write a computer program for computing the histogram of
an image.

(b) Implement the histogram equalization technique discussed
in Section 3.3.1.

(c) Download figures 3.15(1,2,3) and perform histogram
equalization on them.
As a minimum, your report should include the original
image, a plot of its histogram, a plot of the histogramequalization
transformation function, the enhanced image,
and a plot of its histogram. Use this information to explain
why the resulting image was enhanced as it was.








