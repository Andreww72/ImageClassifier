rootdir = 'Images\Provided';
filelist = dir(fullfile(rootdir, '**\*.*')); % Includes subdirectories
filelist = filelist(~[filelist.isdir]);  % Remove folders

results = [];
expected = [];
for i = 1 : length(filelist)
    
    if contains(filelist(i).folder, 'Other')
        expected = [expected 1];
    elseif contains(filelist(i).folder, 'Paris')
        expected = [expected 2];
    else
        expected = [expected 3];
    end
    
    filename = strcat(filelist(i).folder, '\', filelist(i).name);
    img = imread(filename);
    
    % Classify test
    output = detect_landmark(img);
    results = [results output];
        
end

diff_test = expected - results;
acc_test = sum(diff_test == 0) / size(results);
