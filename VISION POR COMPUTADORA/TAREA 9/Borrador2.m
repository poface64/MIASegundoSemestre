%% Distancia euclideana %%
function res = distanciaE(x,y)
    % Aplicar la distancia euclideana %
    res = sqrt(sum((x-y).^2));
end

%% Cargar la ruta y la imagen %%
ruta = "REPORTE\\IMG\\DN1.1.jpg";
img = imread(ruta);
imshow(ruta)
% Seleccionar un pixel con el mouse %%
% Paso 2: Seleccionar un píxel con el mouse
[x, y] = ginput(1);  % Permite seleccionar 1 punto con clic
% Paso 3: Redondear coordenadas a índices válidos
pixel = img(round(x), round(y), :); % Recuerda que entra en RGB

%% Procesado %%
% Convertir de RGB a HSV %
im1 = rgb2hsv(img);
% Definir un punto de referencia %
pixelr = rgb2hsv(pixel);
% Tomar el pixel de referencia y mandarlo a HSV %
vec = [pixelr(:,:,1) pixelr(:,:,2)];
% Defginir la mascara de salida %
[n,p,~] = size(im1);
mascara = zeros(n, p);
% Extraer el H y el S %
H = im1(:,:,1);
S = im1(:,:,2);
umbral = 0.15;

%% Ciclo for para recorrer todo %%
for i = 1:n
    for j = 1:p
        % Armarlo como si fuera un vector %
        pixelhs = [H(i,j),S(i,j)];
        dist = distanciaE(pixelhs, vec);
        % Hacer la verificación
        if dist <= umbral
                mascara(i, j) = 1;
        end
    end
end
%% Aplicar la mascara sobre la imagen original %%
imgres = img;
imgres(repmat(~mascara, [1 1 3])) = 0;

%% Gráficar bonito %%
subplot(2,2,1)
% Imagen original
imshow(img)
% Gráficar el pixel
subplot(2,2,2)
imshow(pixel)
% Gráficar la mascara
subplot(2,2,3)
imshow(mascara)
% Gráficar los que sobreviven
subplot(2,2,4)
imshow(imgres)


