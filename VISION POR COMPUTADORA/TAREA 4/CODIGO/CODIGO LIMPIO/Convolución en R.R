rm(list = ls())

# Librerias para tratamiento de imagenes #
library(png)
library(jpeg)
library(grid)

# Cargar la imagen desde la ruta 
ruta = "Fig3.45(a).jpg"
datos = readJPEG(ruta) # 1280 filas y 960 columnas
#dim(datos1)
grid.raster(datos) # Proyectar la imagen rapido


#### Explorar la implementación de la convolución ####
# Hacer el kernel manualmente
datos = datos * 255
kern = matrix(c(-1,-1,-1,
                0,0,0,
                1,1,1),ncol = 3,nrow = 3)
kern = t(kern)

# Separar el tamaño del kernel y de la imagen
kerdim = dim(kern)
imdim = dim(datos)

# Matriz para la imagen resultante
resultado = matrix(0,nrow =  imdim[1]-kerdim[1]+1,
                   ncol = imdim[2]-kerdim[2]+1)
dim(resultado)

# Aplicar la convolución #

for(i in 1:(imdim[1]-kerdim[1]+1)){
  # Aplicar el filtro por columnas
  for(j in 1:(imdim[2]-kerdim[2]+1)){
    # Extraer una submatriz de nxn de la imagen
    subim = datos[i:(i+kerdim[1]-1),j:(j+kerdim[2]-1)]
    # Realizar la multiplicación elemento a elemento y la suma
    resultado[i,j] = sum(subim*kern)
  }
}
resultado = abs(resultado)
minr = min(resultado)
maxr = max(resultado)

p = (resultado-minr)/(maxr-minr)

# Rasterizar la imagen resultante
grid.raster(p) # Proyectar la imagen rapido


### Expansión de la convolución para el operador de sobel ####
rm(list = ls())
# Librerias para tratamiento de imagenes #
library(png)
library(jpeg)
library(grid)
# Cargar la imagen desde la ruta 
ruta = "F3.jpg"
datos = readJPEG(ruta)
#datos = readJPEG(ruta) # 1280 filas y 960 columnas
#datos = readPNG(ruta)[,,1]
grid.raster(datos) # Proyectar la imagen rapido



#### Operador de Sovel ####
# Hacer el kernel manualmente

### Generar la matriz que detecta en Gx
datos = datos * 255
gxk = matrix(c(-1,0,1,
               -2,0,2,
               -1,0,1),ncol = 3,nrow = 3)

### Generar la matriz que detecta en Gx
gyk = t(gxk)


# Separar el tamaño del kernel y de la imagen
imdim = dim(datos)
kerdim = dim(gxk)

# Matriz para la imagen resultante
# Quedan 4 matrices de salida, vamos a operar 3 por el momento
#gx,gy y Delta de Sobel
rf = imdim[1]-kerdim[1]+1
rc = imdim[2]-kerdim[2]+1

# Armar una matriz de tamaño p x q x 3 para guardar los 3 resultados

resultado = array(0,dim = c(rf,rc,3) )
dim(resultado)

# Aplicar la convolución a las 3 matrices#
# gx, gy y el delta de sobel
for(i in 1:(rf)){
  # Aplicar el filtro por columnas
  for(j in 1:(rc)){
    # Extraer una submatriz de nxn de la imagen
    subim = datos[i:(i+kerdim[1]-1),j:(j+kerdim[2]-1)]
    # Aplicar la convolusión sobre GX
    resultado[i,j,1] = sum(subim*gxk)
    # Aplicar la convolusión sobre GY
    resultado[i,j,2] = sum(subim*gyk)
    # Aplicar la convolusión con el operador de sobel
    sobel = abs(sum(subim[3,]*gxk[3,]) - sum(subim[1,]*gxk[3,]))+
      abs(sum(subim[,3]*gxk[3,]) - sum(subim[,1]*gxk[3,]))
    # Se guarda el valor del gradiente
    resultado[i,j,3] = sobel
  }
}

#### Reportar las salidas ####
# Reportar Gx
rgx = resultado[,,3]
# Estandarizar
minr = min(rgx)
maxr = max(rgx)
# Estandarizar SIN valor absoluto
p = (rgx-minr)/(maxr-minr)
q = 1-p
# Rasterizar la imagen resultante
grid.raster(p) # Proyectar la imagen rapido
grid.raster(q) # Proyectar la imagen rapido

########################################

### Expansión de la convolución para el operador de sobel ####
rm(list = ls())

# Librerias para tratamiento de imagenes #
library(png)
library(jpeg)
library(grid)
# Cargar la imagen desde la ruta 
ruta = "F3.jpg"
datos = readJPEG(ruta)
#datos = readJPEG(ruta) # 1280 filas y 960 columnas
#datos = readPNG(ruta)[,,1]
grid.raster(datos) # Proyectar la imagen rapido


### Generar la matriz que detecta en Gx
datos = datos * 255
gxk = matrix(c(-1,0,1,
               -2,0,2,
               -1,0,1),ncol = 3,nrow = 3)
### Generar la matriz que detecta en Gx
gyk = t(gxk)

# Separar el tamaño del kernel y de la imagen
imdim = dim(datos)
kerdim = dim(gxk)

# Matriz para la imagen resultante
# Quedan 4 matrices de salida, vamos a operar 3 por el momento
#gx,gy y Delta de Sobel
rf = imdim[1]-kerdim[1]+1
rc = imdim[2]-kerdim[2]+1

# Armar una matriz de tamaño p x q x 3 para guardar los 3 resultados
resultado = array(0,dim = c(rf,rc,4) )
dim(resultado)

# Aplicar la convolución a las 3 matrices#
# gx, gy y el delta de sobel
for(i in 1:(rf)){
  # Aplicar el filtro por columnas
  for(j in 1:(rc)){
    # Extraer una submatriz de nxn de la imagen
    subim = datos[i:(i+kerdim[1]-1),j:(j+kerdim[2]-1)]
    # Aplicar la convolusión sobre GX
    resultado[i,j,1] = sum(subim*gxk)
    # Aplicar la convolusión sobre GY
    resultado[i,j,2] = sum(subim*gyk)
    # Aplicar la convolusión con el operador de sobel
    sobel = sqrt(resultado[i,j,1]^2 + resultado[i,j,2]^2)
    # Se guarda el valor del gradiente
    resultado[i,j,3] = sobel
  }
}

# Operador de la dirección
resultado[,,4] = atan2(resultado[,,2], resultado[,,1])
# Normalizar el ángulo a [0, 1] para asignar colores
theta_norm = (resultado[,,4] + pi) / (2 * pi)  # Convertimos de [-pi, pi] a [0,1]
# Mostrar la dirección con colores
grid.raster(theta_norm)

#### Reportar las salidas ####
# Reportar Gx
rgx = resultado[,,3]
# Estandarizar
minr = min(rgx)
maxr = max(rgx)
# Estandarizar SIN valor absoluto
p = (rgx-minr)/(maxr-minr)
q = 1-p
# Rasterizar la imagen resultante
grid.raster(p) # Proyectar la imagen rapido
grid.raster(q) # Proyectar la imagen rapido
