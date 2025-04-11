


%% Use SURF Algorithm %%
ruta = "C:\\Users\\Angel\\Desktop\\EJERCICIO BIOID\\BioID1520 1\\BioID1520\\Im_Faces\\BioID_0151.pgm"
original=(imread(ruta)); %1515
%original  = imread('cameraman.tif');
subplot(2,3,1)
imshow(original);
title('Base image');

%% Aplicando rotaciones %%

distorted = imresize(original,0.7); 
distorted = imrotate(distorted,31);
subplot(2,3,2)
imshow(distorted);
title('Transformed image');

%% Detect and extract features from both images.

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,validPtsOriginal] = ...
    extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
    extractFeatures(distorted,ptsDistorted);

index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));

%% Hacer el match %% 
subplot(2,3,3)
showMatchedFeatures(original,distorted,...
    matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points,including outliers');

%% Excluir los outliers %%
%Exclude the outliers, and compute the transformation matrix.

[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'similarity');
subplot(2,3,4)
showMatchedFeatures(original,distorted,...
    inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');

%% Recover the original image from the distorted image.

outputView = imref2d(size(original));
Ir = imwarp(distorted,tform,'OutputView',outputView);
subplot(2,3,5)
imshow(Ir); 
title('Recovered image');

