%% Función principal del seno difuso %%

function y_sugeno = sugenosin(x0)
    % Implementación de un sistema difuso tipo Sugeno para aproximar la función seno
    
    % Definir la función de membresía triangular
    function membership = triangular_mf(x, center, width)
        membership = max(0, 1 - abs(x - center) / (width/2)); % Ajuste del ancho
    end

    % Dominio de entrada para la evaluación
    x_min = 0;
    x_max = 2*pi;

    % Puntos centrales de las funciones de membresía (aproximadamente 8 partes)
    centers = linspace(x_min, x_max, 9);

    % Ancho de las funciones de membresía
    width = (x_max - x_min) / 4; % Un ancho que permite solapamiento significativo

    % Valores de salida de las reglas (valores del seno en los centros)
    rule_outputs = sin(centers);

    % Inicializar el valor de salida
    weights = zeros(size(centers));

    % Calcular los pesos de las funciones de membresía para el valor de entrada
    for j = 1:length(centers)
        weights(j) = triangular_mf(x0, centers(j), width);
    end

    % Calcular la salida Sugeno
    numerator = sum(weights .* rule_outputs);
    denominator = sum(weights);
    if denominator > 0
        y_sugeno = numerator / denominator;
    else
        y_sugeno = 0; % Evitar división por cero
    end
end



%% CASOS  de ejemplo %%
% Caso minimo %%
sugenosin(0)
% Caso medio %%
sugenosin(3.1416)
% Caso caso estandar %%
sugenosin(2*3.1416)

%% Evaluación y gráficas del sistema Sugeno para seno %%
% Dominio de evaluación
x_eval = linspace(0, 2*pi, 200);
% Evaluar la función difusa Sugeno para cada x
y_sugeno_eval = zeros(size(x_eval));
for i = 1:length(x_eval)
    y_sugeno_eval(i) = sugenosin(x_eval(i));
end
% Calcular la función seno real
y_real = sin(x_eval);
% Parámetros para las funciones de membresía
x_min = 0;
x_max = 2*pi;
centers = linspace(x_min, x_max, 9);
width = (x_max - x_min) / 4;
% Crear figura
plot(x_eval, y_real, 'b-', 'LineWidth', 2, 'DisplayName', 'Función Seno Real');
hold on;
plot(x_eval, y_sugeno_eval, 'r--', 'LineWidth', 2, 'DisplayName', 'Aproximación Sugeno');
scatter(centers, sin(centers), 60, 'k', 'filled', 'DisplayName', 'Centros de reglas');
xlabel('x');
ylabel('y');
title('Aproximación de la Función Seno con Sistema Difuso Sugeno');
legend('show');
grid on;

