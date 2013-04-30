% manual histogram
function [bins] = shrinkHistogram(image, grayrange)
    image = imadjust(image, [0, 1.0], [0.5, 0.8]);
    
    xy = size(image);
    bins = zeros(1, 2^grayrange);

    for x = 1:1:xy(1)
        for y = 1:1:xy(2)
            value = image(x, y);
            disp(x), disp(y);
            value = value + 1; %avoid zero index
            bins(value) = bins(value) + 1;
        end
    end

% disp(sum(output)) <=> xy(1)*xy(2)

