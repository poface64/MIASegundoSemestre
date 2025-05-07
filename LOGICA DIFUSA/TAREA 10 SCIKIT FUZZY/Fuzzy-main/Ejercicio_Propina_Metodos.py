import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl
import matplotlib.pyplot as plt

# Variables de entrada y salida
servicio = ctrl.Antecedent(np.arange(0, 11, 0.1), 'servicio')
comida = ctrl.Antecedent(np.arange(0, 101, 1), 'comida')
propina = ctrl.Consequent(np.arange(0, 21, 0.1), 'propina')

# Funciones de membresía personalizadas
servicio['malo'] = fuzz.trapmf(servicio.universe, [0, 0, 1.5, 3])
servicio['regular'] = fuzz.trapmf(servicio.universe, [1.5, 2.5, 4.5, 5.5])
servicio['bueno'] = fuzz.trapmf(servicio.universe, [4, 5.5, 7.5, 9])
servicio['excelente'] = fuzz.trapmf(servicio.universe, [7.5, 8.5, 10, 10])
comida['mala'] = fuzz.trapmf(comida.universe, [0, 0, 15, 30])
comida['normal'] = fuzz.trapmf(comida.universe, [15, 25, 45, 55])
comida['buena'] = fuzz.trapmf(comida.universe, [45, 55, 75, 85])
comida['excelente'] = fuzz.trapmf(comida.universe, [75, 85, 100, 100])
propina['baja'] = fuzz.trapmf(propina.universe, [0, 0, 4, 7])
propina['normal'] = fuzz.trapmf(propina.universe, [4, 7, 11, 14])
propina['alta'] = fuzz.trapmf(propina.universe, [11, 14, 20, 20])

# Reglas
reglas = [
    ctrl.Rule(servicio['malo'] & comida['mala'], propina['baja']),
    ctrl.Rule(servicio['malo'] & comida['normal'], propina['baja']),
    ctrl.Rule(servicio['malo'] & comida['buena'], propina['normal']),
    ctrl.Rule(servicio['malo'] & comida['excelente'], propina['normal']),
    ctrl.Rule(servicio['regular'] & comida['mala'], propina['baja']),
    ctrl.Rule(servicio['regular'] & comida['normal'], propina['normal']),
    ctrl.Rule(servicio['regular'] & comida['buena'], propina['normal']),
    ctrl.Rule(servicio['regular'] & comida['excelente'], propina['normal']),
    ctrl.Rule(servicio['bueno'] & comida['mala'], propina['normal']),
    ctrl.Rule(servicio['bueno'] & comida['normal'], propina['normal']),
    ctrl.Rule(servicio['bueno'] & comida['buena'], propina['alta']),
    ctrl.Rule(servicio['bueno'] & comida['excelente'], propina['alta']),
    ctrl.Rule(servicio['excelente'] & comida['mala'], propina['normal']),
    ctrl.Rule(servicio['excelente'] & comida['normal'], propina['normal']),
    ctrl.Rule(servicio['excelente'] & comida['buena'], propina['alta']),
    ctrl.Rule(servicio['excelente'] & comida['excelente'], propina['alta']),
]

# Crear sistema y simulación
sistema = ctrl.ControlSystem(reglas)
simulador = ctrl.ControlSystemSimulation(sistema)

# Asignar entradas
simulador.input['servicio'] = 9
simulador.input['comida'] = 56
simulador.compute()

# 2. Desfuzificar con otro método
from skfuzzy.defuzzify import defuzz

# Recalcular con la nueva desfuzificación #
x = propina.universe
aggregated = np.zeros_like(x)

for term_name, term_mf in propina.terms.items():
  # Obtener el valor de activación (recorte) para cada regla
  activation = fuzz.interp_membership(x, term_mf.mf, simulador.output['propina'])
  mf_recortada = np.fmin(activation, term_mf.mf)
  aggregated = np.fmax(aggregated, mf_recortada)

## Salida del programa ##
#'centroid'	Centroide: Calcula el centro de gravedad del área bajo la curva de membresía. Es el método más común y proporciona una media ponderada.
#'bisector'	Bisección: Encuentra el punto que divide el área bajo la curva en dos áreas iguales.
#'mom'	Mean of Maximum: Promedio de todos los valores de entrada con membresía máxima.
#'som'	Smallest of Maximum: El valor más pequeño que tiene la máxima pertenencia.
#'lom'	Largest of Maximum: El valor más grande que tiene la máxima pertenencia.
#'som', 'lom', 'mom', 'centroid'
metodo = 'centroid'
valor_propina = fuzz.defuzz(x, aggregated, metodo)
print(f"Propina sugerida ({metodo}): {valor_propina:.2f}%")


### Mostrar todo automatizado ###
import skfuzzy as fuzz

# Lista de métodos de desfusificación
metodos = ['centroid', 'bisector', 'mom', 'som', 'lom']

# Iterar sobre cada método
for metodo in metodos:
        valor_propina = fuzz.defuzz(x, aggregated, metodo)
        print(f"Propina sugerida ({metodo}): {valor_propina:.2f}%")




