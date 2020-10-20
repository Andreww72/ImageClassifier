close all;
clear;
clc;

rootdir = 'images\test_set2\';
filelist = dir(fullfile(rootdir, '**\*.*')); % Includes subdirectories
filelist = filelist(~[filelist.isdir]);  % Remove folders

results = [];
probs = [];
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
    %landmark= detect_landmark(img);
    [landmark, prob] = detect_landmark_wprob(img);
    results = [results landmark];
    probs = [probs prob];
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
    index = actualIndices(i);
    
    subplot(4, ceil(length(wrongs)/4), i);
    hold on;
    img = imread(append(rootdir, char(wrongs(i))));
    imshow(img);
    
    if results(index) == 0
        classifiedAs = 'Other';
    elseif results(index) == 1
        classifiedAs = 'Sydney';
    elseif results(index) == 2
        classifiedAs = 'Paris';
    end
    
    if correctImg(index) == 0
        shouldHaveBeen = 'Other';
    elseif correctImg(index) == 1
        shouldHaveBeen = 'Sydney';
    elseif correctImg(index) == 2
        shouldHaveBeen = 'Paris';
    end
    
    title(classifiedAs + " instead of " + shouldHaveBeen);
    hold off;
end
