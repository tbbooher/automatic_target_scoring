fls = dir('files/*.jpg');
for i = 1:length(fls)
    disp(['working ' fls(i).name]);
    build_template(fls(i).name);
end