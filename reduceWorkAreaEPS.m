
function reducedImage = reduceWorkAreaEPS()
    
    originalImage = dicomread('col/1/rcc.dcm');
    originalImage = f12to16bits(originalImage);
    fig = figure;
    imshow(originalImage); colormap bone;
    print(fig, '-dpsc2', 'images/area/original.eps');    
    
    % binarize image
    imageDouble = double(originalImage);
    threshold = graythresh(imageDouble);
    bw = im2bw(imageDouble, threshold);

    xcolormap = [0.5 0.5 1; 0.9 0.9 0.9]; % background; foreground
    imshow(bw, xcolormap);
    print(fig, '-dpsc2', 'images/area/whiteandblack.eps');    

    % bw =~ bw;

    % -------------- [Delete the little objects] ------------------
    bw2 = bwareaopen(bw, 10000); % delete objects with less than 10000 pixels
    imshow(bw2, xcolormap);
    print(fig, '-dpsc2', 'images/area/deleteobj.eps');    

    bw2 = imfill(bw2, 'holes'); % fill the black sections
    imshow(bw2, xcolormap);
    print(fig, '-dpsc2', 'images/area/fillholes.eps');    

    % --------------- [ Bordering ] ------------------
    boundaries = bwboundaries(bw2, 'noholes');

    hold on;
    for x = 1:length(boundaries)
        boundary = boundaries{x};
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
    end
    print(fig, '-dpsc2', 'images/area/bordering.eps');    
    hold off;

    % --------------- [ Get borders ] ------------------
    max_y = max(boundaries{1}(:,1));
    max_x = max(boundaries{1}(:,2));

    min_y = min(boundaries{1}(:,1));
    min_x = min(boundaries{1}(:,2));

    shape =[min_x min_y min_x+max_x max_y-min_y];

    %rectangle('position', shape, 'facecolor', 'r');

    % --------------- [ Cutting ] ------------------
    reducedImage = originalImage(min_y: max_y, min_x:max_x);
    imshow(reducedImage); colormap bone;
    print(fig, '-dpsc2', 'reduced.eps');    
end
