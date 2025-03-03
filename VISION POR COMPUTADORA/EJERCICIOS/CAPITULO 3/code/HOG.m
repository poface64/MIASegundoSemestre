
%Read the image of interest.
img = imread('cameraman.tif');
%Extract HOG features.
[featureVector,hogVisualization] = extractHOGFeatures(img);
%Plot HOG features over the original image.
figure;
imshow(img); 
hold on;
plot(hogVisualization);

figure
%clear all
%I1 = imread('gantrycrane.png');
I1=img;
[hog1,visualization] = extractHOGFeatures(img,'CellSize',[32 32]);
%Display the original image and the HOG features.
subplot(1,2,1);
imshow(I1);
subplot(1,2,2);
plot(visualization);