fls = dir('files/*.jpg');
for i = 1:length(fls)
    fileName = fls(i).name;
    disp(['working ' fileName]);
    f = fullfile(fls(i).folder,fileName);
    disp(f)
    [cleanTargetCenter, cleanTargetRadius] = find_circle(f);
    if isempty(cleanTargetCenter)
        disp([fileName ' did not work'])
    else
        disp([fileName ' worked'])
    end
end