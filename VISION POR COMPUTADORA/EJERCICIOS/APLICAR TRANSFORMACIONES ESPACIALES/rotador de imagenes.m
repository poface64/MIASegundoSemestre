
%% Cargar la imagen %%
ruta = "Fig2.21(a).jpg";
im = imread(ruta);
imshow(im)
fixed = double(im);

%% Aplicar las transformaciones %%
moving = imresize(fixed,0.7);
moving = imrotate(moving,30,"bilinear","crop");

%% Mostrar el resultado %%
%imshow(moving)
imshowpair(fixed,moving,"Scaling","independent")

%% Aplicar la optimización
[optimizer,metric] = imregconfig("monomodal")

%% Aplicar el imregister %%
movingregister = imregister(moving,fixed,"affine",optimizer,metric);

%% Mostrar el resultado %%
imshowpair(fixed,movingregister,"Scaling","joint")


%% Agregar ruido a la imagen original %%
% Agregar ruido gaussiano (media = 0, varianza = 0.01)
imruido = imnoise(im, 'gaussian', 0, 0.1);
imagesc(imruido)
colormap("gray")
fixed = double(imruido);
%% Aplicar las transformaciones %%
moving = imresize(fixed,0.7);
moving = imrotate(moving,30,"bilinear","crop");

%% Mostrar el resultado %%
%imshow(moving)
imshowpair(fixed,moving,"Scaling","independent")

%% Aplicar la optimización
[optimizer,metric] = imregconfig("monomodal")

%% Aplicar el imregister %%
movingregister = imregister(moving,fixed,"affine",optimizer,metric);

%% Mostrar el resultado %%
imshowpair(fixed,movingregister,"Scaling","joint")









