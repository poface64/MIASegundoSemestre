
%% Cargar la imagen de las verduras %%
I = imread("imagen1.jpg");
imshow(I)

%% Pedir un kmeans con k = 3 %%
[seg,centros] = imsegkmeans(I,3);
imagesc(seg);
title("Imagen segmentada")
% Agregar los colores de los centros como el colormap %
colormap(centros);


%% Cargar la imagen para el segundo ejercicio %%
I = imread("imagen2.jpg");
imshow(I)

%% Convertir la imagen en escala de grises %%
BI = rgb2gray(I);

%% Aplicar la transformada con canny y volver a proyectar
BW = edge(BI,'canny');
imshow(BW);
title('Bordes detectados con Canny');

%% 4. Realizar la Transformada de Hough y proyectar su espacio %%
[H, T, R] = hough(BW);
imshow(imadjust(rescale(H)), 'XData', T, 'YData', R, ...
       'InitialMagnification', 'fit');
title('Espacio de Hough');
xlabel('\theta (degrees)');
ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca, hot); 

%% 5. Encontrar los picos en el espacio de Hough
P = houghpeaks(H, 5, 'threshold', ceil(0.6 * max(H(:))));
x = T(P(:,2));
y = R(P(:,1));
plot(x, y, 's', 'Color', 'black');

%% 6. Extraer las líneas de los picos encontrados
lines = houghlines(BW, T, R, P, 'FillGap', 20, 'MinLength', 40);
imshow(I); % Muestra la imagen original
title('Líneas de la pista de aterrizaje detectadas');
hold on; % Permite dibujar sobre la imagen
max_len = 0; % Para encontrar la línea más larga, opcional
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'red'); % Dibuja la línea en rojo
   % Marca los puntos inicial y final de la línea (opcional)
   plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'green');
   % Determina la línea más larga (opcional)
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      longest_line = xy;
   end
end
if exist('longest_line', 'var')
    plot(longest_line(:,1), longest_line(:,2), 'LineWidth', 2, 'Color', 'blue');
end

hold off;


