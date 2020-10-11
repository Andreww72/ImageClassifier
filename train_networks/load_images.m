function [training_data] = load_images(base_dir)
    levels = ["Level_1", "Level_2", "Level_3"];
    locations = ["Paris", "Sydney"];
    
    % Columns in the table
    training_data = array2table(zeros(0,4), "VariableNames", {'image_directory', 'level', 'location', 'image_name'});
    
    for level = levels
        for location = locations
           search_directory = base_dir + level + filesep + location + "/";
           dir_info = dir(search_directory + "*.png");
           file_names = string({dir_info.name});
           directory_path = string({dir_info.folder});
           image_directories = directory_path + filesep + file_names;
           
           % Add row
           for image_index = 1:length(file_names)
            image_directory = image_directories(image_index);
            image_name = file_names(image_index);
            image_location = directory_path(image_index) + file_names(image_index);
            cell = {image_directory, level, location, image_name};
            training_data = [training_data; cell];
           end
        end
    end
end