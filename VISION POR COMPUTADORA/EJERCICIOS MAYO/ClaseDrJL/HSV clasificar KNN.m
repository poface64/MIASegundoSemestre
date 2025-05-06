
%% Cargar la imagen original %%
fabric = imread('fabric.png');
figure(1), imshow(fabric), title('fabric');

%% Procesado de los puntos de referencia %%
load regioncoordinates;

nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);
for count = 1:nColors
  sample_regions(:,:,count) = roipoly(fabric,region_coordinates(:,1,count),...
                                      region_coordinates(:,2,count));
end

%% Convertir al espacio HSV y Procesar los puntos %%

lab_fabric = rgb2hsv(fabric);
a = lab_fabric(:,:,1);
b = lab_fabric(:,:,2);
color_markers = repmat(0, [nColors, 2]);

for count = 1:nColors
  color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
  color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end

disp(sprintf('[%0.3f,%0.3f]',color_markers(2,1),color_markers(2,2)));


%% Etiquetado de los clusters con distancia minima %%
color_labels = 0:nColors-1;
a = double(a);
b = double(b);
distance = repmat(0,[size(a), nColors]);
for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end
% Etiquetar los puntos despues del color de distancia minima %
[value, label] = min(distance,[],3);
label = color_labels(label);
clear value distance;

%% Classification %%
rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(fabric), nColors]);
for count = 1:nColors
  color = fabric;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end

%% Mostrar las salidas %%

subplot(2,3,1)
imshow(segmented_images(:,:,:,2)), title('red objects');
subplot(2,3,2)
imshow(segmented_images(:,:,:,3)), title('green objects');
subplot(2,3,3)
imshow(segmented_images(:,:,:,4)), title('purple objects');
subplot(2,3,4)
imshow(segmented_images(:,:,:,5)), title('magenta objects');
subplot(2,3,5)
imshow(segmented_images(:,:,:,6)), title('yellow objects');
subplot(2,3,6)
imshow(segmented_images(:,:,:,1)), title('Brown/Gold objects');

%% Segmentación en el HSV %%
purple = [119/255 73/255 152/255];
plot_labels = {'k', 'r', 'g', purple, 'm', 'y'};

figure
for count = 1:nColors
  plot(a(label==count-1),b(label==count-1),'.','MarkerEdgeColor', ...
       plot_labels{count}, 'MarkerFaceColor', plot_labels{count});
  hold on;
end

title('Scatterplot of the segmented pixels in ''a*b*'' space');
xlabel('''a*'' values');
ylabel('''b*'' values');

%% Figura escalada en HSV %%
imagesc(lab_fabric)