
%% Cargar los datos %%
ruta = "FUZZY.xlsx"
X = xlsread(ruta);

%% Parametros iniciales %%
% Definir un K
k = 3;
% Definir un m
m = 1.5;
% Tamaño de la matriz
n = size(X);
% Error de tolerancia
tol = 0.001
%% Paso 1: Crear la matriz fuzzy random original %%
% Crear una matriz de tamaño N x K %
U = rand(n(1),k);
for i =  1:n(1)
    % Estandarizar cada filla
    U(i,:) =  U(i,:)/sum(U(i,:));
end

%% Paso 2: Calcular los centroides %%
Vc = zeros(1,k);
% Hacer el calculo del centroide fuzzy %
for ki = 1:k
    % Hacer el calculo de cada centroide por columna 
    Suki = sum(U(:,ki).^m);
    % Ponderar el vector %
    num = sum(sum(X.* (U(:,ki).^m)));
    % Guardar el valor %
    Vc(ki) = (num/Suki);
end

%% Paso 3: Actualizar la matriz de pertenencia %%










