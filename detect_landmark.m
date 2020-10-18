function landmark = detect_landmark(img)
    % ResNet: 224, AlexNet: 227, VGG: 224
    im_width = 224;
    im_height = 224;
    
    persistent net_g7
    if isempty(net_g7)
        load saved_networks\resnet18_e6.mat net_g7
    end
    
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    Rr = imresize(R,[im_width, im_height]);
    Gr = imresize(G,[im_width, im_height]);
    Br = imresize(B,[im_width, im_height]);
    
    img_resized = cat(3, Rr, Gr, Br);
    
    [~, scores] = classify(net_g7, img_resized);
    
    [~, idx] = max(scores);
    
    if idx == 1
        landmark = 0;
    elseif idx == 2
        landmark = 2;
    elseif idx == 3
        landmark = 1;
    end
end