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
% F3(61,65)=F3(61,65)*0;
% F3(61,57)=F3(61,57)*0;
% H = lpfilter('ideal',120,120,4);
% Hgrande = lpfilter('ideal',120,120,5);
% circulo =abs(H - Hgrande);
% 
% [x,y]=find(circulo == 1);
% for i=1:length(x)
%      F3(x(i),y(i))=F2(61,65);
% end

F4=ifftshift(F3);
f5=ifft2(F4);
figure 
imagesc(real(f5));
