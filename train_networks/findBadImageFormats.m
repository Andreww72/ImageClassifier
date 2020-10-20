% Find bad image formats

image_directory = "../images/test_set2";
imds = imageDatastore(image_directory, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)imresize(imread(loc),[300,300]);
imds.ReadSize = numpartitions(imds);

fileNames = [string(imds.Files)];
badFiles = [];
for i = 1:length(fileNames)
   fileName = fileNames(i);
   try
       test = imread(fileName);
       if (size(test,3) ~= 3)
           badFiles = [badFiles fileName];
       end
   catch
       badFiles = [badFiles fileName];
   end
end