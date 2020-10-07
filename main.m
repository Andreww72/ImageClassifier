image_directory = "../EGH444_Project_2020_TrainingData/";
%[training_data] = load_images(image_directory);
%load('training_data.mat') % Just load the data without computation

imds = imageDatastore(image_directory, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)centerCropWindow2d(imread(loc),[300,300]);

numTrainFiles = 40;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');
inputSize = [300,300,3];
numClasses = 2;
layers = [
    imageInputLayer(inputSize)
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',4, ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'MiniBatchSize',3,...
    'ExecutionEnvironment', 'gpu');

net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation);

