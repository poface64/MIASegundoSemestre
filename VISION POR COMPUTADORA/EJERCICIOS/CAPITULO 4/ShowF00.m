clear all
close all

I = imread('cameraman.tif');

sum(sum(I))

F=fft2(I);
F2=fftshift(F);

F2(129,129)

subplot(2,1,1)
imagesc(I)
subplot(2,1,2)
imagesc(log(abs(F2)))

colormap(gray)

figure
F2(129,129)=F2(129,129)/2;
F3=F2;
F4=ifftshift(F3);
f5=ifft2(F4);

subplot(2,1,1)
imagesc(I);
subplot(2,1,2)
imagesc(real(f5));
colormap(gray)

v1=reshape(I,256*256,1);
v2=reshape(real(f5),256*256,1);

subplot(1,2,1)
histogram(v1);
subplot(1,2,2)
histogram(v2)
