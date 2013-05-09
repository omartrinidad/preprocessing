% Shrink histogram to compress the image

function [newData imageCopy] = shrinkHistogram(image, grayrange)
    grays = 2^grayrange;
    [data, x] = imhist(image, grays); 
    [width height] = size(data);
    usedGrayLevels = 0;
    for i=1:1:grays
        if data(i) ~= 0
            usedGrayLevels = usedGrayLevels + 1;
        end
    end
    fig = figure;
    % plot original histogram
    bar(data(2:end)); grid on;
    print(fig, '-dpsc2', 'images/original-image-histogram.eps');
    
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
    print(fig, '-dpsc2', 'images/shrunk-histogram.eps');

    % modify the image from the new histogram
    image = shrinkImage(image, usedGrayLevels, grays);

    % dark mammogram
    imshow(image);
    print(fig, '-dpsc2', 'images/dark-mammogram.eps');
    
    % dark mammogram histogram
    [a b] = imhist(image);
    bar(a(2:end)); grid on;
    print(fig, '-dpsc2', 'images/dark-mammogram-histogram.eps');

    % compresion
    [height width] = size(image);
    imageCopy = repmat(uint8(0), height, width);
    divider = 0.0;
    %maxLevel = double(max(image(:))); % good quality image
    %maxLevel = double(newData(:)); % image too dark
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
    imshow(imageCopy);
    print(fig, '-dpsc2', 'images/compressed-mammogram.eps');
    % compressed mammogram histogram
    [a b] = imhist(imageCopy);
    bar(a(2:end)); grid on;
    print(fig, '-dpsc2', 'images/compressed-mammogram-histogram.eps');

    %second method
    %[height width] = size(image);
    %imageCopy = repmat(uint8(0), height, width);
    %minValue = double(min(image(:)));
    %maxValue = double(max(image(:)));
    %piece = double(255.0/(maxValue - minValue));
    %for h=1:1:height
    %    for w=1:1:width
    %       imageCopy(h, w) = uint8((image(h, w) - minValue)*piece);
    %    end
    %end
    
    %third method    
    %imageCopy = uint8(image/256);

function newImage = shrinkImage(image, minVal, maxVal)
    valueDesired = 1.0/(maxVal/minVal);
    fprintf('valueDesired: %f\n', valueDesired);
    fprintf('maxVal: %f and minVal: %f\n', maxVal, minVal);
    newImage = imadjust(image, [0, 1.0], [0.0, valueDesired]);
