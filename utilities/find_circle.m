function [cleanTargetCenter, cleanTargetRadius] = find_circle(fileName)
%FIND_CIRCLE Finds the circles in a target image
%   This only works for a target image and is useful for a sensitivity
%   analysis of images. Image must be multi-color


% need to find the bounding box

tgt = imread(fileName);

shortname = split(fileName,'\');
shortname = string(shortname(end));
% now clean the target
[~, ~, bTarget] = imsplit(tgt);
redTarget = bTarget < 100;
redTarget = bwareafilt(redTarget, 1);

stats = regionprops(redTarget, 'BoundingBox');
BB = stats.BoundingBox;
diamTarget = mean(BB(3:4));
half_width = 0.1;
radiusRange = round([diamTarget/2 * (1-half_width), diamTarget/2 * (1+half_width)]);

[theCenter, theRadius] = imfindcircles(redTarget, radiusRange, ...
    'Sensitivity',0.95, ...
    'EdgeThreshold',0.30, ...
    'Method','PhaseCode', ...
    'ObjectPolarity','Bright');

love = ~isempty(theCenter);
if love
    cleanTargetCenter = theCenter(1, :);
    cleanTargetRadius = theRadius(1);
    disp('love!!!');
else % just get one
    disp('no love');
    cleanTargetCenter = [0];
    cleanTargetRadius = [0];
end

if true
    targetFigure = figure('Name', 'Target Detection');
    imshow(tgt);
    hold on;
    rectangle('Position',BB,'EdgeColor','r');
    circle_center = [BB(1)+BB(3)/2,BB(2)+BB(4)/2];
    plot(circle_center(1),circle_center(2),'r+','MarkerSize',12);
    % what was the search space
    viscircles(repmat(circle_center,2,1),radiusRange,'color','b');
    % did we find a target
    if love
        viscircles(cleanTargetCenter, cleanTargetRadius, 'color','g');
    end
    hold off;
    saveas(targetFigure,fullfile('circles',shortname));
    close(targetFigure);
end

end

