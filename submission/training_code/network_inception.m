%% InceptionV3 model training
% Similar files were constructed for AlexNet, ResNet18, MobileNetV2, VGG16.
% They differ in the imresize, network loaded, and layers frozen.
close all;
clear;
clc;

%% Load training set
% Load training set and not the test sets
image_directory = "../../images/train_set/";
imds = imageDatastore(image_directory, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)imresize(imread(loc), [299, 299]);
imds.ReadSize = numpartitions(imds);

% Split into training and validation 70-30
[imdsTrain,imdsValidation] = splitEachLabel(imds, 0.7);
numClasses = numel(categories(imdsTrain.Labels));

%% Transfer learning
% https://au.mathworks.com/help/deeplearning/ref/inceptionv3.html
net_g7 = inceptionv3;
inputSize = net_g7.Layers(1).InputSize;

% Replace final layers
lgraph = layerGraph(net_g7);
[learnableLayer, classLayer] = findLayersToReplace(lgraph);
newLearnableLayer = fullyConnectedLayer(numClasses, ...
    'Name', 'our_fc', ...
    'WeightLearnRateFactor', 10, ...
    'BiasLearnRateFactor', 10);

lgraph = replaceLayer(lgraph,learnableLayer.Name, newLearnableLayer);
newClassLayer = classificationLayer('Name', 'new_classoutput');
lgraph = replaceLayer(lgraph, classLayer.Name, newClassLayer);

% Freeze initial layers (17 layers in initial stem)
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:17) = freezeWeights(layers(1:17));
lgraph = createLgraphUsingConnections(layers, connections);

%% Train network
miniBatchSize = 32;
valFrequency = floor(numel(imdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize', miniBatchSize, ...
    'MaxEpochs', 6, ...
    'InitialLearnRate', 3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData', imdsValidation, ...
    'ValidationFrequency', valFrequency, ...
    'Verbose', false, ...
    'Plots', 'training-progress', ...
    'ExecutionEnvironment', 'gpu');

net_g7 = trainNetwork(imdsTrain, lgraph, options);

%% Classify validation images
[YPred, ~] = classify(net_g7, imdsValidation);
accuracy = mean(YPred == imdsValidation.Labels);
disp("InceptionV3 accuracy: " + accuracy);

%% References
% https://au.mathworks.com/help/deeplearning/ug/train-deep-learning-network-to-classify-new-images.html
% https://au.mathworks.com/help/deeplearning/ref/inceptionv3.html
