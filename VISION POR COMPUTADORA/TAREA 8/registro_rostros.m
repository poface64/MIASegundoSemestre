
%% Cargar los datos de los puntos %%
ruta1 = "C:\\Users\\Angel\\Desktop\\BioID1520 1\\data_points.mat";
data = load(ruta1);
points = data.data;

%% Cara de referencia 
ruta2 = "C:\\Users\\Angel\\Desktop\\BioID1520 1\\Im_Faces\\BioID_0001.pgm";
face = imread(ruta2);
NI = 1520;
% Extraer los puntos de la primera imagen
puntos1 = squeeze(points(1, :, :))'; % tamaño: 20 × 2


%% Registrar respecto a la primer imagen %%
% Proceso de registro %%
registro = zeros(NI, 2 , 20);
for m = 1:NI    
    % Convertir los puntos i-esimos a matriz
    coords = squeeze(points(m, :, :))';    
    % Obtener la transformación afín homogenea
    tform = fitgeotrans(coords, puntos1, 'affine');
    T = tform.T;
    % Obtención del registro
    for i = 1:20
        [x2, y2] = transformPointsForward(tform, ...
            coords(i,1), coords(i,2));
        % Acomodar las nuevas coordenadas 
        registro(m, 1, i) = x2;
        registro(m, 2, i) = y2;
    end
end



%% Obtener el ERM %%
errores = zeros(NI,1);
for m = 1:NI
    % Extraer los puntos registrados 
    puntos_m = squeeze(registro(m, :, :))'; % 20x2
    % Calcular la diferencia entre cada par de puntos
    dif = puntos_m - puntos1;
    % Calcular el error cuadratico medio %
    errores(m) = mean(sum((dif).^2,2));
end

%% Ordenar los errores de menor a mayor %%
[errores_ordenados, indices_ordenados] = sort(errores);

%% Seleccionar las 99 mejores imágenes %%
mejores99 = indices_ordenados(1:100);

%% Proyectando resultados %%

%% Proyectar la imagen con sus puntos %%
imshow(face);
hold on; % Mantener la imagen para dibujar encima
% Dibujar los puntos
plot(puntos1(:,1), puntos1(:,2), 'ro', 'MarkerSize', 5, 'LineWidth', 2);
hold off;

%% Distribución de todos los puntos %%
for i = 1:size(puntos1,1)
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(points(i, :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

%% Distribución de todos los puntos sobre la imagen %%
imshow(face);
hold on; % Mantener la imagen para dibujar encima
for i = 1:size(puntos1,1)
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(points(i, :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

%% Histograma de los errores %%
histogram(errores)

%% Distribución de los puntos registrados %%
for i = 1:NI
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(registro(i, :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

%% Distribución de los puntos registrados sobre la imagen %%
imshow(face);
hold on; % Mantener la imagen para dibujar encima
for i = 1:NI
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(registro(i, :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

%% Distribución de los mejores 100 %%
for i = 1:100
    % Mejores
    mj = mejores99;
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(registro(mj(i), :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

%% Distribución de los mejores 100  sobre la imagen %%
imshow(face);
hold on; % Mantener la imagen para dibujar encima
for i = 1:100
    % Mejores
    mj = mejores99;
    % Pasar por cada punto y extraer sus coordenadas
    puntosi = squeeze(registro(mj(i), :, :))'; % tamaño: 20 × 2
    % Armar un gráfico con los puntos 
    plot(puntosi(:,1), puntosi(:,2), 'ro', ...
        'MarkerSize', 5, 'LineWidth', 2);
    hold on; % Mantener la imagen para dibujar encima
end

