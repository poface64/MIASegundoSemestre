
%% Cargar la base de datos de iris %%

iris = load('fisheriris.mat')
datos = iris.meas;

%% Visualizar %%
subplot(2,2,1)
scatter(datos(:,1),datos(:,2) )
subplot(2,2,2)
scatter(datos(:,1),datos(:,3) )
subplot(2,2,3)
scatter(datos(:,1),datos(:,4) )
subplot(2,2,4)
scatter(datos(:,2),datos(:,3) )

%% Cambio de coordenadas %%
medias = mean(datos)
cdatos = datos - medias % Estandarizar permite simetria entre las variables
% Permite garantizar que el vector 0 exista con la estandarización.

%%Proyectar los datos en un nuevo subespacio incorrelacionado%%

% La proyección recupera la idea de la regresión lineal de minimizar el error de proyección %%
% O maximizar la distancia del origen a las proyecciones 
% En este caso, es más facil calcular la distancia de las proyecciones en
% lugar de minimizar los errores.
% Se usa la maximización de la suma de las distancias al cuadrado.
% En un caso simple para X y Y, asumiendo que se ve desde la regresión
% lineal
% Se establece una propuesta y una restricción: w0 = 0.9982 y w1 = 0.06
% Restricción: circulo unitario (nomra 1) para normalizar: w0^2 + w1^2 = 0
% SSD(w) = XW

% La covarianza nos dice como se dispersan hacia todos lados la información
S = cov(datos)

% Calcular los eigen valores %
[V, D] = eig(S)

% D = Eigenvalores
% V vectores que generan la cosa

100*diag(D)/sum(diag(D))

%% Reordenamiento %%

NB = cdatos * V

% Dado que las proyecciones más grandes son de las columnas 4 y 3
% respectivamente

% Proyectar los scores de 4 y 3
%scatter(NB(:,4),NB(:,3),"filled")
especies = iris.species
gscatter(NB(:,4), NB(:,3),especies)
colororder("reef")



%% PCA DE MATLAB %%
[coeff, scores, latent, ~, explained] = pca(datos);

scores(1:5,:)




