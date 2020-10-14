clc; clear all;

% To create noisy rotated images, you have to add noise THEN rotate
input_dir = "Images/Collected/Level1";
output_dir = "Images/Collected/Level3";

root_dir = pwd;

rng(1) % Seed

% Create the output directory, if it doesn't exist
if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

% Cycle through directories and do this stuff
D = dir(input_dir);
cd(input_dir);
for k = 3:length(D)
    currD = D(k).name;
    disp(currD)
    cd(currD)
    file_list = dir;
    
    % Cycle through images in subdirectory
    for i = 3:length(file_list)
        img_filename = fullfile(file_list(i).folder, file_list(i).name);
        gaussian_or_sp = rand > 0.5;
        image = imread(img_filename);
        % Add appropriate noise
        if gaussian_or_sp
            mu = rand * 255;
            sigma = rand * 255 * 0.66; % idk
            g = imnoise(image, 'gaussian', mu, sigma);
        else
            D = rand * 0.5; % Randomly grab salt and pepper density
            g = imnoise(image, 'salt & pepper', D);
        end
        
        if ~exist(fullfile(root_dir, output_dir, currD), 'dir')
            mkdir(fullfile(root_dir, output_dir, currD))
        end
        
        output_filename = fullfile(root_dir, output_dir, currD, file_list(i).name);
        fprintf("Adding noise to %s...\n", file_list(i).name);
        imwrite(g, output_filename);
    end
    
    cd('..')
end