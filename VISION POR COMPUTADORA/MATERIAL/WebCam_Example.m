clear all
close all


% Construct a webcam object
%webcamlist
camObj = webcam(1);
%camObj
%camObj.Resolution='160x120';

% Preview a stream of image frames.
preview(camObj);

% Acquire and display a single image frame.
img = snapshot(camObj);
imshow(img);

BW = edge(rgb2gray(img),'canny');
figure, imshow(BW)

%closePreview(camObj)
        