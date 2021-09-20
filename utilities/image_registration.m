%----------------------------------------------------------------------------
% Function to show the low and high threshold bars on the histogram plots.


% prepare things
close all;
fontSize = 16;
% figure;
% Maximize the figure.
% set(gcf, 'Position', get(0, 'ScreenSize'));


fullImageFileName = 'E:\Dropbox\personal\1. Tim\Image Registration\IMG_1718.jpg';
[rgbImage storedColorMap] = imread(fullImageFileName);
[rows columns numberOfColorBands] = size(rgbImage);
redBand = rgbImage(:, :, 1);
greenBand = rgbImage(:, :, 2);
blueBand = rgbImage(:, :, 3);
subplot(3, 4, 2);
imshow(redBand);
title('Red Band', 'FontSize', fontSize);
subplot(3, 4, 3);
imshow(greenBand);
title('Green Band', 'FontSize', fontSize);
subplot(3, 4, 4);
imshow(blueBand);
title('Blue Band', 'FontSize', fontSize);

% some diagnostics
if strcmpi(class(rgbImage), 'uint8')
		% Flag for 256 gray levels.
	eightBit = true;
else
	eightBit = false;
end

% Display the original image.
subplot(3, 4, 1);
imshow(rgbImage);
drawnow; % Make it display immediately.

% Compute and plot the red histogram.
hR = subplot(3, 4, 6);
[countsR, grayLevelsR] = imhist(redBand);
maxGLValueR = find(countsR > 0, 1, 'last');
maxCountR = max(countsR);
bar(countsR, 'r');
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
title('Histogram of Red Band', 'FontSize', fontSize);

% Compute and plot the green histogram.
hG = subplot(3, 4, 7);
[countsG, grayLevelsG] = imhist(greenBand);
maxGLValueG = find(countsG > 0, 1, 'last');
maxCountG = max(countsG);
bar(countsG, 'g', 'BarWidth', 0.95);
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
title('Histogram of Green Band', 'FontSize', fontSize);

% Compute and plot the blue histogram.
hB = subplot(3, 4, 8);
[countsB, grayLevelsB] = imhist(blueBand);
maxGLValueB = find(countsB > 0, 1, 'last');
maxCountB = max(countsB);
bar(countsB, 'b');
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
title('Histogram of Blue Band', 'FontSize', fontSize);

% Set all axes to be the same width and height.
% This makes it easier to compare them.
maxGL = max([maxGLValueR,  maxGLValueG, maxGLValueB]);
if eightBit
    maxGL = 255;
end
maxCount = max([maxCountR,  maxCountG, maxCountB]);
axis([hR hG hB], [0 maxGL 0 maxCount]);

% Plot all 3 histograms in one plot.
subplot(3, 4, 5);
plot(grayLevelsR, countsR, 'r', 'LineWidth', 2);
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
hold on;
plot(grayLevelsG, countsG, 'g', 'LineWidth', 2);
plot(grayLevelsB, countsB, 'b', 'LineWidth', 2);
title('Histogram of All Bands', 'FontSize', fontSize);
maxGrayLevel = max([maxGLValueR, maxGLValueG, maxGLValueB]);
% Trim x-axis to just the max gray level on the bright end.
if eightBit
    xlim([0 255]);
else
    xlim([0 maxGrayLevel]);
end

% now assign low and high thresholds for each color band

% Take a guess at the values that might work for the user's image.
redThresholdLow = graythresh(redBand);
redThresholdHigh = 255;
greenThresholdLow = 0;
greenThresholdHigh = graythresh(greenBand);
blueThresholdLow = 0;
blueThresholdHigh = graythresh(blueBand);
if eightBit
    redThresholdLow = uint8(redThresholdLow * 255);
    greenThresholdHigh = uint8(greenThresholdHigh * 255);
    blueThresholdHigh = uint8(blueThresholdHigh * 255);
end

% Show the thresholds as vertical red bars on the histograms.
PlaceThresholdBars(6, redThresholdLow, redThresholdHigh);
PlaceThresholdBars(7, greenThresholdLow, greenThresholdHigh);
PlaceThresholdBars(8, blueThresholdLow, blueThresholdHigh);

% Now apply each color band's particular thresholds to the color band
redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);

% Display the thresholded binary images.
fontSize = 16;
subplot(3, 4, 10);
imshow(redMask, []);
title('Is-Red Mask', 'FontSize', fontSize);
subplot(3, 4, 11);
imshow(greenMask, []);
title('Is-Not-Green Mask', 'FontSize', fontSize);
subplot(3, 4, 12);
imshow(blueMask, []);
title('Is-Not-Blue Mask', 'FontSize', fontSize);
% Combine the masks to find where all 3 are "true."
% Then we will have the mask of only the red parts of the image.
redObjectsMask = uint8(redMask & greenMask & blueMask);
subplot(3, 4, 9);
imshow(redObjectsMask, []);
caption = sprintf('Mask of Only\nThe Red Objects');
title(caption, 'FontSize', fontSize);

% Tell user that we're going to filter out small objects.
smallestAcceptableArea = 100; % Keep areas only if they're bigger than this.