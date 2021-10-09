fls = dir('files/*.jpg');
for i = 1:length(fls)
    fileName = fls(i).name;
    disp(['working ' fileName]);
    f = fullfile(fls(i).folder,fileName);
    manual_register(f)
end