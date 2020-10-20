close all;
clear;
clc;

rootdir = 'images\test_set1\';
filelist = dir(fullfile(rootdir, '**\*.*')); % Includes subdirectories
filelist = filelist(~[filelist.isdir]);  % Remove folders

results = [];
correctImg = [];
for i = 1 : length(filelist)
        
    if contains(filelist(i).name, 'other')
        correctImg = [correctImg 0];
    elseif contains(filelist(i).name, 'paris')
        correctImg = [correctImg 2];
    else
        correctImg = [correctImg 1];
    end
    
    filename = strcat(filelist(i).folder, '\', filelist(i).name);
    img = imread(filename);
    
    % Classify test
    output = detect_landmark(img);
    results = [results output];
end

% Calculate accuracy
diff_test = correctImg - results;
acc_test = sum(diff_test == 0) / size(results, 2);
disp(acc_test);

% Show incorrects and what they were classified as
wrongs = struct2cell(filelist);
wrongs = wrongs(1, :);
wrongs = wrongs(diff_test ~= 0);

figure(1);
actualIndices = find(diff_test);
for i = 1 : length(wrongs)
    subplot(4, round(length(wrongs)/4)+1, i);
    hold on;
    img = imread(append(rootdir, char(wrongs(i))));
    imshow(img);
    
    
    if results(actualIndices(i)) == 0
        classifiedAs = 'Other';
    elseif results(actualIndices(i)) == 1
        classifiedAs = 'Sydney';
    elseif results(actualIndices(i)) == 2
        classifiedAs = 'Paris';
    end
    
    if correctImg(actualIndices(i)) == 0
        shouldHaveBeen = 'Other';
    elseif correctImg(actualIndices(i)) == 1
        shouldHaveBeen = 'Sydney';
    elseif correctImg(actualIndices(i)) == 2
        shouldHaveBeen = 'Paris';
    end
    
    title(append(classifiedAs, ' instead of ', shouldHaveBeen));
    hold off;
end
