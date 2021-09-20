function build_template(fileName)
    close all;
    smallSubImage = imread('files/x_template.jpg');
    imshow(smallSubImage);

    fontSize = 16;

    % get image
    rgbImage = imread(fullfile('files',fileName));
    [rows, columns, ~] = size(rgbImage);
    % Display the original color image.
    subplot(2, 2, 1);
    imshow(rgbImage, []);
    axis on;
    caption = sprintf('Original Color Image, %d rows by %d columns.', rows, columns);
    title(caption, 'FontSize', fontSize);
    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0, 0, 1, 1]);

    % show the template
    subplot(2, 2, 2);
    [rows, columns, ~] = size(smallSubImage);
    imshow(smallSubImage, []);
    axis on;
    caption = sprintf('Template Image to Search For, %d rows by %d columns.', rows, columns);
    title(caption, 'FontSize', fontSize);

    % now get the template
    channelToCorrelate = 1;  % Use the red channel.
    correlationOutput = normxcorr2(smallSubImage(:,:,1), rgbImage(:,:, channelToCorrelate));
    subplot(2, 2, 3);
    imshow(correlationOutput, []);
    axis on;
    % Get the dimensions of the image.  numberOfColorBands should be = 1.
    [rows, columns, ~] = size(correlationOutput);
    caption = sprintf('Normalized Cross Correlation Output, %d rows by %d columns.', rows, columns);
    title(caption, 'FontSize', fontSize);

    % Find out where the normalized cross correlation image is brightest.
    [~, maxIndex] = max(abs(correlationOutput(:)));
    [yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex(1));
    % Because cross correlation increases the size of the image,
    % we need to shift back to find out where it would be in the original image.
    corr_offset = [(xPeak-size(smallSubImage,2)) (yPeak-size(smallSubImage,1))];

    % Plot it over the original image.
    subplot(2, 2, 4); % Re-display image in lower right.
    imshow(rgbImage,[]);
    axis on; % Show tick marks giving pixels
    hold on; % Don't allow rectangle to blow away image.
    % Calculate the rectangle for the template box.  Rect = [xLeft, yTop, widthInColumns, heightInRows]
    boxRect = [corr_offset(1) corr_offset(2) 100, 100];
    % Plot the box over the image.
    rectangle('position', boxRect, 'edgecolor', 'g', 'linewidth',2);
    % Give a caption above the image.
    title('Template Image Found in Original Image', 'FontSize', fontSize);
    saveas(gcf,fullfile('out',fileName));
    sgtitle(fileName);
end
