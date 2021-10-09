function img_reg = register_target(fileName)
close all;
I = rgb2gray(imread(fileName));
fixed = rgb2gray(imread('C:\Users\tim\Dropbox\Transfer Folder\Image Registration\utilities\fixed.jpg'));
center_fixed = [1665,1720]; % pre-processed
center_moving = find_center(I)
% figure;
% subplot(1,2,1);
% imshow(fixed, []);
% hold on;
% plot(center_fixed(1),center_fixed(2),'ro');
% subplot(1,2,2);
imshow(I);
hold on;
plot(center_moving(1),center_moving(2),'go');
x_offset = center_fixed(1) - center_moving(1);
y_offset = center_fixed(2) - center_moving(2);

xbegin = round(x_offset+1);
xend   = round(x_offset+ size(I,2));
ybegin = round(y_offset+1);
yend   = round(y_offset+size(I,1));

img_reg = uint8(zeros(size(fixed)));
img_reg(ybegin:yend,xbegin:xend,:) = I;
% figure;
% imshowpair(fixed, img_reg,'Scaling','joint');

end