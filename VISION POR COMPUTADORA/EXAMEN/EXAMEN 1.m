

%% Cargar imagen 1  
ruta1 = "imagen1.png";
I1 = imread(ruta1);

%% Aplicar el histograma %%
R1 = histeq(I1); 

%% Comparativa %%
subplot(1,2,1)
imshow(I1)
%% Comparativa2 %%
subplot(1,2,2)
imshow(R1)


%% Cargar imagen 3 %%
ruta3 = "imagen3.jpg";
I3 = imread(ruta3);
gray = rgb2gray(I3);
imshow(I31)

%% Verlo con Fourier %%
% Transformada de Fourier centrada
F = fftshift(fft2(gray)); 
% fft2: calcula la transformada rápida de Fourier en 2D
% fftshift: mueve las bajas frecuencias al centro del espectro

% Obtener dimensiones de la imagen
[M, N] = size(gray);

% Crear una malla de coordenadas centradas
[u, v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1); 
% u y v son coordenadas espaciales en el dominio de frecuencia
% centradas en (0,0) (el centro de la imagen)

% Calcular la distancia radial desde el centro para cada punto
D = sqrt(u.^2 + v.^2);

% Parámetro del filtro: radio de corte
D0 = 50; 
% Crear el filtro gaussiano pasa bajas
H = exp(-(D.^2) / (2 * D0^2)); 
% Este filtro deja pasar las frecuencias cercanas al centro (bajas)
% y atenúa las lejanas (altas)
% Aplicar el filtro en el dominio de la frecuencia
F_filtered = F .* H;
% Transformada inversa para volver al dominio espacial
img_filtered = real(ifft2(ifftshift(F_filtered))); 
% ifftshift: devuelve el centro al lugar original
% ifft2: transformada inversa de Fourier
% real: tomamos solo la parte real (por errores numéricos puede haber parte imaginaria)
% Normalizar la imagen resultante al rango 0-255
F2 = uint8(mat2gray(img_filtered) * 255); 
imshow(F2)
% mat2gray escala la imagen entre 0 y 1
% uint8 convierte a una imagen de 8 bits (escala de grises)

%% Imagen 2 ESCANEO %%

original = imread("Imagen2_A.jpg"); % Reemplaza con la ruta de tu imagen de referencia
distorted = rgb2gray(imread("Imagen2_B.jpg")) ; % Reemplaza con la ruta de la imagen a registrar

%% Detect and extract features from both images.

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,validPtsOriginal] = ...
    extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
    extractFeatures(distorted,ptsDistorted);

index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));

%% Hacer el match %% 
showMatchedFeatures(original,distorted,...
    matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points,including outliers');

%% Excluir los outliers %%
[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'similarity');
showMatchedFeatures(original,distorted,...
    inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');

%% Recover the original image from the distorted image.
outputView = imref2d(size(original));
Ir = imwarp(distorted,tform,'OutputView',outputView);
imshow(Ir); 
title('Recovered image');
imshowpair(original,Ir)