
%% Interpolación bilineal %%
function valor = bilineal(imagen,x,y)
    [filas,columnas] = size(imagen);

    % Coordenadas vecinas más próximas
    x1 = floor(x); x2 = ceil(x);
    y1 = floor(y); y2 = ceil(y);

    % Limitar los valores al rango válido
    if x1 < 1 || x2 > columnas || y1 < 1 || y2 > filas
        valor = 0;
        return;
    end

    % Valores de píxeles vecinos
    Q11 = double(imagen(y1,x1));
    Q21 = double(imagen(y1,x2));
    Q12 = double(imagen(y2,x1));
    Q22 = double(imagen(y2,x2));

    % Pesos
    dx = x - x1;
    dy = y - y1;

    % Interpolación bilineal
    valor = (1-dx)*(1-dy)*Q11 + ...
             dx*(1-dy)*Q21 + ...
            (1-dx)*dy*Q12 + ...
             dx*dy*Q22;
end

%% Transformación afin %%
function salida = trans_afin(imagen,Tx,Ty,sx,sy,theta)
    % Definir una matriz de escalado %%
    S = [sx, 0, 0;
         0, sy, 0;
         0, 0, 1];
    % Definir una matriz de rotación en grados (no radianes) %%
    % Convertir los grados a radianes
    theta1 = theta * pi/180;
    % Definir la matriz de rotación %
    R = [cos(theta1), -sin(theta1),0;
         sin(theta1), cos(theta1), 0;
         0,0,1];
    % Definir la matriz de Traslación %%
    T = [1,0,Tx;
        0, 1, Ty;
        0, 0, 1];
    % Orden de aplicación %%
    % Se define el orden de aplicación tal cual se desarrollaron: Escalar,
    % Rotar y Trasladar en ese orden.   
    M = T * R * S;
    % Base de la salida %%
    D = size(imagen);
    salida = zeros(D,"uint8");
    % Inversa de la matriz de transformación% 
    Minv = inv(M);
    % Aplicar aqui la interpolación %
    for i = 1:D(1)
        for j = 1:D(2)
            % Coordenadas de destino (x', y')
            destino = [j;i;1];
            
            % Coodenadas de origen (x,y) con la inversa %
            origen = Minv * destino;
            x = origen(1);
            y = origen(2);
            % Verificar validez del rango
            if x>=1 && x<=D(2) && y>=1 && y<=D(1)
                %  Aplicar la interpolación
                valor = bilineal(imagen,x,y);
                salida(i,j) = uint8(valor);
            end
        end
    end
end


%% Prueba de la transformación %%
I = imread("IMG\\F1.jpg");
imagen = rgb2gray(I);

%% Mostrar la imagen %
imshow(imagen);

%% Solo traslación %
R1 = trans_afin(imagen,50,30,1,1,0);
imshow(R1)

%% Solo rotación %
R2 = trans_afin(imagen,0,0,1,1,30);
imshow(R2)

%% Escalado NO uniforme %
R3 = trans_afin(imagen,0,0,1.5,0.5,0);
imshow(R3)

%% Combinación completa %
R4 = trans_afin(imagen,-40,60,0.8,1.2,-30);
imshow(R4)

