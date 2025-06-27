rm(list=ls())

#### Cargar el algoritmo para discretizar ####
source("CAIMA.R")

#### 1.-IRIS ####
# Iris ya viene aqui por defecto, entonces poco más #
datos1 = iris
R1 = CAIM(datos1,"Species")
write.csv(R1$Discretizados,"1IrisD.csv",row.names = F)

#### 2.-Palmer penguins ####
# Se carga la base de los pinguinos palmer #
library(palmerpenguins)
datos2 = as.data.frame(palmerpenguins::penguins)
dim(datos2)
# Identificar datos faltantes
datos2sf = datos2[is.na(datos2$bill_depth_mm)==F,c(3:6,1)]

# Aplicar el caim sobre la parte discreta #
R2 = CAIM(datos2sf,"species")

# Corregir sobre la final y enviar #
write.csv(R2$Discretizados,"2PalmerPenD.csv",row.names = F)

#sum(diag(table(R2$Discretizados$flipper_length_mm,R2$Discretizados$species)))/nrow(R2$Discretizados)

#### 3.- Vinos del UCI ###

datos3 = read.csv("vinos.csv")
View(datos3)
table(datos3$class)
dim(datos3)
# Aplicar el caim sobre la parte discreta #
R3 = CAIM(datos3,"class")
# Corregir sobre la final y enviar #
write.csv(R3$Discretizados,"3WinesD.csv",row.names = F)


#### 4.- Ataques al corazón ###
library(kmed)
datos4 = heart
# Cambiar la etiqueta a 2 posibles resultados
datos4$class[datos4$class>0] = 1
datos4$class =  ifelse(datos4$class==0,"Sano","Enfermo")
# Cambiar el sexo por etiquetas #
datos4$sex =  ifelse(datos4$sex==T,"Hombre","Mujer")
# Cambiar el cp
cp = c("Angina","Atipico","NoAnginal","Asintomatico")
datos4$cp = cp[datos4$cp]
# Cambiar lo de las gbs
datos4$fbs =  ifelse(datos4$fbs==T,"mas120","menos120")
# Cambiar lo exang
datos4$exang =  ifelse(datos4$exang==T,"Inducido","Noinducido")
# Cambiar restcg
restcg = c("Normal","Anormalidad","Ventricular")
datos4$restecg = restcg[as.numeric(datos4$restecg)]
# Cambiar slope #
slope = c("Ascendente","Plana","Descendente")
datos4$slope = slope[as.numeric(datos4$slope)]
# Cambiar CA #
thal = c("Normal","DefectoFijo","DefectoReversible")
datos4$thal = thal[as.numeric(datos4$thal)]

R4 = CAIM(datos4,"class")
head(R4$Discretizados)
# Corregir sobre la final y enviar #
write.csv(R4$Discretizados,"4HeartAttacksD.csv",row.names = F)
View(R4$Discretizados)

#### 5.-Carros para la venta ###
datos5 = read.csv("cars.csv")
# Cambiar a solo 3 clases 
datos5$class[datos5$class=="vgood"] = "good"
# Revisar personas #
persons = c("2P","4P","4Mas")
datos5$persons = persons[as.numeric(as.factor(datos5$persons))]
# Revisar las puertas #
doors = c("2Puertas","3Puertas","4Puertas","5Mas")
datos5$doors = doors[as.numeric(as.factor(datos5$doors))]
# Corregir sobre la final y enviar #
write.csv(datos5,"5CarEvaluationD.csv",row.names = F)

#### 6.-Riesgo materno ###
datos6 = read.csv("materna.csv")
# Discretizar la cosa #
R6 = CAIM(datos6,"RiskLevel")
head(R6$Discretizados)
# Corregir sobre la final y enviar #
write.csv(R6$Discretizados,"6MaternalHealthRisk.csv",row.names = F)

#### 7.-Riesgo materno ###
datos7 = read.csv("pasitas.csv")
datos7$Class
# Discretizar la cosa #
R7 = CAIM(datos7,"Class")
head(R7$Discretizados)
# Corregir sobre la final y enviar #
write.csv(R7$Discretizados,"7Raisins.csv",row.names = F)

#### 8.- Nurserys ###
datos8 = read.csv("nurses.csv")
# Revisar las puertas #
child = c("1hijo","2hijos","3hijos","4más")
datos8$children = child[as.numeric(as.factor(datos8$children))]
# Corregir sobre la final y enviar #
write.csv(datos8,"8Nurses.csv",row.names = F)
table(datos8$class)

#### 9.- Vidrio ###
datos9 = read.csv("glass.csv")
names(datos9)[10] = "Class"
# Discretizar
R9 = CAIM(datos9,"Class")
head(R9$Discretizados)
# Corregir sobre la final y enviar #
write.csv(R9$Discretizados,"9GlassID.csv",row.names = F)

#### 10.- Zoo ###
datos10 = read.csv("Zoo.csv")
str(datos10)
# Cambiar el pelo #
datos10$Pelo = ifelse(datos10$Pelo==1,"TienePelo","NoPelo") 
# Cambiar en plumas #
datos10$Plumas = ifelse(datos10$Plumas==1,"TienePlumas","NoPlumas") 
# Cambiar en huevos #
datos10$Huevos = ifelse(datos10$Huevos==1,"PoneHuevos","NoHuevos") 
# Cambiar en Leche #
datos10$Leche = ifelse(datos10$Leche==1,"DaLeche","NoLeche") 
# Cambiar en Volador #
datos10$Volador = ifelse(datos10$Volador==1,"Vuela","NoVuela") 
# Cambiar en Acuatico #
datos10$Acuatico = ifelse(datos10$Acuatico==1,"Acuatico","NoAcuatico") 
# Cambiar en Depredador #
datos10$Depredador = ifelse(datos10$Depredador==1,"Depredador","NoDepredador") 
# Cambiar en Dentado #
datos10$Dentado = ifelse(datos10$Dentado==1,"Dentado","NoDentado") 
# Cambiar en Vertebrado #
datos10$Vertebrado = ifelse(datos10$Vertebrado==1,"Vertebrado","NoVetebrado") 
# Cambiar en Respira #
datos10$Respira = ifelse(datos10$Respira==1,"Respira","NoRespira") 
# Cambiar en Venenoso #
datos10$Venenoso = ifelse(datos10$Venenoso==1,"Venenoso","NoVenenoso") 
# Cambiar en Aletas #
datos10$Aletas = ifelse(datos10$Aletas==1,"Aletas","NoAletas") 
# Cambiar en Patas #
patas = c("0patas","2patas","4patas","5patas",
          "6patas","8patas")
datos10$Patas = patas[as.numeric(factor(datos10$Patas))]
# Cambiar en Cola #
datos10$Cola = ifelse(datos10$Cola==1,"Cola","NoCola") 
# Cambiar en Domestico #
datos10$Domestico = ifelse(datos10$Domestico==1,"Domestico","NoDomestico") 
# Cambiar en Catsize #
datos10$catsize = ifelse(datos10$catsize ==1,"Catsize","NoCatsize") 
# Nombre
write.csv(datos10[,-1] ,"10Zoo.csv",row.names = F)
