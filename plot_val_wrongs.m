% load ...

numShow = 9;
idx = randperm(numel(imdsValidation.Files), numShow);
figure(1);
for i = 1 : numShow
    subplot(3, 3, i)
    I = readimage(imdsValidation, idx(i));
    imshow(I);
    title(string(YPred(idx(i))) + ", " + ...
        num2str(100*max(probs(idx(i), :)), 3) + "%, " + ...
        string(imdsValidation.Labels(idx(i))));
end

accuracy = mean(YPred == imdsValidation.Labels);
diff = YPred ~= imdsValidation.Labels;
num_wrong = sum(diff);
disp("Accuracy: " + accuracy +  " Num Wrong: " + num_wrong);

idx = randperm(num_wrong, numShow);
wrongs = find(diff);

figure(2);
for i = 1 : numShow
    subplot(3, 3, i)
    I = readimage(imdsValidation, wrongs(idx(i)));
    imshow(I)
    title(string(YPred(wrongs(idx(i)))) + ", " + ...
        num2str(100*max(probs(idx(i), :)), 3) + "%, " + ...
        string(imdsValidation.Labels(wrongs(idx(i)))));
end