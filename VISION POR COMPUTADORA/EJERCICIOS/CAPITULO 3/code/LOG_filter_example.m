clear all
close all

%fixed=double(rgb2gray(imread('F2.jpg')));

fixed = imread('F3.jpg');
fixed=double(fixed);


subplot(2,2,1)
imagesc(edge(fixed,'log',[],1));
title('Sigma = 1')
subplot(2,2,2)
imagesc(edge(fixed,'log',[],2));
title('Sigma = 2')
subplot(2,2,3)
imagesc(edge(fixed,'log',[],3));
title('Sigma = 3')
subplot(2,2,4)
imagesc(edge(fixed,'log',[],4));
title('Sigma = 4')
colormap(gray)