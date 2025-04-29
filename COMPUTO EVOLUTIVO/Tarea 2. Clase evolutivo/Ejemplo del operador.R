rm(list=ls())

# Función para generar beta con la nueva fórmula
generar_beta <- function(a, b) {
  u <- runif(1)
  if (u <= 0.5) {
    return(a - b * log(u))
  } else {
    return(a + b * log(u))
  }
}

#### Padres en 2D ####

padre1 <- c(0.2, 0.8)
padre2 <- c(0.8, 0.2)

# Parámetros
a <- 0 # parametro alfa centrado en 0
b <- c(0.1,0.9) # Valor propuesto de b 
N <- 100  # Número de hijos

#### Proceso resumido ####

# Matriz para almacenar a los hijos con operador de Laplace
# Hijos laplace 2 para b[1]
hijos_laplace1 <- matrix(NA, nrow = 2*N, ncol = 2)
for (i in 1:N) {
  # Generar el beta para la componente X y para la componente Y
  beta_x <- generar_beta(a, b[1])
  beta_y <- generar_beta(a, b[1])
  # Índices para los dos hijos
  idx1 <- (i - 1) * 2 + 1
  idx2 <- idx1 + 1
  # Hijo 1 (desde padre1)
  hijos_laplace1[idx1, 1] <- padre1[1] + beta_x * abs(padre1[1] - padre2[1])
  hijos_laplace1[idx1, 2] <- padre1[2] + beta_y * abs(padre1[2] - padre2[2])
  # Hijo 2 (desde padre2)
  hijos_laplace1[idx2, 1] <- padre2[1] + beta_x * abs(padre1[1] - padre2[1])
  hijos_laplace1[idx2, 2] <- padre2[2] + beta_y * abs(padre1[2] - padre2[2])
}

# Hijos laplace 2 para b[2]
hijos_laplace2 <- matrix(NA, nrow = 2*N, ncol = 2)
for (i in 1:N) {
  # Generar el beta para la componente X y para la componente Y
  beta_x <- generar_beta(a, b[2])
  beta_y <- generar_beta(a, b[2])
  # Índices para los dos hijos
  idx1 <- (i - 1) * 2 + 1
  idx2 <- idx1 + 1
  # Hijo 1 (desde padre1)
  hijos_laplace2[idx1, 1] <- padre1[1] + beta_x * abs(padre1[1] - padre2[1])
  hijos_laplace2[idx1, 2] <- padre1[2] + beta_y * abs(padre1[2] - padre2[2])
  # Hijo 2 (desde padre2)
  hijos_laplace2[idx2, 1] <- padre2[1] + beta_x * abs(padre1[1] - padre2[1])
  hijos_laplace2[idx2, 2] <- padre2[2] + beta_y * abs(padre1[2] - padre2[2])
}



#### Acomodar los datos ####
etiqueta = factor(rep(c(b),each = 2*N))
hijos = rbind.data.frame(hijos_laplace1,hijos_laplace2)
hijos$etiqueta = etiqueta
padres = rbind.data.frame(padre1,padre2)
names(padres) = c("V1","V2")

#### Gráficar con ggplot2 ####
library(ggplot2)
# Gráficar cuando el parametro es pequeño
ggplot(hijos[etiqueta==etiqueta[1],],aes(x = V1,
                                         y = V2,
                                         color = etiqueta)) + 
  geom_point(size = 2) +
  theme_bw() + 
  theme(legend.position = "bottom") +
  geom_point(data = padres, aes(x = V1, y = V2), 
             shape = 17,  # Código para triángulos
             size = 4,    # Tamaño más grande
             color = "black")+
  scale_color_manual(values = c("green")) + 
  ggtitle(paste0("Hijos por medio de la cruza de laplace con N = 100 y b =",b[1]))


# Gráficar cuando el parametro es alto
ggplot(hijos[etiqueta==unique(etiqueta)[2],],aes(x = V1,
                                                 y = V2,
                                                 color = etiqueta)) + 
  geom_point(size = 2) +
  theme_bw() + 
  theme(legend.position = "bottom") +
  geom_point(data = padres, aes(x = V1, y = V2), 
             shape = 17,  # Código para triángulos
             size = 4,    # Tamaño más grande
             color = "black")+
  scale_color_manual(values = c("red")) + 
  ggtitle(paste0("Hijos por medio de la cruza de laplace con N = 100 y b =",b[2]))


## Gráficar cuando ambos se comparan ##
ggplot(hijos,aes(x = V1,
                 y = V2,
                 color = etiqueta)) + 
  geom_point(size = 2) +
  theme_bw() + 
  theme(legend.position = "bottom") +
  geom_point(data = padres, aes(x = V1, y = V2), 
             shape = 17,  
             size = 4,    
             color = "black")  +
  scale_color_manual(values = c("green","red")) + 
  ggtitle(paste0("Hijos por medio de la cruza de laplace con N = 100 y b =",
                 b[1], "y ",b[2]))



#### Gráfico de densidad Laplaciana ####

library(ggplot2)
# Crear data frame
x <- seq(-5, 5, length.out = 500)
df <- data.frame(
  x = rep(x, 2),
  fx = c(
    (1 / (2 * 1.0)) * exp(-abs(x - 0) / 1.0),
    (1 / (2 * 0.5)) * exp(-abs(x - 0) / 0.5)
  ),
  b = factor(rep(c("b = 1.0", "b = 0.5"), each = length(x)))
)

# Graficar
ggplot(df, aes(x = x, y = fx, color = b)) +
  geom_line(size = 1.2) +
  scale_color_manual(values = c("red", "green")) +
  labs(x = "x", y = expression(f(x))) +
  theme_minimal() +
  theme(legend.title = element_blank())





