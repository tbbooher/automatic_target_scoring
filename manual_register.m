
function score = manual_register(fileName)
close all;

[~, shortname, ~] = fileparts(fileName);
ortho = imread('files\flat.png');
%% get the target distance
range_distance = prompt('how far was the target?');
%% make sure the orientation is right
unregistered = imread(fileName);
imshow(unregistered);
deg = input('rotation?');
unregistered = imrotate(unregistered,deg);
imshow(unregistered);
%% first, let's crop the image
Icropped = imcrop(unregistered);
%% now, let's select control points
[mp,fp] = cpselect(Icropped,ortho,'Wait',true);
t = fitgeotrans(mp,fp,'projective');
Rfixed = imref2d(size(ortho));
registered = imwarp(Icropped,t,'OutputView',Rfixed);

%% now find the relevant points
[positions, t] = find_points(registered);

score = get_and_draw_score(positions, registered, shortname, t, range_distance);

%% now get actual shots

imshowpair(ortho,registered,'blend');
pause;
disp(['completed ' shortname])
end
