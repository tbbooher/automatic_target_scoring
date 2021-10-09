%% clean stuff up
close all;

%% read in the image
I = imread('registered\2021-09-12 14.45.34_registered.jpg');
J = imadjust(I,[0 90/255]);
BW = rgb2gray(J);
imshow(BW);


%% create template
template_width = 15;
radius = 6;
M = zeros(template_width);
mid = (template_width+1)/2;
M(mid,mid) = 1;
R = bwdist(M);
template = ((R > radius-1) & (R < radius+1));
imshow(template);

prompt('do you like the template?');

R = normxcorr2(template, BW);