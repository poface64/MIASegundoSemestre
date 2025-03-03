clear all
close all

I = double(imread('F3.jpg'));

w1=fspecial('laplacian',0.001);
w2=fspecial('log',3);
w3=fspecial('log',10,2);

Ilap = imfilter(I,w1);
Ilog1 = imfilter(I,w2);
Ilog2 = imfilter(I,w3);

subplot(2,2,1)
imagesc(I)
title('Original')
subplot(2,2,2)
imagesc(Ilap)
title('Laplace')
subplot(2,2,3)
imagesc(Ilog1)
title('LOG 3')
subplot(2,2,4)
imagesc(Ilog2)
title('LOG 20')
colormap(gray)

figure
I2=Ilap < 0;
imagesc(I2)
colormap(gray)