clear all
close all
I = imread('F3.jpg');
I=double(I);

w=fspecial('log',3);

O = imfilter(I,w);

subplot(1,2,1)
imagesc(I)
title('Original')
subplot(1,2,2)
imagesc(O)
title('LOG')
colormap(gray)