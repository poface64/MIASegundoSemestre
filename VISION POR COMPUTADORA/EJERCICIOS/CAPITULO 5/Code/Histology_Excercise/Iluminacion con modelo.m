

%% Ruta %%
load('Histology.mat', 'img')
im = img;
im2 = img_degradada;
im3 = noisy_plane;
%imagesc(im) %[36, 253]
%[min(min(im)) max(max(im))]
%imagesc(im2) %[-1859, 1396]
%[min(min(im2)) max(max(im2))]
%imagesc(im3) %[-21642, 1387]
%[min(min(im3)) max(max(im3))]
% Degradada menos el plano
imex = im2-im3;
imagesc(imex)
colormap("gray")

%% Aplicar el procesado de la imagen %%
cont=1;
Z = reshape(ones(400),[160000,1]);
% Logica de la cosa
for x=1:400
    for y=1:400
        X(cont)=x;
        Y(cont)=y;
        cont=cont+1;
    end
end

%% Parte de la regresión lineal %%
A=[X' Y' ones(length(X),1)];
Z=reshape(im3,400*400,1);
p=regress(Z,A)


%% Armar la cosa de salida para crear el plano %%
for x=1:400
    for y=1:400
        plane(x,y)=-5.0009*x+ 2.9996*y+10.3427; %
        cont=cont+1;
    end
end

%% Restar el plano a la imagen degradada %%
res2 = im2-plane;
subplot(1,3,1)
imagesc(res2)
colormap("gray")
subplot(1,3,2)
imagesc(im)
colormap("gray")
subplot(1,3,3)
surf(plane)
colormap("gray")




