% FFT example-
clear all
close all

datos=imread('lena_pattern.tif');
datos2 = datos
imshow(datos)
colormap(gray)

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




f3=f2;
f3(65,61)=f2(61,65);
f3(57,61)=f2(61,57);
f4=ifftshift(f3);
f5=ifft2(f4);
 
%imagesc(real(f5));

F6 = real(f5)
K1 = abs(f3(61,:))

imagesc(K1)
plot(K1)






