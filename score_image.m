function score = score_image(fileName)
% samples (from photoshop)
hsvVal = [  [52.00,46.00,31.00];
            [52,47,24];
            [54.25,40.75,33.25]];
% adjust for photoshop scale
hsvVal(:,1) = hsvVal(:,1)/360;
hsvVal(:,2) = hsvVal(:,2)/100;
hsvVal(:,3) = hsvVal(:,3)/100;

% empirical tolerances

tol = [0.15 0.15 0.15];

I_rgb = register_target(fileName);

% find the center by template match
center = find_center(I_rgb);
% now find the regions
I = colorDetectHSV(I_rgb,median(hsvVal),tol);
% make this a BW image
BW = imbinarize(I);
% select all things with areas between 1000 and 10000 pixels^2
CC = bwareafilt(BW,[1000 10000]);
S = regionprops('table',CC, 'Eccentricity', 'Centroid');
% centroids = cat(1,S.Centroid);
centers = S.Centroid;

% select circular things
i = (S.Eccentricity < 0.98);
centers = centers(i,:);

% now calculate disntances
dist = sqrt((center(2)-centers(:,2)).^2+(center(1)-centers(:,1)).^2);
score = mean(dist);

end