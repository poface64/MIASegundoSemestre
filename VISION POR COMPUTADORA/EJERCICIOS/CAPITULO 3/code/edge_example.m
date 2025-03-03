clear all
close all


I = imread('circuit.tif');
BW1 = edge(I,'prewitt');
BW2 = edge(I,'sobel');
BW3 = edge(I,'canny');
subplot(2,2,1), imshow(I)
title('Original')
subplot(2,2,2), imshow(BW1)
title('Prewitt')
subplot(2,2,3), imshow(BW2)
title('Sobel')
subplot(2,2,4), imshow(BW3)
title('Canny')
