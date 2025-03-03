
# Convertir a escala de grises usando la fórmula estándar
#grayscale <- 0.299 * datos[,,1] + 0.587 * datos[,,2] + 0.114 * datos[,,3]

#### Cargar las imágenes en escala de grises ####
library(png)
library(jpeg)
library(grid)
#ruta = "IMG/L1.jpg"
ruta = "IMG/Fig2.19(a).jpg"
#ruta = "IMG/IM4.jpg"
datos1 = readJPEG(ruta) # 330 Filas; 423 columnas
datos1 <- 0.299 * datos[,,1] + 0.587 * datos[,,2] + 0.114 * datos[,,3]
#datos = readJPEG(ruta) # 330 Filas; 423 columnas
grid.raster(datos1)
datos1[1:2,1:2] |> grid.raster()


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
