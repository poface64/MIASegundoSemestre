
%% Cargar la imagen %%
%ruta = "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\TAREA 9\\REPORTE\\IMG\\IM1.jpg"
%ruta = "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\TAREA 9\\REPORTE\\IMG\\IM7.jpg";
%ruta = "Colors.BMP"
ruta = 'fabric.png';
img = imread(ruta);
%I = imread("cameraman.tif");

% Cameraman %%
subplot(2,3,1)
imshow(I);
title("Imagen original")

% Agregar clusters k = 6 %%
subplot(2,3,2)
[L,Centers] = imsegkmeans(I,6);
imagesc(L);
title("Imagen segmentada")

% Agregar clusters k = 6 %%
subplot(2,3,3)
[L,Centers] = imsegkmeans(I,6);
imagesc(L);
title("Imagen segmentada")

% Agregar clusters k = 6 %%
subplot(2,3,4)
[L,Centers] = imsegkmeans(I,6);
imagesc(L);
title("Imagen segmentada")


%% Calcular los centros %%
% Suponiendo que img es MxNx3 y L es MxN
num_labels = 6; % número de etiquetas
segmented_img = zeros(size(img), 'like', img); % para guardar la imagen segmentada

for label = 1:num_labels
    % Crear máscara lógica para la etiqueta actual
    mask = (L == label);
    % Extraer los píxeles correspondientes en cada canal
    r_vals = img(:,:,1);
    g_vals = img(:,:,2);
    b_vals = img(:,:,3);
    % Calcular el promedio de cada canal
    r_mean = mean(r_vals(mask));
    g_mean = mean(g_vals(mask));
    b_mean = mean(b_vals(mask));    
    % Asignar ese color promedio a todos los píxeles con esa etiqueta
    segmented_img(:,:,1) = segmented_img(:,:,1) + uint8(mask) * uint8(r_mean);
    segmented_img(:,:,2) = segmented_img(:,:,2) + uint8(mask) * uint8(g_mean);
    segmented_img(:,:,3) = segmented_img(:,:,3) + uint8(mask) * uint8(b_mean);
end

% Mostrar la imagen segmentada
imshow(segmented_img);
title('Imagen Segmentada por Color Promedio de Etiquetas');

