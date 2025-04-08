f = imread("cameraman.tif");

theta = pi/4;

T = [cos(theta) sin(theta) 0;
     -sin(theta) cos(theta) 0;
     0 0 1]

%% Transformación %%
tform = maketform("affine",T);

g = imtransform(f,tform);

imagesc(g)


%% Aplicar un arreglo afin para moverla %%
ruta = "Fig3.15(a)4.jpg";
im = imread(ruta);
fixed = im;

%% Aplicando el movimiento %%
moving = imresize(fixed,0.7);
moving = imrotate(moving,30,"bilinear","crop");

%% Mostrar %%
subplot(1,2,1)
imshow(im)
subplot(1,2,2)
imshow(moving)










