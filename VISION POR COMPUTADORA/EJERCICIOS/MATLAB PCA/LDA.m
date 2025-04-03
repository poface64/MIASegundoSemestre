X = [1:5 1:3 3 5 6];
Y = [2 3 3 5 5 0 1 1:3 5];
data = [X', Y'];
labels = categorical([repmat("C1",5,1); repmat("C2",6,1)] );

% Gráficar en 2D
classes = unique(labels);
num_classes = length(classes);
for i = 1:num_classes
    scatter(data(labels==classes(i),1), data(labels == classes(i),2),'filled')
    hold on
end
legend(classes)


%%% Identificar las submatrices %%%

datos1 = data(1:5,:)
datos2 = data(6:11,:)

%%% Extraer los vectores de medias
m1 = mean(datos1)
m2 = mean(datos2)

%%% Extraer la matriz de varianzas y covarianzas %%%
%% Dentro de clases
SB = (m1-m2)'*(m1-m2);
%% Entre las clases
S1 = (datos1-m1)'*(datos1-m1);
S2 = (datos2-m2)'*(datos2-m2);
Sw = S1+S2;

%%% Definir la matriz a la que se le va a sacar los eigenvalores
S = inv(Sw)*SB

%% Obtener los eigenvalores %%
[coefs,lambdas] = eig(S)

%% Hacer las proyecciones del LDA %%

dataP = data * coefs(:,2)

% Gráficar en 2D
classes = unique(labels);
num_classes = length(classes);
for i = 1:num_classes
    scatter(dataP(labels==classes(i),1), dataP(labels == classes(i),1),'filled')
    hold on
end
legend(classes)

%% Probando la invertibilidad de la cosa %%

Wk = inv(Sw)*(m1-m2)';
a = (m1-m2)*Wk;
Wk1 = a*Wk/1.6884















