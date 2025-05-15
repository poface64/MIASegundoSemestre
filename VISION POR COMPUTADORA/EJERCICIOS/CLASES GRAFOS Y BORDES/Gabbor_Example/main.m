clear all
close all

img = imread('fingerprint.jpg');
gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
featureVector = gaborFeatures(img,gaborArray,1,1);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.
 
figure
cont=1;

for i=1:5
    for j=1:8
        subplot(5,8,cont)
        imagesc(featureVector(:,:,cont))
        cont=cont+1;
    end
end

colormap(gray)

