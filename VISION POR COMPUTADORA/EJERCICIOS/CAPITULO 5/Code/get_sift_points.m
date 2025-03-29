clear all
close all


I = imread('cameraman.tif');

%Detect SURF features.

points = detectSURFFeatures(I);

imshow(I); hold on;
plot(points(1:10));
    

