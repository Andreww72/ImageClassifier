rootdir = 'images\test_set\';
filelist = dir(fullfile(rootdir, '**\*.*')); % Includes subdirectories
filelist = filelist(~[filelist.isdir]);  % Remove folders

results = [];
expected = [];
for i = 1 : length(filelist)
    
    if contains(filelist(i).name, 'other')
        expected = [expected 0];
    elseif contains(filelist(i).name, 'paris')
        expected = [expected 2];
    else
        expected = [expected 1];
    end
    
    filename = strcat(filelist(i).folder, '\', filelist(i).name);
    img = imread(filename);
    
    % Classify test
    output = detect_landmark(img);
    results = [results output];
end

diff_test = expected - results;
acc_test = sum(diff_test == 0) / size(results, 2);
disp(acc_test);