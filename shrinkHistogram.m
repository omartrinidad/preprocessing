% Shrink histogram to compress the image

function [newData usedGraylevels] = shrinkHistogram(image, grayrange)
    %image = imadjust(image, [0, 1.0], [0.5, 0.8]);
    grays = 2^grayrange;
    data = imhist(image, grays); 
    usedGraylevels = 0;
    for i=1:1:grays
        if data(i) ~= 0
            usedGraylevels = usedGraylevels + 1;
        end
    end

    newData = zeros(usedGraylevels, 1);
    
    index = 1;
    for i=1:1:grays
        if data(i) ~= 0
           newData(index) = data(i);
           index = index + 1;
        end
    end

