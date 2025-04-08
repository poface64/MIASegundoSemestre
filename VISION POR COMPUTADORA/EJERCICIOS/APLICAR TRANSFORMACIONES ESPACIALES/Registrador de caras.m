%% Cargar las imagenes de los rostros %%
ruta1 = "Face1.bmp"
ruta2 = "Face2.bmp"
im1 = imread(ruta1);
im2 = imread(ruta2);

%% Mostrar la imagen %%
subplot(1,2,1)
imshow(im1)
subplot(1,2,2)
imshow(im2)

%% Aplicar los filtros %%
scale = 0.7;
distorted = imresize(im1,scale); % Try varying the scale factor.
theta = 30;
distorted = imrotate(distorted,theta); % Try varying the angle, theta.

%% Visualización de la cara 1 %%
subplot(1,2,1)
imagesc(im1)
subplot(1,2,2)
imagesc(distorted)
colormap(gray)


%% Pelearme con el registrador de landmarks %%
cpselect(im1,im2)

%% Sacar la proyección de la cosa %%
tform = fitgeotrans(movingPoints,fixedPoints,'affine'); % affine nonreflectivesimilarity
Roriginal = imref2d(size(im1));
recovered = imwarp(im2,tform,'OutputView',Roriginal);
figure
subplot(1,3,1)
imagesc(im1)
subplot(1,3,2)
imagesc(im2)
subplot(1,3,3)
imagesc(recovered)
colormap(gray)






