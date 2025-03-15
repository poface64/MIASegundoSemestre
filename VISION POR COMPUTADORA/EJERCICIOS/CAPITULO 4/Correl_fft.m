clear all
close all

I = imread('text.png');

%kernel = imcrop(I);
kernel = I(32:45,88:98);

F=fft2(I);
H=fft2(rot90(kernel,2),256,256);
    
C = real(ifft2(F.*H)); 

max(C(:))
thresh = 60;
    
[y x]=find(C > thresh);

imshow(C,[]) 
hold on
plot(x,y,'oy')