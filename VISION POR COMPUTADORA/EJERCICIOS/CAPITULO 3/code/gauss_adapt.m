
n=5;
I = imread("F1.jpg");
%I = rgb2gray(RGB);
I=double(I);
J=I; %J = imnoise(I,'gaussian',0,0.005);
K = wiener2(J,[n n]);
L = imfilter(double(J),ones(n));
M = medfilt2(double(J),[n n]);
subplot(2,2,1)
imagesc(I)
title('Original')
subplot(2,2,2)
imagesc(L)
title('Mean')
subplot(2,2,3)
imagesc(M)
title('Median')
subplot(2,2,4)
imagesc(K)
title('Wiener')
colormap(gray)