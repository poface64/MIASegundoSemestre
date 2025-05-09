
%% Cargar la imagen de las monedas %
ruta =  "Gray_matter.jpg";
I = rgb2gray(imread(ruta));

%% Como segmentarias la materia gris de la imagen %%

%% Intento por Gray Tresh %%
level = graythresh(I); %0.4941
BW = imbinarize(I,level);
subplot(1,2,2)
imshow(BW)
subplot(1,2,1)
imshow(I)

%% Aplicar el region Grow %%





%% Aplicar Los arboles %

S = qtdecomp(I,.27);
blocks = repmat(uint8(0),size(S));
for dim = [512 256 128 64 32 16 8 4 2 1];    
  numblocks = length(find(S==dim));    
  if (numblocks > 0)        
    values = repmat(uint8(1),[dim dim numblocks]);
    values(2:dim,2:dim,:) = 0;
    blocks = qtsetblk(blocks,S,dim,values);
  end
end
blocks(end,1:end) = 1;
blocks(1:end,end) = 1;
imshow(I)
figure
imshow(blocks,[])








