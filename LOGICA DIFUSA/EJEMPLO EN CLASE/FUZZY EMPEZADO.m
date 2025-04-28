
%% Cargar los datos 
ruta = "FUZZY.xlsx"
X = xlsread(ruta);

%% Parametros iniciales %%
% Definir un K
k = 3;
% Definir un m
m = 1.5;
% Tamaño de la matriz
n = size(X);

%% Primera parte %%
%% Crear una matriz de tamaño N x K %%
U = rand(n(1),k)



%% Llenar cada fila con numeros random que sumen 1









