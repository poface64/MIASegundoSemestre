
# Carghar el sistema difuso #
import pyit2fls as fz
import numpy as np

#### VARIABLES DE ENTRADA ####
#### Servicio ####
### Definir el rango de servicio ###
servicio_dom = np.linspace(0, 10, 100)
# Servicio: Malo (mu=1.5, sigma=[2.5,1.7])
servicio_maloMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [1.5, 2.5, 1],
                 fz.gaussian_mf, [1.5, 1.7, 0.5],
                 check_set=True)
# Servicio: Regular (mu=5, sigma=[2,1.5])
servicio_regularMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [5, 2, 1],
                 fz.gaussian_mf, [5, 1.5, 0.5],
                 check_set=True)
# Servicio: Bueno (mu=7.5, sigma=[2,1.5])
servicio_buenoMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [7.5, 2, 1],
                 fz.gaussian_mf, [7.5, 1.5, 0.5],
                 check_set=True)

### Mostrar gráfica de Servicio
fz.IT2FS_plot(servicio_maloMF,
              servicio_regularMF,
              servicio_buenoMF)

#### Comida ####
### Definir el rango de comida ###
comida_dom = np.linspace(0, 100, 1000)
# Comida: Malo (mu=15, sigma=[20,15])
comida_maloMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [15, 20, 1],
                 fz.gaussian_mf, [15, 15, 0.5],
                 check_set=True)

# Comida: Normal (mu=45.5, sigma=[20,15])
comida_normalMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [45.5, 20, 1],
                 fz.gaussian_mf, [45.5, 15, 0.5],
                 check_set=True)

# Comida: Buena (mu=66, sigma=[15,10])
comida_buenaMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [66, 15, 1],
                 fz.gaussian_mf, [66, 10, 0.5],
                 check_set=True)

# Comida: Excelente (mu=90, sigma=[20,15])
comida_excelenteMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [90, 20, 1],
                 fz.gaussian_mf, [90, 15, 0.5],
                 check_set=True)


### Mostrar gráfica de Servicio
fz.IT2FS_plot(comida_maloMF,
              comida_normalMF,
              comida_buenaMF,
              comida_excelenteMF)

#### VARIABLES DE SALIDA ####
#### PROPINA ####
### Definir el rango de comida ###
propina_dom = np.linspace(0, 20, 200)
# Propina: Baja (mu=5, sigma=[2.5,2])
propina_bajaMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [5, 2.5, 1],
                 fz.gaussian_mf, [5, 2, 0.5],
                 check_set=True)
# Propina: Normal (mu=10, sigma=[2.5,2])
propina_normalMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [10, 2.5, 1],
                 fz.gaussian_mf, [10, 2, 0.5],
                 check_set=True)
# Propina: Alta (mu=16, sigma=[2,1.5])
propina_altaMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [16, 2, 1],
                 fz.gaussian_mf, [16, 1.5, 0.5],
                 check_set=True)

### Mostrar gráfica de Servicio
fz.IT2FS_plot(propina_bajaMF,
              propina_normalMF,
              propina_altaMF,
              legends=["Baja", "Normal", "Alta"])


############# EXPLORANDO PARA HACER EL SISTEMA DE REGLAS #######
sistema = fz.IT2FLS()

# Variables de entrada al sistema #
sistema.add_input_variable("Servicio")
sistema.add_input_variable("Comida")
# Variables de salida #
sistema.add_output_variable("Propina")
### Definir la base de reglas ###
# Regla 1
sistema.add_rule([("Servicio", servicio_maloMF),("Comida", comida_maloMF)],
                 [("Propina", propina_bajaMF)])
# Regla 2
sistema.add_rule([("Servicio", servicio_buenoMF),("Comida", comida_normalMF)],
                 [("Propina", propina_normalMF)])
# Regla 3
sistema.add_rule([("Servicio", servicio_regularMF),("Comida", comida_normalMF)],
                 [("Propina", propina_normalMF)])
# Regla 4
sistema.add_rule([("Servicio",servicio_regularMF),("Comida",comida_buenaMF)],
                 [("Propina", propina_normalMF)])

# Regla 5
sistema.add_rule([("Servicio",servicio_buenoMF),("Comida",comida_excelenteMF)],
                 [("Propina", propina_altaMF)])
# Regla 6
sistema.add_rule([("Servicio",servicio_maloMF),("Comida",comida_excelenteMF)],
                 [("Propina", propina_bajaMF)])
# Regla 7
sistema.add_rule([("Servicio",servicio_buenoMF),("Comida",comida_maloMF)],
                 [("Propina", propina_bajaMF)])
# Regla 8
sistema.add_rule([("Servicio",servicio_maloMF),("Comida",comida_normalMF)],
                 [("Propina", propina_bajaMF)])
# Regla 9
sistema.add_rule([("Servicio",servicio_maloMF),("Comida",comida_buenaMF)],
                 [("Propina", propina_bajaMF)])
# Regla 10
sistema.add_rule([("Servicio",servicio_buenoMF),("Comida",comida_buenaMF)],
                 [("Propina", propina_altaMF)])
# Regla 11
sistema.add_rule([("Servicio",servicio_regularMF),("Comida",comida_maloMF)],
                 [("Propina", propina_bajaMF)])
# Regla 12
sistema.add_rule([("Servicio",servicio_regularMF),("Comida",comida_excelenteMF)],
                 [("Propina", propina_altaMF)])
                 



##########################

# ===== CONSULTA DIRECTA =====
print("=== SISTEMA DE CÁLCULO DE PROPINAS ===")
print()

#### Hacer la evaluación
from pyit2fls import min_t_norm, max_s_norm
inputs = {"Servicio":9, "Comida":90}
salida,tr = sistema.evaluate(inputs,min_t_norm,max_s_norm,propina_dom)
fz.crisp(tr["Propina"]) 

########################

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter

# Generar la malla de evaluación
X1, X2 = np.meshgrid(servicio_dom, comida_dom)
Z1 = np.zeros_like(X1)

# Evaluar el sistema en toda la malla
for i, x1 in enumerate(servicio_dom):
    for j, x2 in enumerate(comida_dom):
        # Evaluar el sistema con entradas actuales
        # Entradas del sistema
        inputs = {"Servicio":x1, "Comida":x2}
        # Aplicación del sistema
        it2out, tr = sistema.evaluate(inputs,min_t_norm,max_s_norm,propina_dom)
        # Obtener el valor crisp de la salida
        Z1[j, i] = fz.crisp(tr["Propina"])  # Nota: j, i por el orden del meshgrid

# Crear la figura 3D
fig = plt.figure(figsize=(10, 7))
ax = fig.add_subplot(111, projection="3d")

# Graficar la superficie
surf = ax.plot_surface(X1, X2, Z1, cmap=cm.viridis,
                       linewidth=0, antialiased=True)

# Etiquetas de los ejes
ax.set_xlabel("Servicio")
ax.set_ylabel("Comida")
ax.set_zlabel("Propina sugerida")

# Ajustar formato del eje Z
ax.zaxis.set_major_locator(LinearLocator(10))
ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Barra de color
fig.colorbar(surf, shrink=0.5, aspect=8)
plt.title("Superficie de decisión difusa tipo 2")
plt.tight_layout()
plt.show()


##################3
import plotly.graph_objects as go
import numpy as np

# Supongamos que ya tienes X1, X2 y Z1 definidos
# Si no los tienes definidos, deberías definirlos primero, por ejemplo:
# X1, X2 = np.meshgrid(np.linspace(0, 10, 50), np.linspace(0, 10, 50))
# Z1 = alguna función de X1 y X2

fig = go.Figure(data=[go.Surface(z=Z1, x=X1, y=X2, colorscale='Viridis')])

# Configuración del layout
fig.update_layout(
    title="Superficie de decisión difusa tipo 2",
    scene=dict(
        xaxis_title="Servicio",
        yaxis_title="Comida",
        zaxis_title="Propina sugerida"
    ),
    width=800,
    height=700,
    margin=dict(r=20, b=10, l=10, t=40)
)

# Mostrar el gráfico interactivo
fig.show()



