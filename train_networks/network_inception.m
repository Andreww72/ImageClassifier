%% Inception-v3
% https://au.mathworks.com/help/deeplearning/ref/inceptionv3.html
% https://au.mathworks.com/help/deeplearning/ug/train-deep-learning-network-to-classify-new-images.html

close all;
clear;
clc;

%% Setup
% Leave provided images as a test set
image_directory = "../Images/Collected/";
imds = imageDatastore(image_directory, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)imresize(imread(loc),[300,300]);
imds.ReadSize = numpartitions(imds);

% Split into training and validation 70-30
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7);
numClasses = numel(categories(imdsTrain.Labels));

%% Transfer learning
net_g7 = inceptionv3;
%analyzeNetwork(net)
net_g7.Layers(1)
inputSize = net_g7.Layers(1).InputSize;

% Replace final layers
if isa(net_g7,'SeriesNetwork') 
  lgraph = layerGraph(net_g7.Layers); 
else
  lgraph = layerGraph(net_g7);
end
[learnableLayer,classLayer] = findLayersToReplace(lgraph);

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

% Check network reconstructed correctly
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

% Important variables
layers = lgraph.Layers;
connections = lgraph.Connections;

% Freeze initial layers (layers in initial stem)
layers(1:17) = freezeWeights(layers(1:17));
lgraph = createLgraphUsingConnections(layers,connections);

%% Train network
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);

augimdsTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

miniBatchSize = 64;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');

net_g7 = trainNetwork(augimdsTrain,lgraph,options);

%% Classify validation images
[YPred,probs] = classify(net_g7,augimdsValidation);
accuracy = mean(YPred == imdsValidation.Labels)
