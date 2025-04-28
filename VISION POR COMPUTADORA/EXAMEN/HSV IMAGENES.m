%
%% Cargar la imagen %%
I = imread("IM1.jpeg");
imshow(I)

%% Mapear como un HSV %%
hsv = rgb2hsv(I);
imshow(hsv)

%% Explorar que rayos hay adentro %%
R = [min(min(I(:,:,1))),max(max(I(:,:,1)))] 
G = [min(min(I(:,:,2))),max(max(I(:,:,2)))] 
B = [min(min(I(:,:,3))),max(max(I(:,:,3)))]

%% Explorar que rayos hay adentro de HSV%%
H = [min(min(hsv(:,:,1))),max(max(hsv(:,:,1)))] 
S = [min(min(hsv(:,:,2))),max(max(hsv(:,:,2)))] 
V = [min(min(hsv(:,:,3))),max(max(hsv(:,:,3)))]

%% Moverle a: Intensidad
hsv1 = hsv;
hsv1(:,:,3) = 0.7*hsv(:,:,3);
subplot(2,2,1)
imagesc(hsv1(:,:,1))
colormap("gray")
subplot(2,2,2)
imagesc(hsv1(:,:,2))
colormap("gray")
subplot(2,2,3)
imagesc(hsv1(:,:,3))
colormap("gray")
% Reconstruir la imagen %
A1 = hsv2rgb(hsv1);
subplot(2,2,4)
imagesc(A1)
colormap("gray")











