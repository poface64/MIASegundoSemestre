clear all
close all

I=double(imread('fig3.35(a).jpg'));
F=fft2(I);
F2=fftshift(F);
H = lpfilter ('gauss',500,500,10);
F3=F2.*(1-H);
F4=ifftshift(F3);
f5=ifft2(F4);
subplot(2,1,1)
imagesc(I);
subplot(2,1,2)
imagesc(real(f5));
