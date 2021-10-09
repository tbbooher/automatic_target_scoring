function score = score_image(fileName)
% close all;
% % samples (from photoshop)
% hsvVal = [  [52.00,46.00,31.00];
%     [52,47,24];
%     [54.25,40.75,33.25]];
% % adjust for photoshop scale
% hsvVal(:,1) = hsvVal(:,1)/360;
% hsvVal(:,2) = hsvVal(:,2)/100;
% hsvVal(:,3) = hsvVal(:,3)/100;

[~,shortname,~] = fileparts(fileName);

% empirical tolerances

% tol = [0.15 0.15 0.15];

I_rgb = imread(fileName);

% find the center by template match
center = [487,471]; % find_center(I_rgb);
% now find the regions
% mult = 1;
% I = colorDetectHSV(I_rgb,min(hsvVal)*mult,tol);
BW = rgb2gray(I_rgb) < 40;
% make this a BW image
% BW = imbinarize(I);
% imshow(BW);
% select all things with areas between 1000 and 10000 pixels^2
CC = bwareafilt(BW,[60 1200]);
% S = regionprops('table',CC, 'Eccentricity', 'Centroid',...
%     'MajorAxisLength',...
%     'MinorAxisLength',...
%     'Orientation');
S = regionprops(CC, {'Eccentricity', 'Centroid',...
    'MajorAxisLength',...
    'MinorAxisLength',...
    'Orientation'});
% centroids = cat(1,S.Centroid);
myTable = struct2table(S);
centers = myTable.Centroid;

% select circular things
i = ([S.Eccentricity]' < 0.98);
S = S(i);
centers = centers(i,:);

imshow(CC);
keyboard

% now calculate disntances
dist = sqrt((center(2)-centers(:,2)).^2+(center(1)-centers(:,1)).^2);
score = mean(dist);

if true % build plots
    f = figure;
    imshow(I_rgb);
    t = linspace(0,2*pi,50);
    hold on
    for k = 1:length(S)
        a = S(k).MajorAxisLength/2;
        b = S(k).MinorAxisLength/2;
        Xc = S(k).Centroid(1);
        Yc = S(k).Centroid(2);
        phi = deg2rad(-S(k).Orientation);
        x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
        y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
        plot(x,y,'r','Linewidth',1)
        line([Xc,center(1)],[Yc,center(2)],'Color','green','LineWidth',1);
    end
    plot(centers(:,1),centers(:,2),'g+','MarkerSize',18)
    text(10,10,string(score));
    hold off
    saveas(f,fullfile('scored',[shortname '_scored.jpg']));
end

end