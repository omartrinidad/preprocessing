
% icons /usr/share/icons
% get pixels with percentages

function varargout = main(varargin)
    % Description of GUI and main variables
    % h is a handle structure
    close all;
    
    sizeOfScreen = get(0,'ScreenSize');
    hMainFigure = figure('position', sizeOfScreen,...
           'name', 'Preprocessing System of Mammograms',...
           'numbertitle', 'off', 'dockcontrols', 'off', ...
           'menubar', 'none');

    % GUI Controls
    % Position -> [hposition vposition hsize vsize] percentage
    positionLeftPanel = [.02 .02 .15 .94];
    ph = uipanel('parent', hMainFigure, 'title', 'Image selector',...
                 'position', positionLeftPanel);

    % Menus
    mainMenu = uimenu('label', 'File');
    openFile = uimenu(mainMenu, 'label', 'Load image(s)', ...
                      'callback', @openFileCallback);

    % Axe
    position = [.17 .02 .81 .94];
    [width height] = getSizeOfAxe(position, sizeOfScreen);
    mainAxe = axes('parent', hMainFigure, 'visible', 'on', ...
                   'position', position);
    set(mainAxe, 'yticklabel', '', 'xticklabel', '');

    % function to convert percentage to pixels 
    function [width height] = getSizeOfAxe(percentages, sizeOfScreen)
        sizeOfScreen = sizeOfScreen(3:4);
        sizeOfScreen = [sizeOfScreen sizeOfScreen];
        pixels = int16(percentages .* sizeOfScreen);
        width = pixels(3)-pixels(1);
        height = pixels(4)-pixels(2);
    end

    % Callback functions
    function openFileCallback(hObject, eventdata)
        [files path] = uigetfile({'*dcm'; '*.dicomdir'; '*.*'},...
                                'multiselect', 'on');
        if ~path
            return;
        elseif ~iscell(files)
            fprintf('Only one file choosed\n');
            temp = files;
            files = cell(1);
            files{1} = temp;
        end
        % load and show the image in the main Axe
        pathfile = strcat(path, files{1});
        I = dicomread(pathfile);
        I = reduceWorkArea(I);
        [h w] = size(I);
        I = f12to16bits(I);
        % I = adpmedian(I, 7);
        if height < h && width < w
            imshow(I(1:height, 1:width));
        else
            imshow(I(1:h, 1:w));
        end
        colormap bone;
        % load and show the images(s) in the left side
        % calculate left and right margins
        space = 0.01;
        left = positionLeftPanel(1) + space;
        right = positionLeftPanel(3) - space;
        down = positionLeftPanel(2) + space;
        up = positionLeftPanel(4) - space;

        % calculate height of each image
        numberOfFiles = size(files, 2);
        heightOfImage = up - down - (space * numberOfFiles);
        heightOfImage = heightOfImage/numberOfFiles;
        
        hAxes = zeros(numberOfFiles);
        for i=1:numberOfFiles
            fileToSelect = dicomread([path files{i}]);
            up = down + heightOfImage;
            hAxes(i) = axes('position', [left down right-left up-down]);
            down = up + space;
            imagesc(fileToSelect, 'buttondownfcn', {@showImageSelected, fileToSelect});
            axis off; axis image;
        end
    end % ending openFileCallback function

    function showImageSelected(hObject, eventdata, fileSelected)
        axes(mainAxe); % use the Axe selected
        I = reduceWorkArea(fileSelected);
        [h w] = size(I);
        I = f12to16bits(I);
        % I = adpmedian(I, 7);
        if height < h && width < w
            imshow(I(1:height, 1:width));
        else
            imshow(I(1:h, 1:w));
        end
        colormap bone;
    end
end % ending main function
