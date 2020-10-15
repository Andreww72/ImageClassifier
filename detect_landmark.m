function landmark = detect_landmark(img)
    im_width = 224;
    im_height = 224;
    
    load resnet50_11-11-20.mat net
    
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    
    Rr = imresize(R,[im_width,im_height]);
    Gr = imresize(G,[im_width,im_height]);
    Br = imresize(B,[im_width,im_height]);
    
    img_resized = cat(3, Rr, Gr, Br);
    
    [~, scores] = classify(net, img_resized);
    
    [~, idx] = max(scores);
    
    if idx == 1
        landmark = 0;
    elseif idx == 2
        landmark = 2;
    elseif idx == 3
        landmark = 1;
    end
end