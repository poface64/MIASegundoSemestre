

%% Distancia euclideana %%
function res = distanciaE(x,y)
    % Aplicar la distancia euclideana %
    res = sqrt(sum((x-y).^2));
end

%% Distancia de manhattan %%
function res = distanciaM(x,y)
    % Aplicar la distancia de manhatan %
    res = abs((x-y));
end

%% Distancia mahalanobis %%
function res = distanciaMH(x,y,data)
    %% Calcular la matriz de varianzas y covarianzas
    S = cov(data);
    %% Calcularle su inversa
    S1 = inv(S);
    % Aplicar la distancia de Mahalanobis %
    res = sqrt((x-y)*S1*transpose((x-y))) ;
end


%% Fuzzy C Means con proyección de centros al espacio PCA
function [salida, Vc, grafica] = fcmeans(X, k, m, tol, mi, distancia)
    n = size(X);

    %% Paso 1: Matriz fuzzy inicial aleatoria
    U = rand(n(1), k);
    for i = 1:n(1)
        U(i,:) = U(i,:) / sum(U(i,:));
    end

    %% Paso 5: Iteraciones hasta convergencia
    for iter = 1:mi
        %% Paso 2: Calcular centroides fuzzy
        Vc = zeros(k, n(2));
        for ki = 1:k
            Suki = sum(U(:,ki).^m);
            num = sum(X .* (U(:,ki).^m));
            Vc(ki,:) = num / Suki;
        end

        %% Paso 3: Actualizar pertenencia
        Uki = U;
        for i = 1:n(1)
            for ki = 1:k
                Acum = 0;
                for j = 1:k
                    switch lower(distancia)
                        case 'mahalanobis'
                            dista = distanciaMH(X(i,:), Vc(ki,:), X) / distanciaMH(X(i,:), Vc(j,:), X);
                        case 'euclidiana'
                            dista = distanciaE(X(i,:), Vc(ki,:)) / distanciaE(X(i,:), Vc(j,:));
                        case 'manhattan'
                            dista = distanciaM(X(i,:), Vc(ki,:)) / distanciaM(X(i,:), Vc(j,:));
                        otherwise
                            error('Distancia no reconocida.');
                    end
                    Acum = Acum + dista^(2/(m-1));
                end
                Uki(i,ki) = 1 / Acum;
            end
        end

        %% Paso 4: Verificar convergencia
        if max(max(abs(Uki - U))) < tol
            disp(['Convergió en ', num2str(iter), ' iteraciones.']);
            break
        else
            U = Uki;
        end
    end

    salida = U;

    %% Proyección PCA y visualización
    [coeff, score, ~] = pca(X);  % Proyección de los datos
    Vc_proj = (Vc - mean(X)) * coeff(:,1:2);  % Proyección de los centroides

    etiquetas = zeros(n(1),1);
    [~, etiquetas] = max(salida, [], 2);
    grafica = figure('Visible', 'on');
    gscatter(score(:,1), score(:,2), etiquetas, [], 'o', 10, 'filled');
    legend('off')
    hold on;
    colores = get(gca, 'ColorOrder');
    num_colores = size(colores, 1);

    % Graficar los centros proyectados
    for i = 1:k
        color_indice = mod(i - 1, num_colores) + 1;
        scatter(Vc_proj(i,1), Vc_proj(i,2), 800, colores(color_indice,:), 'x', 'LineWidth', 2);
    end
    hold off;
    grid on;
end

%% Kmeans para proyectar %%
function [C_proj] = grkmeans(X, k, distancia)
    % Verificar entrada
    if nargin < 3
        distancia = 'sqeuclidean'; % Distancia por defecto
    end

    % Aplicar K-means
    [idx, C] = kmeans(X, k, 'Distance', distancia);

    % Reducir a 2D con PCA (si X tiene más de 2 columnas)
    if size(X,2) > 2
        [coeff, score] = pca(X);
        X_proj = score(:,1:2);
        C_proj = (C - mean(X)) * coeff(:,1:2);
    else
        X_proj = X;
        C_proj = C;
    end

    % Graficar los resultados
    figure;
    gscatter(X_proj(:,1), X_proj(:,2), idx, [], 'o', 10, 'filled');
    title(['K-Means con k = ', num2str(k), ', distancia: ', distancia]);
    xlabel('Componente 1');
    ylabel('Componente 2');
    grid on;
    hold on;

    % Centroides
    colores = get(gca, 'ColorOrder');
    for i = 1:k
        color_indice = mod(i - 1, size(colores,1)) + 1;
        scatter(C_proj(i,1), C_proj(i,2), 800, colores(color_indice,:), 'x', 'LineWidth', 2);
    end
    hold off;
end



%% Obtener los coeficinetes de las membresias %%
%% Cargar los datos de iris %%
load fisheriris.mat

%% Asignar y procesar los valores a matrices
X = meas;


%% Corridas para la distancia euclidiana %%

%% Euclidiana con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "euclidiana");
grkmeans(X,3,'sqeuclidean')

%% Euclidiana con m = 1.6 %%
subplot(3,3,2)
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "euclidiana");
grkmeans(X,3,'sqeuclidean')

%% Euclidiana con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "euclidiana");
grkmeans(X,3,'sqeuclidean')

%% Corridas para la distancia mahalanobis %%

%% Mahalanobis con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "mahalanobis");
grkmeans(X,3,'sqeuclidean')

%% Mahalanobis con m = 1.6 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "mahalanobis");
grkmeans(X,3,'sqeuclidean')

%% Mahalanobis con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "mahalanobis");
grkmeans(X,3,'sqeuclidean')

%% Corridas para la distancia manhattan %%

%% Manhattan con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "manhattan");
grkmeans(X,3,'cityblock')

%% Manhattan con m = 1.6 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "manhattan");
grkmeans(X,3,'cityblock')

%% Manhattan con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "manhattan");
grkmeans(X,3,'cityblock')




