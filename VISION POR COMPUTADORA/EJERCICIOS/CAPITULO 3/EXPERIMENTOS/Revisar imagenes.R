

library(tiff)
library(raste)
ruta = "C:\\Users\\Angel GB\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\EJERCICIOS\\CAPITULO 3\\images_chapter_03\\Fig0326(a)(embedded_square_noisy_512).tif"
datos = readTIFF(ruta, as.is=TRUE)
t[t >= 32738L] = -65536L + t[t >= 32738L]

install.packages("ijtiff")
library(ijtiff)
ruta = "C:\\Users\\Angel GB\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\EJERCICIOS\\CAPITULO 3\\images_chapter_03\\Fig0326(a)(embedded_square_noisy_512).tif"
datos = read_tif(ruta)


##########
library(jpeg)
file.choose()
ruta = "C:\\Users\\Angel GB\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\EJERCICIOS\\CAPITULO 3\\images_chapter_03\\Fig3.24.jpg"
img = readJPEG(ruta)*255
ker = matrix(1,nrow = 3,ncol = 3)  
tamaño = dim(img)

i = 2
j = 2

nueva = matrix(0,nrow = tamaño[1],ncol = tamaño[2])

for(i in 2:(tamaño[1]-1)){
  for(j in 2:(tamaño[2]-1)){
    # Aplicar la convolución como una suma de sumas
    subimg = img[(i-1):(i+1),(j-1):(j+1)]
    nueva[i,j] = sum(ker*subimg)/sum(ker)
  }
}











  