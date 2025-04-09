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



%% CASOS %%
% Caso minimo %%
sugenosin(0)
% Caso medio %%
sugenosin(3.1416)
% Caso caso estandar %%
sugenosin(2*3.1416)

%% Gráficas y cositas %%







% Calcular la función seno real para comparar
y_real = sin(x_eval);

% Crear figura con dos subplots
figure('Position', [100, 100, 900, 700]);

% 1. Gráfico de las funciones de membresía triangulares
subplot(2, 1, 1);
hold on;
colors = jet(length(centers)); % Colores para las funciones de membresía
legends = cell(1, length(centers));

% Calcular y graficar cada función de membresía
for j = 1:length(centers)
    mf_values = zeros(size(x_eval));
    for i = 1:length(x_eval)
        mf_values(i) = triangular_mf(x_eval(i), centers(j), width);
    end
    plot(x_eval, mf_values, 'Color', colors(j,:), 'LineWidth', 1.5);
    legends{j} = ['MF ' num2str(j)];
end

xlabel('Entrada (x)');
ylabel('Grado de Membresía');
title('Funciones de Membresía Triangulares');
grid on;
legend(legends, 'Location', 'eastoutside');

% 2. Gráfico de la aproximación versus la función real
subplot(2, 1, 2);
plot(x_eval, y_real, 'b-', 'LineWidth', 2, 'DisplayName', 'Función Seno Real');
hold on;
plot(x_eval, y_sugeno, 'r--', 'LineWidth', 2, 'DisplayName', 'Aproximación Sugeno');
scatter(centers, rule_outputs, 50, 'k*', 'filled', 'DisplayName', 'Centros de Reglas');
hold off;
xlabel('Entrada (x)');
ylabel('Salida (y)');
title('Aproximación de la Función Seno con Lógica Difusa Sugeno');
legend('show');
grid on;

% Calcular y mostrar el error cuadrático medio
mse = mean((y_real - y_sugeno).^2);
fprintf('Error cuadrático medio (MSE): %f\n', mse);

% Versión alternativa, si necesitas graficar las funciones de membresía en figura separada
figure('Position', [100, 100, 900, 500]);
hold on;
title('Funciones de Membresía Triangulares');
xlabel('x');
ylabel('Grado de Membresía');

% Calcular y graficar cada función de membresía en figura separada
for j = 1:length(centers)
    mf_values = zeros(size(x_eval));
    for i = 1:length(x_eval)
        mf_values(i) = triangular_mf(x_eval(i), centers(j), width);
    end
    plot(x_eval, mf_values, 'LineWidth', 2);
end

% Añadir puntos para mostrar los centros de las funciones de membresía
scatter(centers, ones(size(centers))*0.2, 80, 'filled', 'MarkerFaceColor', 'k');
for j = 1:length(centers)
    text(centers(j), 0.25, ['c' num2str(j)], 'HorizontalAlignment', 'center');
end

grid on;
legend(legends, 'Location', 'eastoutside');

