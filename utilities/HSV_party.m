close all;
% samples (from photoshop)
hsvVal = [[52.00,46.00,31.00];
[52,47,24];
[54.25,40.75,33.25]];
% make this work
hsvVal(:,1) = hsvVal(:,1)/360;
hsvVal(:,2) = hsvVal(:,2)/100;
hsvVal(:,3) = hsvVal(:,3)/100;

% empirical tolerances

tol = [0.15 0.15 0.15];

filename = 'IMG_1719.jpg';
I_rgb = imread(filename);
% find the center by template match
center = find_center(I_rgb);
% now find the regions
I = colorDetectHSV(I_rgb,median(hsvVal),tol);
% imshow(I,[]);
BW = imbinarize(I);
% [labeledImage, numberOfRegions] = bwlabel(BW);
CC = bwareafilt(BW,[1000 10000]);
S = regionprops('table',CC, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid');
% centroids = cat(1,S.Centroid);
centers = S.Centroid;
diameters = mean([S.MajorAxisLength S.MinorAxisLength],2);
radii = diameters/2;
% select circular things
i = (S.Eccentricity < 0.98);
% plot it
centers = centers(i,:);
radii = radii(i,:);
imshow(I_rgb);
hold on;
plot(centers(:,1),centers(:,2),'b*');
viscircles(centers,radii);
plot(center(1),center(2),'go');
% Plot the box over the image.
hold off;

% now calculate disntances
dist = sqrt((center(2)-centers(:,2)).^2+(center(1)-centers(:,1)).^2);
% for i = 1:length(centers)
%     dist = sqrt((center(2)-centers(i,2))^2+(center(1)-centers(i,1))^2);
%     disp(dist);
% end
mean(dist)