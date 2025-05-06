%% Cargar la imagen %%
%ruta = "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\TAREA 9\\REPORTE\\IMG\\IM1.jpg"
%ruta = "C:\\Users\\Angel\\Desktop\\MIASegundoSemestre\\VISION POR COMPUTADORA\\TAREA 9\\REPORTE\\IMG\\IM7.jpg";
%ruta = "Colors.BMP"
ruta = 'fabric.png';
I = imread(ruta);
%I = imread("cameraman.tif");

% Cameraman %%
subplot(1,3,1)
imshow(I);
title("Imagen original")

% Agregar clusters k = 6 %%
subplot(1,3,2)
[L,Centers] = imsegkmeans(I,6);
imagesc(L);
title("Imagen segmentada")

% Crear imagen vacía del mismo tamaño que I
segmented_img = zeros(size(I), 'like', I);

% Recorrer cada etiqueta y asignar el color correspondiente
for label = 1:size(Centers,1)
    mask = (L == label); % máscara lógica

    % Asignar los valores RGB del centroide a los píxeles correspondientes
    for c = 1:3
        channel = segmented_img(:,:,c);
        channel(mask) = Centers(label, c);
        segmented_img(:,:,c) = channel;
    end
end

% Mostrar la imagen segmentada con colores promedio
subplot(1,3,3)
imshow(segmented_img);
title('Segmentación con colores promedio');
