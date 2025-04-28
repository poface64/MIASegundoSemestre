
%% Distancia euclideana %%
function res = distancia(x,y)
    % Aplicar la distancia euclideana
    res = sum((x-y).^2);
end

%% Cargar los datos %%
ruta = "FUZZY.xlsx";
X = xlsread(ruta);

%% Parametros iniciales %%
% Definir número de clusters
k = 2;
% Parámetro de difusidad
m = 1.5;
% Tamaño de la matriz
n = size(X);
% Error de tolerancia
tol = 0.001;
% Máximo número de iteraciones (opcional para evitar bucles infinitos)
max_iter = 100;

%% Paso 1: Crear la matriz fuzzy random inicial %%
U = rand(n(1),k);
for i =  1:n(1)
    % Normalizar cada fila para que sumen 1
    U(i,:) =  U(i,:) / sum(U(i,:));
end

%% Iterar hasta convergencia %%
for iter = 1:max_iter
    % Guardar la U anterior para verificar convergencia
    U_old = U;
    
    %% Paso 2: Calcular los centroides %%
    Vc = zeros(k, n(2)); % Inicializar
    for ki = 1:k
        % Calcular cada centroide
        Suki = sum(U(:,ki).^m);
        num = sum(X .* (U(:,ki).^m)); % Operación vectorizada
        Vc(ki,:) = num / Suki;
    end

    %% Paso 3: Actualizar la matriz de pertenencia %%
    for i = 1:n(1) % Para cada dato
        for ki = 1:k % Para cada cluster
            acum = 0;
            for j = 1:k
                % Distancia del dato i al centroide ki y al centroide j
                dista = distancia(X(i,:), Vc(ki,:)) / distancia(X(i,:), Vc(j,:));
                acum = acum + dista^(2/(m-1));
            end
            U(i,ki) = 1 / acum;
        end
    end
    
    %% Paso 4: Verificar convergencia %%
    if max(max(abs(U - U_old))) < tol
        disp(['Convergió en ', num2str(iter), ' iteraciones.']);
        break
    end
end

%% Resultado final %%
disp('Centroides finales:');
disp(Vc);

disp('Matriz de pertenencia final:');
disp(U);


%% Gráficar %%

% --- Asignar cada punto al cluster de mayor pertenencia ---
[~, etiquetas] = max(U, [], 2); % etiquetas = índice del cluster más fuerte
colores = lines(k); % 'lines' genera colores bonitos automáticamente
figure;
hold on;
grid on;
title('Fuzzy C-Means Clustering (2D)');
xlabel('Variable 1');
ylabel('Variable 2');
% Graficar los datos
for ki = 1:k
    scatter(X(etiquetas==ki,1), X(etiquetas==ki,2), 36, colores(ki,:), 'filled');
end
% Graficar los centroides
scatter(Vc(:,1), Vc(:,2), 100, 'k', 'x', 'LineWidth', 2);
legend(["Cluster 1", "Cluster 2", "Cluster 3", "Centroides"], 'Location', 'best');
hold off;
