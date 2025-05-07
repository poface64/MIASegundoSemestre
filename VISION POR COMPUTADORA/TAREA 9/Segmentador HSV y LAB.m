%% Distancia Euclideana %%
function d = distanciaE(x, y)
    d = sqrt(sum((x - y).^2));
end

%% Función que transforma entre espacios
function [pixel, mascara, imgres] = SegEspacios(img, espacio, umbral)
    %% Mostrar imagen y seleccionar pixel %%
    fig = figure;
    imshow(img);
    title('Haz zoom (botón de lupa) y presiona ENTER cuando estés listo');
    zoom on;
    pause;
    zoom off;
    title('Ahora selecciona un pixel con un clic');
    [col, fila] = ginput(1);
    pixel = img(round(fila), round(col), :);
    close(fig);
    disp(['Coordenadas del pixel: x=', num2str(round(col)), ', y=', num2str(round(fila))]);
    disp(['Color RGB: ', num2str(squeeze(pixel)')]);

    %% Conversión al espacio de color hsv o lab %%
    switch lower(espacio)
        % CASO PARA HSV
        case 'hsv'
            img_convertido = rgb2hsv(img);
            pixel_ref = rgb2hsv(pixel);
            ref_vec = [pixel_ref(:,:,1), pixel_ref(:,:,2)];
            A = img_convertido(:,:,1);
            B = img_convertido(:,:,2);
        % CASO PARA LAB
        case 'lab'
            img_convertido = rgb2lab(img);
            pixel_ref = rgb2lab(pixel);
            ref_vec = [pixel_ref(:,:,2), pixel_ref(:,:,3)];
            A = img_convertido(:,:,2);
            B = img_convertido(:,:,3);
        otherwise
            error('Espacio de color no válido. Usa "hsv" o "lab".');
    end

    %% Crear máscara basada en distancia euclideana %%
    [n, p, ~] = size(img); % Obtener las dimensiones
    mascara = zeros(n, p); % Crear la mascara vacia
    % Identificar pixel a pixel si cumple o no el umbral
    for i = 1:n
        for j = 1:p
            color_vec = [A(i,j), B(i,j)];
            if distanciaE(color_vec, ref_vec) <= umbral
                mascara(i,j) = 1;
            end
        end
    end

    %% Aplicar la máscara a la imagen %%
    imgres = img;
    imgres(repmat(~mascara, [1 1 3])) = 0;

    %% Mostrar resultados %%
    figure;
    subplot(2,2,1); imshow(img); title('Imagen original');
    subplot(2,2,2); imshow(pixel); title('Pixel seleccionado');
    subplot(2,2,3); imshow(mascara); title('Máscara generada');
    subplot(2,2,4); imshow(imgres); title('Imagen segmentada');
end


%% Cargar la imagen %%
ruta = "/home/angel/Escritorio/MIASegundoSemestre/VISION POR COMPUTADORA/TAREA 9/REPORTE/IMG/IM4.jpeg";
img = imread(ruta);

%% Pruebas para HSV color rosa umbral 0.15 %%
[pixel, mascara, imgres] = SegEspacios(img, "hsv", 0.15);
imwrite(pixel, "R11.jpg")
imwrite(mascara, "R12.jpg")
imwrite(imgres, "R13.jpg")

%% Pruebas para HSV color rosa umbral 0.25 %%
[pixel, mascara, imgres] = SegEspacios(img, "hsv", 0.25);
imwrite(pixel, "R21.jpg")
imwrite(mascara, "R22.jpg")
imwrite(imgres, "R23.jpg")


%% Pruebas para LAB color rosa umbral 15 %%
[pixel, mascara, imgres] = SegEspacios(img, "lab", 15);
imwrite(pixel, "R31.jpg")
imwrite(mascara, "R32.jpg")
imwrite(imgres, "R33.jpg")

%% Pruebas para LAB color rosa umbral 25 %%
[pixel, mascara, imgres] = SegEspacios(img, "lab", 25);
imwrite(pixel, "R41.jpg")
imwrite(mascara, "R42.jpg")
imwrite(imgres, "R43.jpg")





