import numpy as np
from pyIT2FLS import IT2FS, IT2FLS, IT2Mamdani, Centroid, KM_algorithm
import matplotlib.pyplot as plt

# Definir el dominio para las variables
temp_domain = np.linspace(0, 50, 101)  # Temperatura de 0 a 50°C
fan_domain = np.linspace(0, 100, 101)  # Velocidad del ventilador de 0 a 100%

# === CREAR CONJUNTOS DIFUSOS TIPO 2 PARA LA ENTRADA (TEMPERATURA) ===

# Conjunto "Fría" - Trapezoidal
temp_fria = IT2FS(temp_domain)
temp_fria.trapezoid([0, 0, 10, 20], [0, 0, 8, 18], check_params=False)

# Conjunto "Templada" - Triangular
temp_templada = IT2FS(temp_domain)
temp_templada.trimf([15, 25, 35], [13, 25, 37])

# Conjunto "Caliente" - Trapezoidal
temp_caliente = IT2FS(temp_domain)
temp_caliente.trapezoid([30, 40, 50, 50], [32, 42, 50, 50], check_params=False)

# === CREAR CONJUNTOS DIFUSOS TIPO 2 PARA LA SALIDA (VELOCIDAD VENTILADOR) ===

# Conjunto "Lenta"
fan_lenta = IT2FS(fan_domain)
fan_lenta.trapezoid([0, 0, 20, 40], [0, 0, 15, 35], check_params=False)

# Conjunto "Media"
fan_media = IT2FS(fan_domain)
fan_media.trimf([20, 50, 80], [25, 50, 75])

# Conjunto "Rápida"
fan_rapida = IT2FS(fan_domain)
fan_rapida.trapezoid([60, 80, 100, 100], [65, 85, 100, 100], check_params=False)

# === CREAR EL SISTEMA DE LÓGICA DIFUSA TIPO 2 ===
sistema = IT2FLS()

# Agregar variables de entrada y salida
sistema.add_input_variable("Temperatura")
sistema.add_output_variable("VelocidadVentilador")

# === DEFINIR LAS 3 REGLAS DEL SISTEMA ===

# Regla 1: Si la temperatura es Fría, entonces la velocidad es Lenta
sistema.add_rule([("Temperatura", temp_fria)], [("VelocidadVentilador", fan_lenta)])

# Regla 2: Si la temperatura es Templada, entonces la velocidad es Media
sistema.add_rule([("Temperatura", temp_templada)], [("VelocidadVentilador", fan_media)])

# Regla 3: Si la temperatura es Caliente, entonces la velocidad es Rápida
sistema.add_rule([("Temperatura", temp_caliente)], [("VelocidadVentilador", fan_rapida)])

# === EVALUACIÓN DEL SISTEMA ===

def evaluar_sistema(temperatura_input):
    """
    Evalúa el sistema difuso para una temperatura dada
    """
    print(f"\n=== EVALUACIÓN PARA TEMPERATURA: {temperatura_input}°C ===")
    
    # Crear diccionario de entrada
    inputs = {"Temperatura": temperatura_input}
    
    # Evaluar el sistema usando el algoritmo de Karnik-Mendel
    # El algoritmo KM se aplica automáticamente en la defuzzificación
    output = sistema.evaluate(inputs)
    
    # Obtener el valor de salida
    velocidad_salida = output["VelocidadVentilador"]
    
    print(f"Velocidad del ventilador calculada: {velocidad_salida:.2f}%")
    
    return velocidad_salida

# === EJEMPLOS DE EVALUACIÓN ===

# Probar con diferentes temperaturas
temperaturas_prueba = [5, 25, 45]

print("SISTEMA DE CONTROL DE VENTILADOR CON LÓGICA DIFUSA TIPO 2")
print("=" * 60)

resultados = []
for temp in temperaturas_prueba:
    velocidad = evaluar_sistema(temp)
    resultados.append((temp, velocidad))

# === MOSTRAR RESUMEN ===
print(f"\n{'='*60}")
print("RESUMEN DE RESULTADOS:")
print(f"{'='*60}")
for temp, vel in resultados:
    print(f"Temperatura: {temp:2d}°C → Velocidad ventilador: {vel:5.2f}%")

# === EXPLICACIÓN DEL ALGORITMO KARNIK-MENDEL ===
print(f"\n{'='*60}")
print("SOBRE EL ALGORITMO KARNIK-MENDEL:")
print(f"{'='*60}")
print("""
El algoritmo Karnik-Mendel (KM) se utiliza automáticamente en pyIT2FLS
para la defuzzificación de conjuntos difusos tipo 2.

Pasos del algoritmo KM:
1. Calcula los límites superior e inferior del conjunto difuso resultante
2. Encuentra los puntos de conmutación para optimizar la defuzzificación
3. Calcula el centroide del conjunto difuso tipo 2
4. Retorna el valor crisp final

En este ejemplo, el algoritmo se ejecuta internamente cuando llamamos
a sistema.evaluate(inputs).
""")

# === VISUALIZACIÓN OPCIONAL ===
print(f"\n{'='*60}")
print("Para visualizar los conjuntos difusos, descomenta el código siguiente:")
print(f"{'='*60}")

"""
# Código para visualización (descomenta para usar):

plt.figure(figsize=(12, 8))

# Gráfica de conjuntos de entrada
plt.subplot(2, 1, 1)
temp_fria.plot(title="Conjuntos Difusos Tipo 2 - Temperatura")
temp_templada.plot()
temp_caliente.plot()
plt.legend(['Fría', 'Templada', 'Caliente'])
plt.xlabel('Temperatura (°C)')
plt.ylabel('Grado de pertenencia')
plt.grid(True)

# Gráfica de conjuntos de salida
plt.subplot(2, 1, 2)
fan_lenta.plot(title="Conjuntos Difusos Tipo 2 - Velocidad Ventilador")
fan_media.plot()
fan_rapida.plot()
plt.legend(['Lenta', 'Media', 'Rápida'])
plt.xlabel('Velocidad (%)')
plt.ylabel('Grado de pertenencia')
plt.grid(True)

plt.tight_layout()
plt.show()
"""
	
