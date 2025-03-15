clear all
close all

f=double(imread('fig3.35(a).jpg'));
h = fspecial('average')
gs = imfilter(double(f), h);
h=[-2 -1 0; -1 0 1; 0 1 2]
%PQ = paddedsize(size(f));
PQ = size(f);
H = freqz2(h, PQ(1), PQ(2));

subplot(1,2,1)
imshow(abs(H), [ ])
subplot(1,2,2)
mesh(abs(H))

F=fft2(f);
F2=fftshift(F);
F3=F2.*H;
F4=ifftshift(F3);
gf=ifft2(F4);

figure
subplot(1,2,1)
imshow(gs, [ ])
title('Space')
subplot(1,2,2)
imshow(real(gf), [ ])
title('Frequency')
