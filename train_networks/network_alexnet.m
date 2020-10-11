%% Setup
image_directory = "../EGH444_Project_2020_TrainingData/";

%% Transfer learning
net = alexnet; % Get Alexnet
inputSize = net.Layers(1).InputSize;
layersTransfer = net.Layers(1:end-3); % Use all trained layers except last 3

% Setup latyers
numClasses = numel(categories(imdsTrain.Labels));
layers = [
    layersTransfer % Transfer learning
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% Develop the model
imds = imageDatastore(image_directory, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% Split into training and validation 70-30
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

% The Alexnet (pretrained) requires input images of size 227-by-227-by-3
% Consequently, we have to resize to these deminisions. 
% Additionally, apply data augmentation ot randomly flip the training 
% images along the vertical axis, and randomly translate them up to 30 
% pixels horizontally and vertically.
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

% Automatically resize the validation images without performing further data
% augmentation 
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ... % Slow inital learning
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu');

% Train the model
netTransfer = trainNetwork(augimdsTrain,layers,options);

%% Validate
YPred = classify(netTransfer,augimdsValidation);
YValidation = augimdsValidation.Labels;
accuracy = mean(YPred == YValidation);