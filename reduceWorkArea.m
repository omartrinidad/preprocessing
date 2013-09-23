
function reducedImage = reduceWorkArea()
    
    originalImage = dicomread('col/1/rcc.dcm');
    originalImage = f12to16bits(originalImage); % only for better visualization

    fig = figure;
    imshow(originalImage); colormap bone;
    print(fig, '-dpsc2', 'images/area/original.eps');

    % binarize image
    imageDouble = double(originalImage);
    threshold = graythresh(imageDouble);
    bw = im2bw(imageDouble, threshold);

    imshow(bw); 
    print(fig, '-dpsc2', 'images/area/whiteandblack.eps');

    % delete the little objects
    bw2 = bwareaopen(bw, 10000); % delete objects with less than 10000 pixels
    bw2 = imfill(bw2, 'holes'); % fill the black sections

    % get the boundaries
    boundaries = bwboundaries(bw2, 'noholes');
    
    for x = 1:length(boundaries)
        boundary = boundaries{x};
    end
    
    % get coordinates
    max_y = max(boundaries{1}(:,1));
    max_x = max(boundaries{1}(:,2));

    min_y = min(boundaries{1}(:,1));
    min_x = min(boundaries{1}(:,2));

    % cut the image
    reducedImage = originalImage(min_y: max_y, min_x:max_x);
end
