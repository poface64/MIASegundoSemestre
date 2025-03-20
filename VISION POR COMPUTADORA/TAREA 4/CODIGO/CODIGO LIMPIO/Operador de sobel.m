function [q1, q2, q3, q4, Gx, Gy] = imsobel(img_ruta)
    % Cargar la imagen
    img = imread(img_ruta);

    % Convertir la imagen a escala de grises y a double
    if size(img, 3) == 3
        img1 = double(rgb2gray(img));
    else
        img1 = double(img);
    end

    % Generar la matriz que detecta en Gx
    gxk = [-1 0 1; -2 0 2; -1 0 1];

    % Generar la matriz que detecta en Gy
    gyk = gxk'; % Usamos la transpuesta de gxk

    % Obtener las dimensiones de la imagen y el kernel
    [imdim_rows, imdim_cols] = size(img1);
    [kerdim_rows, kerdim_cols] = size(gxk);

    % Calcular las dimensiones de la imagen resultante
    rf = imdim_rows - kerdim_rows + 1;
    rc = imdim_cols - kerdim_cols + 1;

    % Crear un array para guardar los resultados
    resultado = zeros(rf, rc, 4);

    % Aplicar la convolución
    for i = 1:rf
        for j = 1:rc
            % Extraer una submatriz de nxn de la imagen
            subim = img1(i:i+kerdim_rows-1, j:j+kerdim_cols-1);

            % Aplicar la convolución sobre GX
            resultado(i, j, 1) = sum(subim .* gxk, 'all');

            % Aplicar la convolución sobre GY
            resultado(i, j, 2) = sum(subim .* gyk, 'all');

            % Calcular el operador de Sobel
            sobel = sqrt(resultado(i, j, 1)^2 + resultado(i, j, 2)^2);

            % Guardar el valor del gradiente
            resultado(i, j, 3) = sobel;
        end
    end

    % Operador de la dirección
    resultado(:,:,4) = atan2(resultado(:,:,2), resultado(:,:,1));

    % Reportar Gx
    Gx = resultado(:,:,1);
    % Estandarizar
    minr = min(Gx(:));
    maxr = max(Gx(:));
    p1 = (Gx - minr) / (maxr - minr);
    q1 = 1 - p1;

    % Reportar Gy
    Gy = resultado(:,:,2);
    % Estandarizar
    minr = min(Gy(:));
    maxr = max(Gy(:));
    p2 = (Gy - minr) / (maxr - minr);
    q2 = 1 - p2;

    % Reportar Sobel
    rg = resultado(:,:,3);
    % Estandarizar
    minr = min(rg(:));
    maxr = max(rg(:));
    p3 = (rg - minr) / (maxr - minr);
    q3 = 1 - p3;

    % Operador de la dirección
    q4 = resultado(:,:,4);
    % Normalizar el ángulo a [0, 1]
    q4 = (q4 + pi) / (2 * pi);

    % Mostrar y guardar los vectores de flujo óptico
    figure;
    quiver(Gx, -Gy); % Se invierte Gy para la visualización correcta
    title('Vectores de flujo óptico (quiver)');
    saveas(gcf, 'quiver.png'); % Guardar la figura en la carpeta actual

    % Exportar salidas
    q1 = uint8(q1 * 255);
    q2 = uint8(q2 * 255);
    q3 = uint8(q3 * 255);
    q4 = q4; % q4 ya está normalizado a [0, 1]

    % Guardar las imágenes resultantes en la carpeta actual
    imwrite(q1, 'q1.png');
    imwrite(q2, 'q2.png');
    imwrite(q3, 'q3.png');
    imwrite(q4, 'q4.png');
end

% Ejemplo de uso
img_ruta = 'Fig3.45(a).jpg';
[q1, q2, q3, q4, Gx, Gy] = imsobel(img_ruta);


% Mostrar las imágenes resultantes
figure; imshow(q1); title('q1 (1 - Gx)');
figure; imshow(q2); title('q2 (1 - Gy)');
figure; imshow(q3); title('q3 (1 - Sobel)');
figure; imshow(q4); title('q4 (Dirección)');