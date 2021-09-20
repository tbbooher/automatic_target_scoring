close all; clear all;
fontSize = 16;
fullImageFileName = 'E:\Dropbox\personal\1. Tim\Image Registration\IMG_1718.jpg';
[rgbImage storedColorMap] = imread(fullImageFileName);
[rows columns numberOfColorBands] = size(rgbImage);
redBand = rgbImage(:, :, 1);
greenBand = rgbImage(:, :, 2);
blueBand = rgbImage(:, :, 3);
% subplot(3, 2, 1);
% imshow(rgbImage);
% title('Original', 'FontSize', fontSize);
% subplot(3, 2, 2);
% imshow(redBand);
% title('Red Band', 'FontSize', fontSize);
% subplot(3, 2, 3);
% imshow(greenBand);
% title('Green Band', 'FontSize', fontSize);
% subplot(3, 2, 4);
% imshow(blueBand);
% title('Blue Band', 'FontSize', fontSize);

dadif = 0.7;
upper = 1 + dadif;
lower = 1 - dadif;

% Take a guess at the values that might work for the user's image.
redThresholdLow = uint8(graythresh(redBand)*lower*255);
redThresholdHigh = uint8(graythresh(redBand)*upper*255);
greenThresholdLow = uint8(graythresh(greenBand)*lower*255);
greenThresholdHigh = uint8(graythresh(redBand)*upper*255);
blueThresholdLow = uint8(graythresh(blueBand)*lower*255);
blueThresholdHigh = uint8(graythresh(redBand)*upper*255);

redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);

myMask = uint8(redMask & greenMask & blueMask);

% subplot(3, 2, 5);
imshow(myMask, []);
title('best we got', 'FontSize', fontSize);