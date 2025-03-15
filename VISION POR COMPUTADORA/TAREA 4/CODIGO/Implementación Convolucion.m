% Cargar la imagen y convertir a escala de grises
%I = imread("Fig3.35(a).jpg");
%imagen = double(I);  % Convertir a escala de grises


I = imread("IM1gray.jpg");
imagen = I
% Filtro para la convolución (Ejemplo de filtro de Sobel)
filtro = [-10, 0, 10;
           0, 0, 0;
           10, 0, -10];



% Tamaño de la imagen y filtro
[filas_imagen, columnas_imagen] = size(imagen);
[filas_filtro, columnas_filtro] = size(filtro);

% La imagen resultante tendrá un tamaño reducido (filas_imagen - filas_filtro + 1) x (columnas_imagen - columnas_filtro + 1)
imagen_resultado = zeros(filas_imagen - filas_filtro + 1, columnas_imagen - columnas_filtro + 1);

% Realizar la convolución
for i = 1:filas_imagen - filas_filtro + 1
    for j = 1:columnas_imagen - columnas_filtro + 1
        % Extraer una submatriz 3x3 de la imagen
        sub_imagen = imagen(i:i+filas_filtro-1, j:j+columnas_filtro-1);
        
        % Realizar la multiplicación elemento por elemento y sumatoria
        imagen_resultado(i, j) = sum(sum(sub_imagen .* filtro));
    end
end

% Mostrar la imagen original y la imagen resultante
subplot(1, 2, 1);
imshow(imagen);
title('Imagen Original');

%% Se obtiene el valor absoluto y listo %%
imagen_resultado1 = abs(imagen_resultado);
subplot(1, 2, 2);
imshow(imagen_resultado1, []);
colormap("gray")
title('Imagen después de la convolución');


