clear all
close all

load mri
DTransverse = squeeze(D);

imtool(DTransverse(:,:,1))

%Display Montage of Oriented Slices
figure
montage(DTransverse,map)
title("Transverse Slices")

% Display Stack of Slices
sliceViewer(DTransverse,Parent=figure);
title("Transverse Slices")
return
% Display Orthogonal Slices
figure
orthosliceViewer(DTransverse,ScaleFactors=[1 1 2.5]);

%Explore Slices and 3-D Volume Using Volume Viewer
volumeViewer(DTransverse,ScaleFactors=[1 1 2.5])