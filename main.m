
% icons /usr/share/icons
% get pixels with percentages

function varargout = main(varargin)
    % Description of GUI and main variables
    % h is a handle structure
    close all;
    
    sizeOfScreen = get(0,'ScreenSize');
    hMainFigure = figure('position', sizeOfScreen,...
           'name', 'Preprocessing System of Mammograms',...
           'numbertitle', 'off',...
           'menubar', 'none');

    % GUI Controls
    % Position -> [hposition vposition hsize vsize] percentage
    position = [.02 .02 .15 .94];
    ph = uipanel('parent', hMainFigure, 'title', 'Image selector',...
                 'position', position);

    % Menus
    mainMenu = uimenu('label', 'File');
    openFile = uimenu(mainMenu, 'label', 'Load image(s)', ...
                      'callback', @openFileCallback);

    % Axe
    position = [.17 .02 .81 .94];
    [weigth hight] = getSizeOfAxe(position, sizeOfScreen);
    mainAxe = axes('parent', hMainFigure, 'visible', 'on', ...
                   'position', position);

    % function to convert percentage to pixels 
    function [weigth hight] = getSizeOfAxe(percentages, sizeOfScreen)
        sizeOfScreen = sizeOfScreen(3:4);
        sizeOfScreen = [sizeOfScreen sizeOfScreen];
        pixels = int16(percentages .* sizeOfScreen);
        weigth = pixels(3)-pixels(1);
        hight = pixels(4)-pixels(2);
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
        I = adpmedian(I, 7);
        if hight < h && weigth < w
            imshow(I(1:hight, 1:weigth));
        else
            imshow(I(1:h, 1:w));
        end
        colormap bone;
        % load and show the images(s) in the left side
        numberOfFiles = size(files, 2);
        hAxes = zeros(numberOfFiles);
        for i=1:numberOfFiles
            fileToSelect = dicomread([path files{i}]);
            hAxes(i) = axes('position', [0.04 0.04 0.1 0.25]);
        end
    end
end % ending main function
