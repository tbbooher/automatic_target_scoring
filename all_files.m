fls = dir('registered/*.jpg');
data = cell(length(fls),1);

%% build template
figure
template_width = 25;
radius = (template_width-1)/2;
M = zeros(template_width);
mid = (template_width+1)/2;
M(mid,mid) = 1;
R = bwdist(M);
template = (R < radius+1); %& (R > radius-1));

%% run all files


for i = 1:length(fls)
    close all;
    [filepath,shortname,ext] = fileparts(fls(i).name);
    disp(['working ' shortname]);
    [d,score] = find_and_score(fullfile(fls(i).folder,fls(i).name),template,radius);
    dates{i} = d;
    scores(i) = score;
end