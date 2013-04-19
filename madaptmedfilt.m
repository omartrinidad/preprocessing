% calculate the adaptive median filter

% function adaptmedfilt(image, sizeOfWindow, maxSizeOfWindow)
function image = madaptmedfilt(image)
    !clear; clear; clear all;
    % load image
    %image = dicomread('img.dcm');
    %image = [30 30 30 30 30; 30 30 30 30 30; 30 30 40 30 30; 44 30 91 49 60; 44 38 91 49 60];
    %disp(image);
    sizeOfWindow = 3;
    maxSizeOfWindow = 7;
    
    %image = image(50:53, 50:55);
    [cols rows] = size(image);
    
    for i = 1:1:cols-(sizeOfWindow-1)
        for j = 1:1:rows-(sizeOfWindow-1)

            % get the window according to sizeOfWindow
            repeat = 1; % true
            while repeat
                %fprintf('sizeOfWindow: %d-------------------------------------------\n', sizeOfWindow);
                if sizeOfWindow > 3
                    minus = ceil(sizeOfWindow/2) - 2;
                else
                    minus = 0;
                end
                %fprintf('%d:%d, %d:%d\n', i-minus, i+(sizeOfWindow-1)-minus,  j-minus, j+(sizeOfWindow-1)-minus);
                win = image(i - minus: i+(sizeOfWindow-1)-minus, j - minus:j+(sizeOfWindow-1)-minus);
                [minZ maxZ medZ index] = getValues(win);
                % LEVEL A
                a1 = medZ - minZ;
                a2 = medZ - maxZ;
                indexRow = (j - minus) + index - 1;
                indexCol = (i - minus) + index - 1;
                if a1 > 0 && a2 < 0 % <-- if minZ < medZ < maxZ
                    %disp(win);
                    %fprintf('minz %d < medz %d < maxz %d\n', minZ, medZ, maxZ);
                    %fprintf('medz is not an impulse, go to level B\n');
                    % medZ is not an impulse
                    repeat = 0; 
                    % go to level B, is the center and impulse?
                    center = image(indexCol, indexRow);
                    b1 = center - minZ;
                    b2 = center - maxZ;
                    if b1 > 0 && b2 < 0 % <-- if minZ < center < maxZ
                        %fprintf('minz %d < center %d < maxz %d\n', minZ, center, maxZ);
                        %fprintf('center is not an impulse\n');
                        % center is not an impulse
                        % center is output
                    else
                        % either center == maxZ or center == minZ
                        % output medZ, standard median filter
                        fprintf('standard median filter is the output\n');
                        image(indexCol, indexRow) = medZ;
                    end
                else 
                    % level A continues here
                    % medZ is an impulse
                    % the size of the window is increased (taking care of the margins)
                    %fprintf('Level A indexCol: %d\n', indexCol);
                    repeat = 0;
                    aux = ceil((sizeOfWindow+2)/2);
                    %fprintf('size-of-window+2 <= maxSizeOfWindow: %d <= %d\n', sizeOfWindow+2, maxSizeOfWindow);
                    if sizeOfWindow + 2 <= maxSizeOfWindow
                        %fprintf('indexCol %d, aux %d, cols %d\n', indexCol, aux, cols);
                        if indexCol - aux >= 0 && indexCol + aux <= cols
                            %fprintf('indexRow %d, aux %d, rows %d\n', indexRow, aux, rows);
                            if indexRow - aux >= 0 && indexRow + aux <= rows
                                %fprintf('Is possible to increase the window\n');
                                sizeOfWindow = sizeOfWindow + 2;
                                repeat = 1;
                            end
                        end
                    end
                    if ~repeat
                        sizeOfWindow = 3;
                        %fprintf('The window will not increase\n');
                    end
                end % else
            end % while
        end % end for j 
    end % end for i

function [minZ maxZ medZ index] = getValues(win)
    minZ = min(win(:));
    maxZ = max(win(:));
    medZ = median(double(win(:)));
    [cols, rows] = size(win);
    index = fix(cols/2) + 1;
