
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


%% Fuzzy C means %%
function [salida, Vc, grafica] = fcmeans(X, k, m, tol, mi, distancia)
    % Tamaño de la matriz
    n = size(X);
    %% Paso 1: Crear la matriz fuzzy random original %%
    % Crear una matriz de tamaño N x K %
    U = rand(n(1),k);
    for i =  1:n(1)
        % Estandarizar cada filla
        U(i,:) =  U(i,:)/sum(U(i,:));
    end
    %% Paso 5: Repetir hasta un maximo de iteraciones %%
    for iter = 1:mi
        %% Paso 2: Proponer la matriz de centroides %%
        Vc = zeros(k,n(2));
        % Hacer el calculo del centroide fuzzy %
        for ki = 1:k
            % Hacer el calculo de cada centroide por columna 
            Suki = sum(U(:,ki).^m);
            % Ponderar el vector %
            num = sum(X.* (U(:,ki).^m));
            % Guardar el valor %
            Vc(ki,:) = (num/Suki);
        end 

        %% Paso 3: Actualizar la matriz de pertenencia %%
        Uki = U;
        for i = 1:n(1)
            for ki = 1:k
                %% Hacer la logica del ciclo
                % Definir un acumulador de la suma interna
                % Para cada sujeto
                Acum = 0;
                for j = 1:k
                    % Armar la cosa
                    % Con distancia Mahalanobis
                    if distancia == "mahalanobis"
                        dista =  distanciaMH(X(i,:),Vc(ki,:),X)/distanciaMH(X(i,:),Vc(j,:),X);
                    end
                    % Con distancia Euclidiana
                    if distancia == "euclidiana"
                        dista =  distanciaE(X(i,:),Vc(ki,:))/distanciaE(X(i,:),Vc(j,:));
                    end
                    % Con distancia manhattan
                    if distancia == "manhattan"
                        dista =  distanciaM(X(i,:),Vc(ki,:))/distanciaM(X(i,:),Vc(j,:));
                    end

                    % Acumular el valor
                    Acum = Acum + dista^(2/(m-1));
                end
                Uki(i,ki) = 1/Acum;
            end
        end
      
        %% Paso 4: Actualizar la matriz de pertenencia %%
        if max(max(abs(Uki - U))) < tol
                disp(['Convergió en ', num2str(iter), ' iteraciones.']);
                break
        else 
            % Actualiza la matriz y sigue repitiendo
            U = Uki;
        end    
    end
    % Definir la salida
    salida = U;
    
    %% Parte de graficación automática %%
    etiquetas = zeros(n(1),1);
    % Obtener las etiquetas
    [~, etiquetas] = max(salida, [], 2);
    grafica = figure('Visible', 'on');
    % Gráfico base de los puntos por grupo
    gscatter(X(:,1), X(:,2), etiquetas, [], 'o', 10, 'filled');
    legend('off')
    hold on;
    % Obtener los colores utilizados por gscatter
    colores = get(gca, 'ColorOrder');
    num_colores = size(colores, 1);
    % Graficar los centros con forma de cruz y color respectivo
    for i = 1:size(Vc, 1)
        color_indice = mod(i - 1, num_colores) + 1;
        scatter(Vc(i,1), Vc(i,2), 200, colores(color_indice,:), 'x', 'LineWidth', 2);
    end
    legend('off')
    hold off;
    grid on;
end

%% Obtener los coeficinetes de las membresias %%
%% Cargar los datos %%
ruta = "FUZZY.xlsx";
X = xlsread(ruta);


%% Corridas para la distancia euclidiana %%

%% Euclidiana con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "euclidiana");

%% Euclidiana con m = 1.6 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "euclidiana");

%% Euclidiana con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "euclidiana");

%% Corridas para la distancia mahalanobis %%

%% Euclidiana con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "mahalanobis");

%% Euclidiana con m = 1.6 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "mahalanobis");

%% Euclidiana con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "mahalanobis");

%% Corridas para la distancia manhattan %%

%% Euclidiana con m = 1.3 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.3, 0.001, 100, "manhattan");

%% Euclidiana con m = 1.6 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.6, 0.001, 100, "manhattan");

%% Euclidiana con m = 1.9 %%
[matriz_pert, centros, grafica] = fcmeans(X, 3, 1.9, 0.001, 100, "manhattan");



