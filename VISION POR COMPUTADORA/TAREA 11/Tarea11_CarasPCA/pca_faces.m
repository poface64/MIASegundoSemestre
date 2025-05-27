clear 
close all

% Cargar los datos de las 100 mejores caras
load("best_faces.mat");
cara1 = imread("BioID_0001.pgm");

% Reorganizar los puntos (x,y) en una sola fila por cara: (100 × 40)
datos_fila = [];
for i = 1:100
    x = best_faces{i}(:,1)';  % Vector fila de x
    y = best_faces{i}(:,2)';  % Vector fila de y
    cara = reshape([x; y], 1, []);    % Alternar x1 y1 x2 y2 ...
    datos_fila = cat(1, datos_fila, cara);
end

% Se realiza PCA sobre los datos reordenados
% Cada fila es una cara, cada columna una coordenada 
[coeff, score, latent, ~, explained, mu] = pca(datos_fila);

% Se toman 12 componentes, explicando un poco más del 90% de la
% variabilidad
k = 12;
alphas = score(:, 1:k);         % Proyecciones de los datos, 12 parámetros 
pcV = coeff(:, 1:k);         % Eigenvectores de los 12 primeros componentes 
pcD = latent(1:k) / sum(latent);  % Porcentaje de varianza explicada


% Reconstrucción de los datos
modelos = alphas*pcV' + mu ; 

% Varianza acumulada explicada por componente
varianza_acumulada = cumsum(explained); 

% Graficar varianza
figure
plot(varianza_acumulada, 'o-','LineWidth',2)
xlabel('Número de componentes principales')
ylabel('Varianza explicada acumulada (%)')
title('Varianza explicada acumulada por PCA')
grid on

% Histograma de los 12 parámetros 
stds = std(alphas);
medias = mean(alphas);

figure
for i=1:k
    subplot(6,2,i)
    histogram(alphas(:,i))
    titulo = ['Parámetro \alpha_{' , num2str(i), '}'];
    title(titulo)
    hold on
    % Se muestra la media y dos desviaciones estándar
    xline(medias(i),'r', 'LineWidth', 2, 'Label', 'Media', ...
        'LabelVerticalAlignment', 'bottom')
    xline(medias(i) + stds(i), '--k', 'LineWidth', 1.5, 'Label', '+1\sigma')
    xline(medias(i) - stds(i), '--k', 'LineWidth', 1.5, 'Label', '-1\sigma')
    xline(medias(i) + 2*stds(i), '--k', 'LineWidth', 1.5, 'Label', '+2\sigma')
    xline(medias(i) - 2*stds(i), '--k', 'LineWidth', 1.5, 'Label', '-2\sigma')
    y_limits = ylim;
    text(stds(i), y_limits(2)/2, ['\sigma = ', num2str(stds(i), '%.2f')])

    hold off

end

% Generando una cara dados parámetros aleatorios
new_alpha = alphas(1,:);  
new_face = new_alpha * pcV' + mu;

% Visualización sobre la imagen

% Se convierte de lista de puntos a una matriz
points = [];
for i=1:2:40
    points = cat(1, points, [new_face(i), new_face(i+1)]);
end

% Se anota qué puntos corresponden a qué parte de la cara
idx_labios = [3, 18, 4, 19, 3];
idx_ojo_izquierdo = [10, 1, 11];
idx_ojo_derecho = [12, 2, 13, 12];
idx_nariz = [16, 15, 17, 16];
idx_contorno = [20, 14, 8, 7, 6, 5, 9, 20];


figure
imagesc(cara1)
colormap gray
hold on
% Graficando labios
plot(points(idx_labios,1), points(idx_labios,2), 'r.-')

% Graficando ojos
plot(points(idx_ojo_izquierdo, 1), points(idx_ojo_izquierdo, 2), 'r.-')
plot(points(idx_ojo_derecho, 1), points(idx_ojo_derecho, 2), 'r.-')

% Graficando nariz
plot(points(idx_nariz, 1), points(idx_nariz, 2), 'r.-')

% Graficando contorno de la cara
plot(points(idx_contorno, 1), points(idx_contorno, 2), 'r.-')
hold off
