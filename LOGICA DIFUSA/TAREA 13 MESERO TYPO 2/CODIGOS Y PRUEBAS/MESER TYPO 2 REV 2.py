
# Cargar el sistema difuso #
import pyit2fls as fz
import numpy as np




#### VARIABLES DE ENTRADA ####
#### Servicio ####
### Definir el rango de servicio ###
servicio_dom = np.linspace(0, 10, 100)
# Servicio: Malo (mu=1.5, sigma=[2.5,1.7])
servicio_maloMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [1, 3, 1],
                 fz.gaussian_mf, [1, 2, 0.5],
                 check_set=True)
# Servicio: Regular (mu=5, sigma=[2,1.5])
servicio_regularMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [4, 3, 1],
                 fz.gaussian_mf, [4, 2.5, 0.5],
                 check_set=True)
# Servicio: Bueno (mu=7.5, sigma=[2,1.5])
servicio_buenoMF = fz.IT2FS(servicio_dom ,
                 fz.gaussian_mf, [8, 3, 1],
                 fz.gaussian_mf, [8, 2.5, 0.5],
                 check_set=True)

### Mostrar gráfica de Servicio
fz.IT2FS_plot(servicio_maloMF,
              servicio_regularMF,
              servicio_buenoMF,
              legends=["Malo", "Regular", "Bueno"])

#### Comida ####
### Definir el rango de comida ###
comida_dom = np.linspace(0, 10, 100)
# Comida: Malo (mu=15, sigma=[20,15])
comida_maloMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [1.5, 3, 1],
                 fz.gaussian_mf, [1.5, 2, 0.5],
                 check_set=True)

# Comida: Normal (mu=45.5, sigma=[20,15])
comida_normalMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [4.5, 3, 1],
                 fz.gaussian_mf, [4.5, 2, 0.5],
                 check_set=True)

# Comida: Buena (mu=66, sigma=[15,10])
comida_buenaMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [6.6, 2, 1],
                 fz.gaussian_mf, [6.6, 1.5, 0.5],
                 check_set=True)

# Comida: Excelente (mu=90, sigma=[20,15])
comida_excelenteMF = fz.IT2FS(comida_dom ,
                 fz.gaussian_mf, [10, 3, 1],
                 fz.gaussian_mf, [10, 2, 0.5],
                 check_set=True)
### Mostrar gráfica de Servicio
fz.IT2FS_plot(comida_maloMF,
              comida_normalMF,
              comida_buenaMF,
              comida_excelenteMF,
              legends=["Malo", "Normal", "Buena","Excelente"])

#### Lugar ####
### Definir el rango del Lugar ###
lugar_dom = np.linspace(0, 10, 100)
# Lugar: Malo (mu=2, sigma=[2.5,1.5])
lugar_maloMF = fz.IT2FS(lugar_dom ,
                 fz.gaussian_mf, [1, 3, 1],
                 fz.gaussian_mf, [1, 2, 0.5],
                 check_set=True)

# Lugar: Aceptable (mu=4, sigma=[2,1.5])
lugar_aceptableMF = fz.IT2FS(lugar_dom ,
                 fz.gaussian_mf, [4, 3, 1],
                 fz.gaussian_mf, [4, 2.5, 0.5],
                 check_set=True)

# Lugar: Agradable (mu=7, sigma=[2.5,2])
lugar_agradableMF = fz.IT2FS(lugar_dom ,
                 fz.gaussian_mf, [7, 2.5, 1],
                 fz.gaussian_mf, [7, 1.5, 0.5],
                 check_set=True)
# Lugar: Agradable (mu=8.5, sigma=[2,1.5])
lugar_excelenteMF = fz.IT2FS(lugar_dom ,
                 fz.gaussian_mf, [8.5, 2, 1],
                 fz.gaussian_mf, [8.5, 1.5, 0.5],
                 check_set=True)
# Proyectar la gráfica #
fz.IT2FS_plot(lugar_maloMF,
              lugar_aceptableMF,
              lugar_agradableMF,
              lugar_excelenteMF,
              legends=["Malo", "Aceptable",
              "Agradable","Excelente"])

#### VARIABLES DE SALIDA ####
#### PROPINA ####
### Definir el rango de comida ###
propina_dom = np.linspace(0, 20, 200)
# Propina: Pesima (mu=2, sigma=[2.5,2])
propina_pesimaMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [1, 4, 1],
                 fz.gaussian_mf, [1, 3, 0.5],
                 check_set=True)

# Propina: Baja (mu=5, sigma=[3,2.5])
propina_bajaMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [6, 4, 1],
                 fz.gaussian_mf, [6, 3, 0.5],
                 check_set=True)

# Propina: Normal (mu=11, sigma=[4,3.5])
propina_regularMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [12, 5, 1],
                 fz.gaussian_mf, [12, 4, 0.5],
                 check_set=True)
# Propina: Alta (mu=17, sigma=[4,3.5])
propina_altaMF = fz.IT2FS(propina_dom,
                 fz.gaussian_mf, [18, 5, 1],
                 fz.gaussian_mf, [18, 4, 0.5],
                 check_set=True)

### Mostrar gráfica de Servicio
fz.IT2FS_plot(propina_pesimaMF, propina_bajaMF,
              propina_regularMF,propina_altaMF,
              legends=["Pesima","Baja", "Regular","Alta"])


############# EXPLORANDO PARA HACER EL SISTEMA DE REGLAS #######
sistema = fz.IT2FLS()

# Variables de entrada al sistema #
sistema.add_input_variable("Servicio")
sistema.add_input_variable("Comida")
sistema.add_input_variable("Lugar")
# Variables de salida #
sistema.add_output_variable("Propina")


### Definir la base de reglas ###
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_maloMF),('Lugar',lugar_maloMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_maloMF),('Lugar',lugar_maloMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_maloMF),('Lugar',lugar_maloMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_normalMF),('Lugar',lugar_maloMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_maloMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_maloMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_pesimaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_maloMF),('Lugar',lugar_maloMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_normalMF),('Lugar',lugar_maloMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_normalMF),('Lugar',lugar_maloMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_buenaMF),('Lugar',lugar_maloMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_maloMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_maloMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_maloMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_normalMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_maloMF),('Lugar',lugar_agradableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_maloMF),('Lugar',lugar_agradableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_maloMF),('Lugar',lugar_agradableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_normalMF),('Lugar',lugar_agradableMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_maloMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_maloMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_maloMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_maloMF),('Comida',comida_normalMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_bajaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_normalMF),('Lugar',lugar_maloMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_normalMF),('Lugar',lugar_maloMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_buenaMF),('Lugar',lugar_maloMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_buenaMF),('Lugar',lugar_maloMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_excelenteMF),('Lugar',lugar_maloMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_normalMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_normalMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_buenaMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_buenaMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_excelenteMF),('Lugar',lugar_aceptableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_normalMF),('Lugar',lugar_agradableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_normalMF),('Lugar',lugar_agradableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_buenaMF),('Lugar',lugar_agradableMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_normalMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_normalMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_regularMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_buenaMF),('Lugar',lugar_agradableMF)],[('Propina',propina_altaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_excelenteMF),('Lugar',lugar_agradableMF)],[('Propina',propina_altaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_normalMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_altaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_buenaMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_altaMF)])
sistema.add_rule([('Servicio',servicio_regularMF),('Comida',comida_excelenteMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_altaMF)])
sistema.add_rule([('Servicio',servicio_buenoMF),('Comida',comida_excelenteMF),('Lugar',lugar_excelenteMF)],[('Propina',propina_altaMF)])



##########################

#### Función Auxiliar para evaluar ###
from pyit2fls import min_t_norm, max_s_norm
def evaluar_propina(servicio, comida, lugar):
    inputs = {
        "Servicio": servicio,
        "Comida": comida,
        "Lugar": lugar
    }
    salida, tr = sistema.evaluate(inputs, min_t_norm, max_s_norm, propina_dom)
    return fz.crisp(tr["Propina"])

#### Corrida minima
evaluar_propina(0,0,0)
#### Corrida media 
evaluar_propina(5,5,5)
#### Corrida Alta
evaluar_propina(10,10,10)

#### Hacer la evaluación
from pyit2fls import min_t_norm, max_s_norm
inputs = {"Servicio":8.5, "Comida":8.8, "Lugar":5.2}
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
fijarlugar = 9
# Evaluar el sistema en toda la malla
for i, x1 in enumerate(servicio_dom):
    for j, x2 in enumerate(comida_dom):
        # Evaluar el sistema con entradas actuales
        # Entradas del sistema
        inputs = {"Servicio":x1, "Comida":x2,"Lugar":fijarlugar}
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
# Cambiar ángulo de vista
ax.view_init(elev=15, azim=290)  # <- Ajusta estos valores a tu gusto
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

#######################################
# Generar la malla de evaluación
X3, X4 = np.meshgrid(comida_dom,lugar_dom)
Z2 = np.zeros_like(X3)
fijarservicio = 8
# Evaluar el sistema en toda la malla
for i, x3 in enumerate(comida_dom):
    for j, x4 in enumerate(lugar_dom):
        # Evaluar el sistema con entradas actuales
        # Entradas del sistema
        inputs = {"Servicio":fijarservicio,"Comida":x3,"Lugar":x4}
        # Aplicación del sistema
        it2out, tr = sistema.evaluate(inputs,min_t_norm,max_s_norm,propina_dom)
        # Obtener el valor crisp de la salida
        Z2[j, i] = fz.crisp(tr["Propina"])  # Nota: j, i por el orden del meshgrid

# Crear la figura 3D
fig2 = plt.figure(figsize=(10, 7))
ax1 = fig2.add_subplot(111, projection="3d")

# Graficar la superficie
surf1 = ax1.plot_surface(X3, X4, Z2,cmap=cm.viridis,
                       linewidth=0, antialiased=True)

# Cambiar ángulo de vista
ax1.view_init(elev=20, azim=250)  # <- Ajusta estos valores a tu gusto
# Etiquetas de los ejes
ax1.set_xlabel("Comida")
ax1.set_ylabel("Lugar")
ax1.set_zlabel("Propina sugerida")

# Ajustar formato del eje Z
ax1.zaxis.set_major_locator(LinearLocator(10))
ax1.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Barra de color
fig2.colorbar(surf1, shrink=0.5, aspect=8)
plt.title("Superficie de decisión difusa tipo 2")
plt.tight_layout()
plt.show()


