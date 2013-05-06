
function reducedImage = reduceWorkArea(originalImage)
    
    % binarize image
    fig = figure;
    threshold = graythresh(originalImage);

    bw = im2bw(originalImage, threshold);
    xcolormap = [0.5 0.5 1; 0.9 0.9 0.9]; % background; foreground
    %imshow(bw, xcolormap);
    %print(fig, '-dpsc2', 'whiteandblack.eps');    

    % bw =~ bw;
    % ifigure, imshow(bw);
    % hold on;

    % find the boundaries
    % boundaries = bwboundaries(bw);


    % delete the little objects
    bw2 = bwareaopen(bw, 10000); % delete objects with less than 10000 pixels
    %imshow(bw2, xcolormap);
    %print(fig, '-dpsc2', 'deleteobj.eps');    
    bw2 = imfill(bw2, 'holes'); % fill the black sections
    %imshow(bw2, xcolormap);
    %print(fig, '-dpsc2', 'fillholes.eps');    

    boundaries = bwboundaries(bw2, 'noholes');
    hold on;

    % draw boundaries
    for x = 1:length(boundaries)
        boundary = boundaries{x};
        %plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
    end

    % print(fig, '-dpsc2', 'bordering.eps');    

    hold on;

    max_y = max(boundaries{1}(:,1));
    max_x = max(boundaries{1}(:,2));

    min_y = min(boundaries{1}(:,1));
    min_x = min(boundaries{1}(:,2));

    shape =[min_x min_y min_x+max_x max_y-min_y];
    %disp(shape);

    %rectangle('position', shape, 'facecolor', 'r');
    hold off;

    % cut the figure
    % figure, imshow(originalImage(min_y: max_y, min_x:max_x)); % a.dcm and c.dcm
    reducedImage = originalImage(min_y: max_y, min_x:max_x);
    %imshow(reducedImage);
    %colormap bone;
    %print(fig, '-dpsc2', 'reduced.eps');    
    %imshow(image(min_y: max_y+150, min_x-150:max_x)); % b.dcm and d.dcm

