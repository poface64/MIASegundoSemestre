
w = fspecial("log",50,5)
mesh

%% Aplicación del kernel generado %%

I = imread("Fig3.35(a).jpg");
I = double(I);
w = fspecial("log",[5 5],3);
O = imfilter(I,w);
subplot(1,2,1)
imagesc(I)
title("original")
subplot(1,2,2)
imagesc(O)
title("LOG")
colormap("gray")




% Cargar la imagen y convertir a escala de grises
I = imread("Fig3.35(a).jpg");

%%%%
[Gx, Gy] = imgradientxy(I);
[Gmag,Gdir] = imgradient(Gx,Gy);



subplot(2,2,1), imshow(Gmag,[]),title("Gradient Magnitude")
subplot(2,2,2), imshow(Gdir,[]),title("Dirección del gradiente")
subplot(2,2,3), imshow(Gx,[]),title("Dirección del gradiente en X")
subplot(2,2,4), imshow(Gy,[]),title("Dirección del gradiente en Y")


%% Bordes en matlab %%


I = imread("Fig3.35(a).jpg");
BW1 = edge(I,"prewitt");
BW2 = edge(I,"sobel");
BW3 = edge(I,"canny");
subplot(2,2,1), imshow(BW1)
subplot(2,2,2), imshow(BW2)
subplot(2,2,3), imshow(BW3)

%% HACER UN AJEDREZ %%

I = checkerboard(50);

%% Operador de Roberts %%
BW1 = edge(I,"roberts");
imshow(BW1)

%% HOG en matlab %%
img = imread("cameraman.tif")
[featureVector,hogVisualization] = extractHOGFeatures(img);

subplot(1,2,1)
imshow(img)
subplot(1,2,2)
plot(hogVisualization)





%% Aplicación del Laplaciano para el mejoramiento de imagen %%
I = imread("Fig3.40(a).jpg");
%imshow(I)

%% Calcular el laplaciano %%
w = fspecial("log",[10 10],1);
O = imfilter(I,w);
%%% Binarizar la imagen %%%
A = imagesc(O)

%%%% Detector de bordes verticales en X
Gx = [-1 0 1;
       -1 0 1;
       -1 0 1]
%%%% Detector de bordes horizontales en Y
Gx = [-1 0 1;
       -1 0 1;
       -1 0 1]


















