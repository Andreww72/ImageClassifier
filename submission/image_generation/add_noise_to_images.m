clc; clear all;

% To create noisy rotated images, you have to add noise THEN rotate
input_dir = "../images/test_set2";
output_dir = "../images/test_set2";

root_dir = pwd;

rng(1) % Seed

% Create the output directory, if it doesn't exist
if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

% Cycle through directories and do this stuff

cd(input_dir);
D = dir;
for k = 3:length(D)
    currD = D(k).name;
    disp(currD)
    cd(currD)
    file_list = dir;
    
    % Cycle through images in subdirectory
    for i = 3:length(file_list)
        fprintf("Adding noise to %s...", file_list(i).name);
        img_filename = fullfile(file_list(i).folder, file_list(i).name);
        gaussian_or_sp = rand > 0.5;
        image = imread(img_filename);
        % Add appropriate noise
        if gaussian_or_sp
            mu = 0;%rand * 255;
            sigma = rand * 0.15 + 0.05; % idk
            g = imnoise(image, 'gaussian', mu, sigma);
        else
            density = rand * 0.3 + 0.1; % Randomly grab salt and pepper density
            g = imnoise(image, 'salt & pepper', density);
        end
        
        if ~exist(fullfile(root_dir, output_dir, currD), 'dir')
            mkdir(fullfile(root_dir, output_dir, currD))
        end
        
        [path, name, ext] = fileparts(file_list(i).name);
        if gaussian_or_sp
            img_output_name = sprintf("%s_gaussian%s", name, ext);
        else
            img_output_name = sprintf("%s_s&p%s", name, ext);
        end
        
        output_filename = fullfile(root_dir, output_dir, currD, img_output_name);
        imwrite(g, output_filename);
        fprintf(" success\n");
    end
    
    cd(fullfile(root_dir, input_dir))
end

cd(root_dir);
disp("Done!");