clear all
close all

x=1:120;
s=sin(x*pi/15); % Signal 4 cicle.
M=repmat(s,120,1);

M2=M+M';
%M2=M;
imagesc(M2);
F=fft2(M2);
F2=fftshift(F);
F3=F2;
F3(65,61)=0; %F2(61,65);
F3(57,61)=0; %F2(61,57);
F4=ifftshift(F3);
f5=ifft2(F4);

subplot(2,1,1)
imagesc(real(F3))
colormap(gray)
subplot(2,1,2)
imagesc(real(f5));
colormap(gray)
