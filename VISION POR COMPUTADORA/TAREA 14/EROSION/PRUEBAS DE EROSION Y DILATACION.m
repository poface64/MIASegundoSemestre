
ruta = 'cameraman.tif'
%ruta = "texto.png"
%% EROSION %%
% Leer imagen binaria
I = imread(ruta);
BW = imbinarize(I);  % Asegurarse de que sea binaria
% Crear elemento estructurante
se = strel('square', 3);  % 3x3 cuadrado
% Aplicar erosión
BW_erosion = imerode(BW, se);
% Mostrar resultados
subplot(1, 2, 1);
imshow(BW);
title('Original');
subplot(1, 2, 2);
imshow(BW_erosion);
title('Erosión');


%% DILATACION %%
% Leer imagen en escala de grises
I = imread(ruta);
% Convertir a binaria
BW = imbinarize(I);
% Crear elemento estructurante
se = strel('square', 3);  % Elemento circular de radio 3
% Aplicar dilatación
BW_dilate = imdilate(BW, se);
% Mostrar resultados
subplot(1, 2, 1);
imshow(BW);
title('Original binaria');
subplot(1, 2, 2);
imshow(BW_dilate);
title('Dilatación');

%% Diferencia de gráficos %%
AC = abs(BW_dilate-BW_erosion);
AB = abs(BW_erosion-BW_dilate);
subplot(1, 2, 1);
imshow(AC)
subplot(1, 2, 2);
imshow(AB)


%% Dilatacion formas %%
%ruta = 'cameraman.tif'
% Leer imagen binaria de ejemplo
I = imread(ruta);
BW = imbinarize(I);  % Asegura que sea binaria
% Lista de elementos estructurantes a comparar
strels = {
    strel('square', 5), 'square';
    strel('disk', 5), 'disk';
    strel('diamond', 3), 'diamond';
    strel('line', 7, 0), 'line 0°';
    strel('line', 7, 90), 'line 90°';
    strel('rectangle', [3 7]), 'rectangle 3x7';
    strel('octagon', 3), 'octagon'
};

% Número de elementos
n = size(strels, 1);

% Mostrar imagen original
figure;
subplot(2, ceil((n+1)/2), 1);
imshow(BW);
title('Original');

% Aplicar dilatación con cada strel y mostrar
for k = 1:n
    se = strels{k, 1};
    name = strels{k, 2};
    
    BW_mod = imdilate(BW, se);
    subplot(2, ceil((n+1)/2), k+1);
    imshow(BW_mod);
    title(name);
end

sgtitle('Comparación de formas de strel en dilatación');

%% Erosión con todas las formas %%

% Leer imagen binaria de ejemplo (texto blanco sobre fondo negro)
I = imread(ruta);
BW = imbinarize(I);  % Asegura imagen binaria
% Lista de elementos estructurantes y sus etiquetas
strels = {
    strel('square', 5),        'square 5x5';
    strel('disk', 5),          'disk r=5';
    strel('diamond', 3),       'diamond r=3';
    strel('line', 7, 0),       'line 7 @ 0°';
    strel('line', 7, 90),      'line 7 @ 90°';
    strel('rectangle', [3 7]), 'rectangle 3x7';
    strel('octagon', 3),       'octagon r=3'
};

% Crear figura
figure;
sgtitle('Comparación de formas de strel en EROSIÓN');

% Mostrar imagen original
subplot(2, ceil((length(strels)+1)/2), 1);
imshow(BW);
title('Original');

% Aplicar erosión con cada estructurante
for k = 1:length(strels)
    se = strels{k, 1};     % Estructurante
    label = strels{k, 2};  % Título
    
    % Aplicar erosión
    BW_eroded = imerode(BW, se);
    
    % Mostrar resultado
    subplot(2, ceil((length(strels)+1)/2), k+1);
    imshow(BW_eroded);
    title(label);
end
