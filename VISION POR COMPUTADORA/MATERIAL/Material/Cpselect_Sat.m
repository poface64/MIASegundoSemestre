clear all
close all

original=rgb2gray(imread('westconcordaerial.png'));

scale = 0.7;
distorted = imresize(original,scale); % Try varying the scale factor.
theta = 30;
distorted = imrotate(distorted,theta); % Try varying the angle, theta.
colormap(gray)

subplot(1,2,1)
imagesc(original)
subplot(1,2,2)
imagesc(distorted)
colormap(gray)
%movingPoints = [151.52  164.79; 131.40 79.04];
%fixedPoints = [135.26  200.15; 170.30 79.30];
cpselect(distorted,original);

%cpselect(distorted,original,movingPoints,fixedPoints);
%Save control points by choosing the File menu, then the Save Points to Workspace option. 
%Save the points, overwriting variables movingPoints and fixedPoints.

tform = fitgeotrans(movingPoints,fixedPoints,'affine'); % affine nonreflectivesimilarity

Roriginal = imref2d(size(original));
recovered = imwarp(distorted,tform,'OutputView',Roriginal);

figure
subplot(1,3,1)
imagesc(original)
subplot(1,3,2)
imagesc(distorted)
subplot(1,3,3)
imagesc(recovered)
colormap(gray)