
% generates images showing the compression process
function [newData imageCopy] = shrinkHistogram()

    dicom = dicomread('1/rcc.dcm');
    dicom = reduceWorkArea(dicom);
    image = f12to16bits(dicom);
    %image = adpmedian(dicom, 9);

    %image = adapthisteq(dicom, 'cliplimit', 0.0025, ...
    %                             'numtiles', [10 10], 'nbins', 256, ...
    %                             'distribution', 'exponential');

    % ------------[ image shrinking procedure ]-----------------------
    fprintf('image shrinking procedure');

    fig = figure;
    % original mammogram 16 bits
    imshow(image); colormap bone;
    print(fig, '-dpsc2', 'images/compress/original-mammogram-16bits.eps');
    
    grays = 2^16; 
    [data, x] = imhist(image, grays); 
    [width height] = size(data);
    usedGrayLevels = 0;
    for i=1:1:grays
        if data(i) ~= 0
            usedGrayLevels = usedGrayLevels + 1;
        end
    end

    % plot original histogram
    bar(data(2:end)); grid on;
    set(gca,'box', 'on','xticklabel', [],'yticklabel', [], 'linewidth', 2.5);
    print(fig, '-dpsc2', 'images/compress/original-image-histogram.eps');
    
    % shrink histogram, the gaps are deleted
    newData = zeros(width, 1);
    newX = zeros(width, 1);
    index = 1;
    for i=1:1:grays
        if data(i) ~= 0
           newData(index) = data(i);
           newX(index) = x(i);
           index = index + 1;
        end
    end
    % plot shrunk histogram
    bar(newData(2:end)); grid on; 
    set(gca,'box', 'on','xticklabel', [],'yticklabel', [], 'linewidth', 2.5);
    print(fig, '-dpsc2', 'images/compress/shrunk-histogram.eps');

    % modify the image from the new histogram
    image = shrinkImage(image, usedGrayLevels, grays);

    % dark mammogram 16 bits
    imshow(image); colormap bone;
    print(fig, '-dpsc2', 'images/compress/dark-mammogram.eps');
    
    % dark mammogram histogram
    [a b] = imhist(image);
    bar(a(2:end)); grid on;
    set(gca,'box', 'on','xticklabel', [],'yticklabel', [], 'linewidth', 2.5);
    print(fig, '-dpsc2', 'images/compress/dark-mammogram-histogram.eps');

    % ------------[ pixel depth conversion ]-----------------------
    fprintf('pixel depth conversion');

    % compression
    [height width] = size(image);
    imageCopy = repmat(uint8(0), height, width);
    divider = 0.0;
    maxLevel = double(usedGrayLevels);
    
    while 1
        divider = divider + 0.01;
        if maxLevel/divider <= 255
            break;
        end
    end
    for h=1:1:height
        for w=1:1:width
           imageCopy(h, w) = image(h, w)/divider;
        end
    end

    % compressed mammogram
    imshow(imageCopy); colormap bone;
    print(fig, '-dpsc2', 'images/compress/compressed-mammogram-8bits.eps');
    % compressed mammogram histogram
    [a b] = imhist(imageCopy);
    bar(a(2:end)); grid on; 
    set(gca,'box', 'on','xticklabel', [],'yticklabel', [], 'linewidth', 2.5);
    print(fig, '-dpsc2', 'images/compress/compressed-mammogram-histogram.eps');

    %second method
    [height width] = size(image);
    imageCopy = repmat(uint8(0), height, width);
    minValue = double(min(image(:)));
    maxValue = double(max(image(:)));
    piece = double(255.0/(maxValue - minValue));
    for h=1:1:height
        for w=1:1:width
           imageCopy(h, w) = uint8((image(h, w) - minValue)*piece);
        end
    end
    
    % third method    
    imageCopy = uint8(image/256);

function newImage = shrinkImage(image, minVal, maxVal)
    valueDesired = 1.0/(maxVal/minVal);
    newImage = imadjust(image, [0, 1.0], [0.0, valueDesired]);
