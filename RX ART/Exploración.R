
## CARGAR la base de datos ##
library(readxl)
ruta = "/home/angeal/Escritorio/RX ART/DATA (2).xlsx"
datos = as.data.frame(read_excel(ruta))

## Mostrar la base ##
datos1 = datos[,-1] 

# Mostrar el comportamiento individual de los datos

plot(datos1$PIB ,pch = 16,type = "o")
plot(datos1$TASA_INTERES_PASIVA,pch = 16,type = "o")
plot(datos1$TASA_INTERES_ACTIVA,pch = 16,type = "o")
plot(datos1)


#### Probar normalidad de las variables ####

A = data.frame(W = 0, pvalor = 0)
for(i in 1:ncol(datos1)){
  # Hacer la prueba de shapiro
  pb = shapiro.test(datos1[,i])
  sj = round(c(W = pb$statistic,pvalor = pb$p.value),4)
  ## Acumularlos
  A[i,] = sj
}
A$Variables = names(datos1) 
A$Normalidad = ifelse(A$pvalor>=0.05,"Sí","No")
A[,c(3,1,2,4)]

# Modelo de regresion #

#### Modelo full ####
library(flextable)
modelo = lm(PIB ~ .,datos1)

### Selección del mdejo modelo en base al criterio hibrido ##
library(MASS)  # Para poder usar la funcion stepAIC

#### Modelo 1 ####
M1 =  stepAIC(modelo, trace=TRUE, direction="backward")
as_flextable(M1)

#### 

### Probar normalidad ###
shapiro.test(M1$residuals)

### Probar Homocedasticidad ###
library(lmtest)
bptest(M1)

### Prueba de independencia ###
dwtest(M1) ### NO hay independencia


#####################################################




