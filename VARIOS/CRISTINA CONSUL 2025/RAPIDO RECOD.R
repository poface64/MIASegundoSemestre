# Cargar los paquetes necesarios
library(tidyverse)
library(readxl)
library(writexl)
library(ggplot2)

file.choose()
# Especifica la ruta de tu archivo Excel
ruta_del_archivo <- "C:\\Users\\gassa\\OneDrive\\Escritorio\\tmax_CLIC-30011_dly.xlsx"

# Leer el archivo Excel con readxl
tmx <- read_excel(ruta_del_archivo)

# Mostrar las primeras filas para verificar los nombres de las columnas
head(tmx)

# Eliminar filas con NA para calcular las estadísticas
tmx_global <- tmx[complete.cases(tmx), ]

# Función para calcular la moda
moda <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Calcular los parámetros estadísticos para la columna 'tmax'
estadisticas <- tmx_global %>% 
  summarise(
    Media = mean(tmax, na.rm = TRUE),
    Mediana = median(tmax, na.rm = TRUE),
    Moda = moda(tmax),
    Minimo = min(tmax, na.rm = TRUE),
    Maximo = max(tmax, na.rm = TRUE),
    Rango = max(tmax, na.rm = TRUE) - min(tmax, na.rm = TRUE),
    Desviacion = sd(tmax, na.rm = TRUE),
    Varianza = var(tmax, na.rm = TRUE),
    Anomalia = mean(tmax - mean(tmax, na.rm = TRUE), na.rm = TRUE)
  )

# Guardar la tabla de estadísticas en un archivo Excel
write_xlsx(estadisticas, "C:\\Users\\gassa\\OneDrive\\Escritorio\\estadisticas_tmx.xlsx")

# Contar la cantidad de valores NA en la columna 'tmax' por año
na_por_anio <- tmx %>% 
  group_by(año) %>% 
  summarise(na_count = sum(is.na(tmax)))

# Crear el gráfico de barras para mostrar los valores NA por año
grafico_na <- ggplot(na_por_anio, aes(x = as.factor(año), y = na_count)) +
  geom_bar(stat = "identity", fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Cantidad de Valores NA en Tmax por Año", x = "Año", y = "Cantidad de NA") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

print(grafico_na)
# Guardar el gráfico
# ggsave("C:\\Users\\gassa\\OneDrive\\Escritorio\\grafico_na_por_anio.png", plot = grafico_na)

# Mostrar el gráfico de barras en consola
print(grafico_na)

#crea una nueva columna llamada "fecha" en el dataframe

tmx_global$fecha <- as.Date(paste(tmx_global$año, tmx_global$mes, tmx_global$dia, sep = "-"))


# Verificar la presencia y nombre de la columna 'fecha' en tmx_global
names(tmx_global)

# Revisar las primeras filas de tmx_global para asegurarte de que los datos estén cargados correctamente
head(tmx_global)


# Convertir la columna de fecha a tipo Date
tmx_global$fecha <- as.Date(tmx_global$fecha)

# Crear el gráfico de serie de tiempo
grafico_serie_tiempo <- ggplot(tmx_global, aes(x = fecha, y = tmax)) +
  geom_line(color = "blue") +
  labs(title = "Serie de Tiempo de Tmax", x = "Fecha", y = "Tmax") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text = element_text(color = "black"),  # Etiquetas rojas en ejes x e y
        axis.title.x = element_text(color = "red"),  # Etiqueta roja para el título del eje x
        axis.title.y = element_text(color = "red"),  # Etiqueta roja para el título del eje y
        plot.title = element_text(hjust = 0.5))     # Centrar el título horizontalmente

# Mostrar el gráfico de serie de tiempo en consola
print(grafico_serie_tiempo)

# Guardar el gráfico como un archivo de imagen
ggsave("grafico_serie_tiempo.png", plot = grafico_serie_tiempo)

# Agregar columna de mes
tmx_global$mes <- month(tmx_global$fecha)

# Calcular medias mensuales de temperatura máxima
medias_mensuales <- tmx_global %>%
  group_by(año, mes) %>%
  summarise(Media_Tmax = mean(tmax, na.rm = TRUE))

# Crear el gráfico de serie de tiempo con línea de tendencia
grafico_serie_tiempo_medias <- ggplot(medias_mensuales, aes(x = as.Date(paste(año, mes, "01", sep = "-")), y = Media_Tmax)) +
  geom_line(color = "blue") +
  labs(title = "Serie de Tiempo de Medias Mensuales de Tmax", x = "Fecha", y = "Media Mensual de Tmax") +
  geom_smooth(method = "lm", se = FALSE) +  # Agregar línea de tendencia
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text = element_text(color = "black"),  # Etiquetas negras en ejes x e y
        axis.title.x = element_text(color = "red"),  # Etiqueta roja para el título del eje x
        axis.title.y = element_text(color = "red"),  # Etiqueta roja para el título del eje y
        plot.title = element_text(hjust = 0.5))     # Centrar el título horizontalmente

# Mostrar el gráfico de serie de tiempo con línea de tendencia en consola
print(grafico_serie_tiempo_medias)



# Crear el box plot con las especificaciones solicitadas
grafico_boxplot <- ggplot(tmx_global, aes(x = as.factor(año), y = tmax, fill = as.factor(año))) +
  geom_boxplot(color = "black", outlier.color = "red") +
  labs(title = "Box Plot de Tmax por Año", x = "Año", y = "Tmax") +
  theme(axis.text.x = element_text(color = "black", angle = 90, vjust = 0.5),  # Etiquetas rojas en el eje x con ángulo vertical
        axis.text.y = element_text(color = "black"),  # Etiquetas negras en el eje y
        axis.title.x = element_text(color = "red"),  # Etiqueta roja para el título del eje x
        axis.title.y = element_text(color = "red"),  # Etiqueta negra para el título del eje y
        plot.title = element_text(hjust = 0.5),  # Centrar el título horizontalmente
        legend.position = "none")  # Eliminar la leyenda para el fill

# Mostrar el box plot en consola
print(grafico_boxplot)

# Guardar el gráfico como un archivo de imagen
ggsave("boxplot_tmax_por_año.png", plot = grafico_boxplot)


# Mostrar el box plot en consola
print(grafico_boxplot)

# Guardar el gráfico como un archivo de imagen
ggsave("boxplot_tmax_por_año.png", plot = grafico_boxplot)

# Crear el histograma de frecuencia
grafico_histograma <- ggplot(tmx_global, aes(x = tmax)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Histograma de Frecuencia de Tmax", x = "Tmax", y = "Frecuencia") +
  theme(axis.text.x = element_text(color = "black"),  # Etiquetas negras en el eje x
        axis.text.y = element_text(color = "black"),  # Etiquetas negras en el eje y
        axis.title.x = element_text(color = "red"),  # Etiqueta roja para el título del eje x
        axis.title.y = element_text(color = "red"),  # Etiqueta roja para el título del eje y
        plot.title = element_text(hjust = 0.5))     # Centrar el título horizontalmente

# Mostrar el histograma de frecuencia en consola
print(grafico_histograma)

# Guardar el gráfico como un archivo de imagen
ggsave("histograma_tmax_frecuencia.png", plot = grafico_histograma)

