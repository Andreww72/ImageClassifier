function landmark = detect_landmark(img)
    % ResNet: 224, AlexNet: 227, MobileNet: 224, Inceptionv2, 299
    im_size = 224;
    %im_size = 227;
    %im_size = 299;
    
    persistent net_g7
    if isempty(net_g7)
        %load saved_networks\alexnet_e3.mat net_g7
        %load saved_networks\resnet18_e3.mat net_g7
        %load saved_networks\inceptionv2_e3.mat net_g7
        %load saved_networks\mobilenetv2_e3.mat net_g7
        
        %load saved_networks\alexnet_e4.mat net_g7
        load saved_networks\resnet18_e4.mat net_g7
        %load saved_networks\inceptionv2_e4.mat net_g7
        %load saved_networks\mobilenetv2_e4.mat net_g7
    end
    
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    Rr = imresize(R,[im_size, im_size]);
    Gr = imresize(G,[im_size, im_size]);
    Br = imresize(B,[im_size, im_size]);
    
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