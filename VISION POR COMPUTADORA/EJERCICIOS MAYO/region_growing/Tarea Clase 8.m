clear all
close all


%% Abrir la imagen %%
I = im2double(imread('medtest.png'));

%x=198; y=359;
imagesc(I)
colormap(gray)

[y,x]=ginput(1);

x=round(x);
y=round(y);

J = regiongrowing(I,x,y,0.2); 
figure, imshow(I+J);