clear all
close all

I = imread('BW01.png'); % BW01 BWfigs

umbral=graythresh(I);
BW=im2bw(I,umbral);
BW2=(BW-1)*-1; 

labels=bwlabel(BW2,8); % 4

imagesc(labels)
colorbar
