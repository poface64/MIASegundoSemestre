close all 
clear all

H = lpfilter ('ideal',500,500,20);
I = lpfilter ('ideal',500,500,19);
f= H-I;
F1=ifft2(f);
F2=ifftshift(F1);
subplot(1,2,1)
imagesc(f);
subplot(1,2,2)
imagesc(abs(F2));
colormap(gray)
