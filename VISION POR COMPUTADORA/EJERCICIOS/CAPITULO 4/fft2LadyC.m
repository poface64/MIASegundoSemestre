% FFT example-
clear all
close all

datos=imread('lena_pattern.tif');
datos=rgb2gray(datos);
datos2=double(datos);
figure
colormap(gray)
subplot(1,3,1)
imagesc(datos2);

f=fft2(datos2);
f2=fftshift(f);
subplot(1,3,2)
imagesc(log(abs(f2)));

[filas,columnas]=size(f2);
filtro=ones(filas,columnas);

f3=f2.*filtro;
f4=ifftshift(f3);
f5=ifft2(f4);

subplot(1,3,3)
imagesc(real(f5));