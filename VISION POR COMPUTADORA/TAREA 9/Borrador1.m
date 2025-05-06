
%% Cargar la ruta y la imagen %%
ruta = "REPORTE\\IMG\\DN1.1.jpg"
img = imread(ruta);
imshow(ruta)
% Seleccionar un pixel con el mouse %%
% Paso 2: Seleccionar un píxel con el mouse
[x, y] = ginput(1);  % Permite seleccionar 1 punto con clic
% Paso 3: Redondear coordenadas a índices válidos
pixel = img(round(x), round(y), :); % Recuerda que entra en RGB


%% Convertir de RGB a HSV %%
im1 = rgb2hsv(img);

%% Gráficar y hacer la comparativa %%
subplot(2,2,1)
imshow(img)
subplot(2,2,2)
imshow(pixel)
%% Gráficar el espacio HSV %%
subplot(2,2,3)
imshow(im1)


%% Prueba del espacio HSV %%
subplot(2,2,1)
imshow(img)
subplot(2,2,2)
imshow(pixel)
%% Manipular la V para ser más intensa %
im11 = im1;
im11(:,:,3) = im11(:,:,3)*0.2;
subplot(2,2,3)
imshow(hsv2rgb(im11))

% Manipular la V para ser menos intensa  %
im12 = im1;
im12(:,:,3) = im12(:,:,3)*1.5;
subplot(2,2,4)
imshow(hsv2rgb(im12))















