% load ...

numShow = 2;
idx = randperm(numel(imdsValidation.Files), numShow);
idx = [574 1121 274 802];
figure(1);
for i = 1 : numShow
    subplot(2, 2, i)
    I = readimage(imdsValidation, idx(i));
    imshow(I);
    title(string(imdsValidation.Labels(idx(i))));
end

accuracy = mean(YPred == imdsValidation.Labels);
diff = YPred ~= imdsValidation.Labels;
num_wrong = sum(diff);
disp("Accuracy: " + accuracy +  " Num Wrong: " + num_wrong);

idx = [1:47];
idx = [4 8 5]; % Wrong others
idx = [21 24 23]; % Wrong Paris
idx = [38 31 35]; % Wrong Sydney
wrongs = find(diff);

figure(2);
for i = 1 : 3
    subplot(1, 3, i)
    I = readimage(imdsValidation, wrongs(idx(i)));
    imshow(I)
    title(string(YPred(wrongs(idx(i)))) + ", instead of " + ...
        string(imdsValidation.Labels(wrongs(idx(i)))));
end