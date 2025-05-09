import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl
import matplotlib.pyplot as plt 
from mpl_toolkits.mplot3d import Axes3D



def definir_funciones_membresia():
    servicio = ctrl.Antecedent(np.arange(0, 11, 0.1), 'servicio')
    comida = ctrl.Antecedent(np.arange(0, 101, 1), 'comida')
    propina = ctrl.Consequent(np.arange(0, 21, 0.1), 'propina')

    servicio.automf(names=['malo', 'regular', 'bueno', 'excelente'])
    comida.automf(names=['mala', 'normal', 'buena', 'excelente'])
    propina.automf(names = ['baja', 'normal', 'alta'])

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
    
    return servicio, comida, propina



def definir_reglas_difusas(servicio, comida, propina):
    reglas = [
        # Reglas para servicio 'Malo'
        ctrl.Rule(antecedent=(servicio['malo'] & comida['mala']), consequent=propina['baja']),
        ctrl.Rule(antecedent=(servicio['malo'] & comida['normal']), consequent=propina['baja']),
        ctrl.Rule(antecedent=(servicio['malo'] & comida['buena']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['malo'] & comida['excelente']), consequent=propina['normal']),
        
        # Reglas para servicio 'Regular'
        ctrl.Rule(antecedent=(servicio['regular'] & comida['mala']), consequent=propina['baja']),
        ctrl.Rule(antecedent=(servicio['regular'] & comida['normal']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['regular'] & comida['buena']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['regular'] & comida['excelente']), consequent=propina['normal']),
        
        # Reglas para servicio 'Bueno'
        ctrl.Rule(antecedent=(servicio['bueno'] & comida['mala']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['bueno'] & comida['normal']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['bueno'] & comida['buena']), consequent=propina['alta']),
        ctrl.Rule(antecedent=(servicio['bueno'] & comida['excelente']), consequent=propina['alta']),
        
        # Reglas para servicio 'Excelente'
        ctrl.Rule(antecedent=(servicio['excelente'] & comida['mala']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['excelente'] & comida['normal']), consequent=propina['normal']),
        ctrl.Rule(antecedent=(servicio['excelente'] & comida['buena']), consequent=propina['alta']),
        ctrl.Rule(antecedent=(servicio['excelente'] & comida['excelente']), consequent=propina['alta'])
    ]

    return reglas



def crear_sistema_control(reglas, valor_servicio, valor_comida):
    
    sistema_propina = ctrl.ControlSystem(reglas)
    calculador_propina = ctrl.ControlSystemSimulation(sistema_propina)
    
    calculador_propina.input['servicio'] = valor_servicio
    calculador_propina.input['comida'] = valor_comida  

    calculador_propina.compute()

    print(f"Propina sugerida: {calculador_propina.output['propina']:.2f}%")
    
    return calculador_propina




def visualizar_funcionen_membresia(servicio, comida, propina, calculador_propina):
    servicio.view()
    comida.view()
    propina.view()
    propina.view(sim=calculador_propina)
    
    
    
def visualizar_superficie(sim_superficie, servicio, comida, propina, reglas):
    servicio_range = (0, 10, 50)
    comida_range = (100, 0, 50) 
    n_points = 21
    
    x_vals = np.linspace(servicio_range[0], servicio_range[1], n_points)
    y_vals = np.linspace(comida_range[0], comida_range[1], n_points) 
    x, y = np.meshgrid(x_vals, y_vals)
    z = np.zeros_like(x)
    

    for i in range(n_points):
        for j in range(n_points):
            sim_superficie.input['servicio'] = x[i, j]
            sim_superficie.input['comida'] = y[i, j] 
            sim_superficie.compute()
            z[i, j] = sim_superficie.output['propina']

    fig = plt.figure(figsize=(12, 10))
    ax = fig.add_subplot(111, projection='3d')
    
    surf = ax.plot_surface(x, y, z, rstride=1, cstride=1, cmap='viridis',
                         linewidth=0.4, antialiased=True)
    

    ax.set_xlabel('Servicio (0-10)')
    ax.set_ylabel('Comida (100-0)', labelpad=10) 
    ax.set_zlabel('Propina (%)')
    

    fig.colorbar(surf, shrink=0.5, aspect=5, label='Nivel de Propina')
    

    ax.view_init(30, 225)
    
    plt.tight_layout()
    plt.show()
    


servicio, comida, propina = definir_funciones_membresia()
reglas = definir_reglas_difusas(servicio, comida, propina)
calculador_propina = crear_sistema_control(reglas, 9, 56)
visualizar_funcionen_membresia(servicio, comida, propina, calculador_propina)
visualizar_superficie(calculador_propina, servicio, comida, propina, reglas)


