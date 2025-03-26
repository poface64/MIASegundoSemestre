close all
clear all

% Use SURF Algorithm
original  = imread('cameraman.tif');
imshow(original);
title('Base image');

distorted = imresize(original,0.7); 
distorted = imrotate(distorted,31);
figure; imshow(distorted);
title('Transformed image');

%Detect and extract features from both images.

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,validPtsOriginal] = ...
    extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
    extractFeatures(distorted,ptsDistorted);

%Match features.

index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));
figure; 
showMatchedFeatures(original,distorted,...
    matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points,including outliers');

%Exclude the outliers, and compute the transformation matrix.

[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'similarity');
figure; 

showMatchedFeatures(original,distorted,...
    inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');

%Recover the original image from the distorted image.

outputView = imref2d(size(original));
Ir = imwarp(distorted,tform,'OutputView',outputView);
figure; imshow(Ir); 
title('Recovered image');

