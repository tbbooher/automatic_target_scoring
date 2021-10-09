function [positions, t] = find_points(I)
%FIND POINTS opens an image and finds the relevant points
%   Detailed explanation goes here
imshow(I);
positions = zeros(5,2);
t = cell(5,1);
for iShot = 1:5
    roi = drawpoint;
    positions(iShot,:) = roi.Position;
    r = dec2hex(fix(roi.Position));
    r = join(string(r)',',');
    t(iShot) = {char(r)};
end

end

