
%% Cargar la imagen de las monedas y mostrar %%
i = imread("eight.tif");
imshow(i)

%% Agregar un tipo de ruido %%

%g = imnoise(i,"gaussian",,2)
%j = imnoise(i,"salt & pepper",0.5)
%imshow(j)

%% Aplicar el filtrado con respecto de una mascara %%
%[B,c r] = roipoly(i)
%imagesc(B)
%colormap(gray)
imhist(i(B))




