% Access a Matrox(R) frame grabber attached to a Pulnix TMC-9700 camera, and
% acquire data using an NTSC format.
% vidobj = videoinput('matrox',1,'M_NTSC_RGB');

% Open a live preview window.  Point camera onto a piece of colorful fabric.
% preview(vidobj);

% Capture one frame of data.
% fabric = getsnapshot(vidobj);
% imwrite(fabric,'fabric.png','png');

% Delete and clear associated variables.
% delete(vidobj)
% clear vidobj;
%----------------------------------------------------------
fabric = imread('fabric.png');
figure(1), imshow(fabric), title('fabric');

%----------------------------------------------------------
load regioncoordinates;

nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);

for count = 1:nColors
  sample_regions(:,:,count) = roipoly(fabric,region_coordinates(:,1,count),...
                                      region_coordinates(:,2,count));
end

imshow(sample_regions(:,:,2)),title('sample region for red');


%----------------------------------------------------------
%cform = makecform('srgb2lab');
%lab_fabric = applycform(fabric,cform);
lab_fabric = rgb2lab(fabric);
%----------------------------------------------------------
a = lab_fabric(:,:,2);
b = lab_fabric(:,:,3);
color_markers = repmat(0, [nColors, 2]);

for count = 1:nColors
  color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
  color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end

%----------------------------------------------------------
disp(sprintf('[%0.3f,%0.3f]',color_markers(2,1),color_markers(2,2)));

%----------------------------------------------------------

color_labels = 0:nColors-1;

%----------------------------------------------------------

a = double(a);
b = double(b);
distance = repmat(0,[size(a), nColors]);

%----------------------------------------------------------

for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end

[value, label] = min(distance,[],3);
label = color_labels(label);
clear value distance;

%--------------- Classification ---------------------------

rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(fabric), nColors]);

for count = 1:nColors
  color = fabric;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end

imshow(segmented_images(:,:,:,2)), title('red objects');

%----------------------------------------------------------
imshow(segmented_images(:,:,:,3)), title('green objects');

%----------------------------------------------------------
imshow(segmented_images(:,:,:,4)), title('purple objects');

%----------------------------------------------------------
imshow(segmented_images(:,:,:,5)), title('magenta objects');

%----------------------------------------------------------
imshow(segmented_images(:,:,:,6)), title('yellow objects');

%----------------------------------------------------------
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

%----------------------------------------------------------