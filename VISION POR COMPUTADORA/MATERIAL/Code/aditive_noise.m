clear all
close all

original=imread('Fig3.30(a).jpg');
original=double(original)/255;

n=30;

for i=1:n
    noise=imnoise(original,'gaussian');
    volume(:,:,i)=noise;
end

promedio=volume(:,:,1);
for i=2:n
    promedio=promedio+volume(:,:,i);
end

promedio=promedio/n;

subplot(2,2,1)
imagesc(original)
title('Original');
subplot(2,2,2)
imagesc(noise)
title('Imagen con ruido')
subplot(2,2,3)
imagesc(promedio)
title('Promedio')
colormap(gray)
subplot(2,2,4)
ruido=original-noise;
imagesc(ruido)
colormap(gray)
%hist(reshape(ruido,685*741,1),50)
title('Ruido')
