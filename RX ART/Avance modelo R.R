rm(list=ls())

# Cargar las librerias necesarias #
library(flextable)
library(readxl)
library(ggplot2)
library(GGally)
library(MASS) 
library(lmtest)
library(car)

# Cargar tus datos 
ruta = "DATA (2).xlsx"
datos = as.data.frame(read_excel(ruta))
# Especial
#autofit(theme_box(flextable(head(datos))))

### Obtener descriptivos
datos1 = datos[,-1]
resu = cbind.data.frame(variables = sub("_"," ",sub("_"," ",names(datos1))),
                 min = apply(datos1,2,min),
                 max = apply(datos1,2,max),
                 media = apply(datos1,2,mean),
                 mediana = apply(datos1,2,median),
                 desviación = apply(datos1,2,sd))
resu[,-1] = round(resu[,-1],4)
# Mostrar
resu

#### Hacer la gráfica de dispersión ####
gr1 = ggpairs(datos1,
              title = "Gráficos de dispersión",
              axisLabels = "show")
gr1
ggsave("g1.png",gr1,
       width = 6,
       height = 6,
       dpi = 300)

#### MODELO DE REGRESION LINEAL ####

# Modelo completo
modelo = lm(PIB~.,datos1)
# SUMMARY #
theme_box(as_flextable(modelo))

#### Selección del modelo ####

# Modelo completo
modelo = lm(PIB~.,datos1)
# SUMMARY #
theme_box(as_flextable(modelo))

#### Selección del modelo ####
modelored = stepAIC(modelo, trace=F, direction="backward")
theme_box(as_flextable(modelored))

#### Supuestos del modelo ####

## Prueba de normalidad ##
prueba1 = shapiro.test(modelored$residuals)
theme_box(as_flextable(prueba1)) 


## Prueba de Breush Pagan ##
prueba2 =  bptest(modelored)
theme_box(as_flextable(prueba2)) 

## Prueba de independiente ##
theme_box(as_flextable(dwtest(modelored))) 

## Revisar la multicolinealidad ##
vif(modelored)

data.frame(VIFF = vif(modelored))






