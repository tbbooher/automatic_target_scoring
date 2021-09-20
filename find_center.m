function center = find_center(rgbImage)
t = imread('files/x_template.jpg');
smallSubImage = imbinarize(rgb2gray(t));

% now get the template
channelToCorrelate = 1;  % Use the red channel.
correlationOutput = normxcorr2(smallSubImage(:,:,1), rgbImage(:,:, channelToCorrelate));

% Find out where the normalized cross correlation image is brightest.
[~, maxIndex] = max(abs(correlationOutput(:)));
[yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex(1));
% Because cross correlation increases the size of the image, 
% we need to shift back to find out where it would be in the original image.
corr_offset = [(xPeak-size(smallSubImage,2)/2) (yPeak-size(smallSubImage,1)/2)];

center = corr_offset;

end
