fixed = rgb2gray(imread('E:\Dropbox\personal\1. Tim\Image Registration\files\fixed.jpg'));
moving = rgb2gray(imread('E:\Dropbox\personal\1. Tim\Image Registration\files\2021-09-17 16.55.34.jpg'));
% imshowpair(fixed, moving,'Scaling','joint');
[optimizer, metric] = imregconfig('Multimodal');
optimizer.InitialRadius = optimizer.InitialRadius*0.8;
movingRegistered = imregister(moving, fixed, 'translation', optimizer, metric);
imshowpair(fixed, movingRegistered,'Scaling','joint');