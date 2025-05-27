
face1 = imread("Im_Faces\BioID_0001.pgm");
x_data = squeeze(best_faces(1,1,:));
y_data = squeeze(best_faces(1,2,:));

data = [x_data,y_data];

idx_labios = [3, 18, 4, 19, 3];

idx_ojo_izquierdo = [10, 1, 11];
idx_ojo_derecho = [12, 2, 13, 12];

idx_nariz = [16, 15, 17, 16];
idx_contorno = [20, 14, 8, 7, 6, 5, 9, 20];

imagesc(face1)
colormap gray
hold on
% Graficando labios
plot(x_data(idx_labios), y_data(idx_labios), 'r.-')

% Graficando ojos
plot(x_data(idx_ojo_izquierdo), y_data(idx_ojo_izquierdo), 'r.-')
plot(x_data(idx_ojo_derecho), y_data(idx_ojo_derecho), 'r.-')

% Graficando nariz
plot(x_data(idx_nariz), y_data(idx_nariz), 'r.-')

% Graficando contorno de la cara
plot(x_data(idx_contorno), y_data(idx_contorno), 'r.-')


