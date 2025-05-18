# 1. Cargar los datos
data <- DATA
head(data)

install.packages("readr")
install.packages("dplyr")

library(readr)
library(dplyr)

# Imprimir las primeras filas para verificar
head(data)

# Convertir PERIODO a formato de fecha trimestral
library(zoo)
data$PERIODO <- as.yearqtr(data$PERIODO, format = "%q-%Y")

# Crear un objeto de serie de tiempo (ts)
ts_data <- ts(data[, -1], start = c(2014, 1), frequency = 4)

# Verificar la serie de tiempo
print(ts_data)

# Visualización de las series de tiempo
library(ggplot2)
library(tidyr)

# Convertir los datos de serie de tiempo a un formato largo para ggplot2
data_long <- as.data.frame(ts_data) %>%
  mutate(PERIODO = time(ts_data)) %>%
  gather(key = "Variable", value = "Valor", -PERIODO)

# Graficar las series de tiempo
ggplot(data_long, aes(x = PERIODO, y = Valor, color = Variable)) +
  geom_line() +
  facet_wrap(~ Variable, scales = "free_y") +
  labs(title = "Series de Tiempo",
       x = "Periodo",
       y = "Valor") +
  theme_minimal()

# Prueba de estacionariedad (ADF)
library(tseries)

# Aplicar la prueba ADF a cada columna
adf_results <- lapply(data[, 2:ncol(data)], function(x) adf.test(x))

# Imprimir los resultados de la prueba ADF
print(adf_results)
############################################################ continuamos con el dolor de cabeza después




# Diferenciar las series no estacionarias
data_diff <- data.frame(apply(data[, 2:ncol(data)], 2, diff))

# Remover la primera fila de los periodos para que coincidan con los datos diferenciados
data_diff$PERIODO <- data$PERIODO[-1]

# Convertir los datos diferenciados a formato de serie de tiempo
ts_data_diff <- ts(data_diff[, -ncol(data_diff)], start = c(2014, 2), frequency = 4)


##############################
# Diferenciar la serie PIB
pib_diff <- diff(data$PIB)

# Aplicar la prueba ADF a la serie diferenciada
adf_test_pib_diff <- adf.test(pib_diff)
print(adf_test_pib_diff)

# Diferenciación de segundo orden
pib_diff2 <- diff(diff(data$PIB))

# Prueba ADF en la serie diferenciada de segundo orden
adf_test_pib_diff2 <- adf.test(pib_diff2)
print(adf_test_pib_diff2)


install.packages("vars")
library(vars)

# 1. Preparar los datos: Asegurarse de que todas las series son estacionarias
# (En este ejemplo, asumimos que todas las series necesitan 2 diferenciaciones)
data_estacionario <- data.frame(
  PIB_diff2 = diff(diff(data$PIB)),
  TASA_INTERES_PASIVA_diff2 = diff(diff(data$TASA_INTERES_PASIVA)),
  # ... (diferenciar todas las demás variables)
  RIESGO_PAIS_diff2 = diff(diff(data$RIESGO_PAIS))
)

# Eliminar las primeras dos filas para que todas las series tengan la misma longitud
data_estacionario <- data_estacionario[-(1:2), ]

# 2. Seleccionar el orden del VAR (p)
# Usar criterios de información como AIC o BIC
VARselect(data_estacionario, lag.max = 10, type = "const")$selection

# 3. Estimar el modelo VAR
var_model <- VAR(data_estacionario, p = 2, type = "const") # Reemplaza '2' con el orden seleccionado

# 4. Analizar los resultados
summary(var_model)

# 5. Diagnóstico del modelo
# Pruebas de autocorrelación en los residuos, normalidad, etc.



# Prueba de autocorrelación de los residuos
serial.test(var_model, lags.pt = 10, type = "PT.asymptotic")
