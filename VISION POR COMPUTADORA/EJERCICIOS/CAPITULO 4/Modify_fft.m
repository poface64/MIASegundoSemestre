clear all
close all

x=1:120;

s=sin(x*pi/15); % Modify

M=repmat(s,120,1); % M+M’

imagesc(M); 

F=fft2(M);

F2=fftshift(F);

imagesc(abs(F2))

F3=F2;
F3(65,61)=F2(61,65);
F3(57,61)=F2(61,57);
F4=ifftshift(F3);
f5=ifft2(F4);
 
%imagesc(real(f5));

F6 = real(f5)
K1 = abs(F3(61,:))

imagesc(K1)
plot(K1)
plot(F3)

colormap("gray")