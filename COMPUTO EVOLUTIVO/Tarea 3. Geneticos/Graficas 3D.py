#### Gráfico problema 1 ####
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.colors import LinearSegmentedColormap
# Definimos la función (para x1 y x2, manteniendo las demás en 0)
def f(x1, x2):
  return x1**2 + x2**2
# Creamos los rangos para x1 y x2
x1 = np.linspace(-10, 10, 50)
x2 = np.linspace(-10, 10, 50)
# Creamos la malla de coordenadas
X1, X2 = np.meshgrid(x1, x2)
# Calculamos los valores de Z (f(x1, x2))
Z = f(X1, X2)
# Definimos la escala de color personalizada
colors = [(1, 0, 0), (0, 0, 1)]  # Rojo (0) a Azul (1)
cmap_rb = LinearSegmentedColormap.from_list("RedBlue", colors, N=256)
# Normalizamos los datos para que el 0 corresponda al inicio del colormap
norm = plt.Normalize(vmin=Z.min(), vmax=Z.max())
# Mapeamos los valores de Z al colormap
scalarMap = plt.cm.ScalarMappable(norm=norm, cmap=cmap_rb)
colorZ = scalarMap.to_rgba(Z)
# Creamos la figura y los ejes 3D
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
# Graficamos la superficie usando los colores mapeados
surf = ax.plot_surface(X1, X2, Z, facecolors=colorZ, shade=False)
# Añadimos etiquetas a los ejes
ax.set_xlabel('x1')
ax.set_ylabel('x2')
ax.set_zlabel('f(x)')
# Añadimos un título
ax.set_title('$f(x_1, x_2) = x_1^2 + x_2^2$')
# Añadimos una barra de color que mapea los valores a los colores
fig.colorbar(scalarMap, ax=ax, label='Valor de f(x)')
# Guardamos la figura como PNG con alta calidad
plt.savefig('superficie_3d.png', dpi=300, bbox_inches='tight')
# Opcionalmente, mostramos la gráfica en pantalla
# plt.show()


#### PROBLEMA 2 ####
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.colors import LinearSegmentedColormap
# Definimos la función de Rastrigin para D=10, restringida a x1 y x2
def rastrigin_2d(x1, x2):
  return 20 + (x1**2 - 10 * np.cos(2 * np.pi * x1)) + (x2**2 - 10 * np.cos(2 * np.pi * x2))

# Creamos los rangos para x1 y x2
x1 = np.linspace(-5.12, 5.12, 100)
x2 = np.linspace(-5.12, 5.12, 100)
# Creamos la malla de coordenadas
X1, X2 = np.meshgrid(x1, x2)
# Calculamos los valores de Z (f(x1, x2))
Z = rastrigin_2d(X1, X2)
# Definimos la escala de color personalizada: rojo a azul
colors = [(1, 0, 0), (0, 0, 1)]  # Rojo (valor bajo) a Azul (valor alto)
cmap_rb = LinearSegmentedColormap.from_list("RedBlue", colors, N=256)
# Normalizamos los datos para que el valor mínimo corresponda al rojo y el máximo al azul
norm = plt.Normalize(vmin=Z.min(), vmax=Z.max())
# Mapeamos los valores de Z al colormap
scalarMap = plt.cm.ScalarMappable(norm=norm, cmap=cmap_rb)
colorZ = scalarMap.to_rgba(Z)
# Creamos la figura y los ejes 3D
fig = plt.figure(figsize=(12, 10))
ax = fig.add_subplot(111, projection='3d')
# Graficamos la superficie usando los colores mapeados
surf = ax.plot_surface(X1, X2, Z, facecolors=colorZ, shade=False, rstride=1, cstride=1)
# Añadimos etiquetas a los ejes
ax.set_xlabel('$x_1$')
ax.set_ylabel('$x_2$')
ax.set_zlabel('$f(\mathbf{x})$')
# Añadimos un título con LaTeX
ax.set_title('$f(X) = 20 + x_1^2 - 10\cos(2\pi x_1) + x_2^2 - 10\cos(2\pi x_2)$')
# Añadimos una barra de color que mapea los valores a los colores
fig.colorbar(scalarMap, ax=ax, label='Valor de $f(\mathbf{x})$')
# Guardamos la figura como PNG con alta calidad
plt.savefig('rastrigin_2d_rb.png', dpi=300, bbox_inches='tight')
# Mostramos la gráfica
plt.show()


