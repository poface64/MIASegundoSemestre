close all
clear all

I = checkerboard(50,2,2);

%I = imread('cameraman.tif');

%Detect feature points.

points = detectHarrisFeatures(I);

%Display the ten strongest points.

strongest = selectStrongest(points,10);
imshow(I)
hold on
plot(strongest)

return

I = checkerboard(50,2,2);

%Load the locations of corner points.

location = [51    51    51   100   100   100   151   151   151; ...
            50   100   150    50   101   150    50   100   150]';

%Save the points in a cornerPoints object.



points = cornerPoints(location);

Display the points on the checkerboard.



imshow(I)
hold on
plot(points)