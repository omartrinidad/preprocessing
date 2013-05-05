% Shrink histogram to compress the image

function [newData imageCopy] = shrinkHistogram(image, grayrange)
    %image = imadjust(image, [0, 1.0], [0.5, 0.8]);
    grays = 2^grayrange;
    data = imhist(image, grays); 
    %[x y] = size(data);
    usedGrayLevels = 0;
    for i=1:1:grays
        if data(i) ~= 0
            usedGrayLevels = usedGrayLevels + 1;
        end
    end

    newData = zeros(usedGrayLevels, 1);
    
    index = 1;
    for i=1:1:grays
        if data(i) ~= 0
           newData(index) = data(i);
           index = index + 1;
        end
    end

    % compresion
    [height width] = size(image);
    imageCopy = repmat(uint8(0), height, width);
    divider = 0.0;
    maxLevel = double(max(image(:)));
    
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
    
