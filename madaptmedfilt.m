%
% calculate the adaptive median filter
%

% function adaptmedfilt(image, sizeOfWindow, maxSizeOfWindow)
function adaptmedfilt()
    % load image
    image = dicomread('img2.dcm');
    figure, imshow(image);
    image = imnoise(image, 'salt & pepper', 0.2);
    figure, imshow(image);
    sizeOfWindow = 3;
    maxSizeOfWindow = 7;
    
    %image = image(50:53, 50:55);
    [cols rows] = size(image);
    

    for i = 1:1:cols-(sizeOfWindow-1)
        for j = 1:1:rows-(sizeOfWindow-1)

            % get the window according to sizeOfWindow
            repeat = 1; % true
            while repeat
                win = image(i: i+(sizeOfWindow-1), j:j+(sizeOfWindow-1));
                [minZ maxZ medZ index] = getValues(win);
                % level A
                a1 = medZ - minZ;
                a2 = medZ - maxZ;
                indexRow = j + index - 1;
                indexCol = i + index - 1;
                if a1 > 0 && a2 < 0
                    % medZ is not an impulse
                    % level B
                    b1 = image(indexCol, indexRow) - minZ;
                    b2 = image(indexCol, indexRow) - maxZ;
                    repeat = 0;
                    if b1 > 0 && b2 < 0
                        % tc(center, center) is not and impulse
                        % output image(i, j)
                        disp('there is no change in the image');
                    else
                        % output medZ, standard median filter
                        % I guess, there is change in the image
                        image(indexCol, indexRow) = medZ;
                        disp('there is a change in the image, replace by standard median filter');
                    end
                else % level A -> medZ is an impulse
                    % the size of the window is increased (taking care of the margins)
                    if indexCol >= 4 && indexCol <= cols - 3
                        if indexRow >= 4 && indexRow <= rows - 3
                            if sizeOfWindow < maxSizeOfWindow
                                sizeOfWindow = sizeOfWindow + 2; % increase the window size
                                disp('repeat the level A, increase the window');
                                repeat = 1;
                            else
                                repeat = 0;
                            end
                        else
                            repeat = 0;
                        end
                    else
                        repeat = 0;
                    end
                end
            end % while
        end % end for j 
    end % end for i
    figure, imshow(image);

function [minZ maxZ medZ index] = getValues(win)
    minZ = min(win(:));
    maxZ = max(win(:));
    medZ = median(double(win(:)));
    [cols, rows] = size(win);
    index = fix(cols/2) + 1;
