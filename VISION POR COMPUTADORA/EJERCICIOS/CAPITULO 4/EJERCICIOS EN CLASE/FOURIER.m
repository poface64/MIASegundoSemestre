
% Cargar la imagen de Lena
ruta = "lena_pattern.tif"
img = imread(ruta);
%imshow(img);

% Aplicar la transformada
M2 = img
imagesc(M2);
F=fft2(M2);

% Aplicar la transformada
F2=fftshift(F);
F3=F2
imagesc(1-real(F3))
colormap(gray)

% Identificados los pixeles, se cambia %
F3(61,57)=0; %Encuentra las frecuencias ruidosas en esas posiciones
F3(61,65)=0; %Encuentra las frecuencias ruidosas en esas posiciones

% Aplicar el shift sobre la ttf2
F4=ifftshift(F3);
F5=ifft2(F4);

%% Gráficar los resultados %%
subplot(2,1,1)
imagesc(1-real(F3))
colormap(gray)
subplot(2,1,2)
imagesc(real(F5));
colormap(gray)

% Frecuencias detecta texturas y patrones en FA
% El del espacio es más comprensible pero este tipo de tareas
% se vuelven más complicados