
% icons /usr/share/icons
% First /nick omart and then /msg nickserv register yourpassword youremail
% receive an email: /msg NickServ VERIFY REGISTER omartrinidad somethingalgo

function varargout = main(varargin)
    % Description of GUI and main variables

    hMainFigure = findall(0, 'tag', 'maingui');
    % Start Singleton
    if (isempty(hMainFigure))
        sizeOfScreen = get(0,'ScreenSize');
        hMainFigure = figure('position', sizeOfScreen,...
               'name', 'Preprocessing System of Mammograms',...
               'numbertitle', 'off', 'dockcontrols', 'off', ...
               'tag', 'maingui', 'menubar', 'none');
        set(hMainFigure, 'keypressfcn', @mainKeyPressFcn);
        set(hMainFigure, 'deletefcn', @close);

        % GUI Controls
        % Position -> [hposition vposition hsize vsize] percentage
        positionLeftPanel = [.02 .02 .15 .94];
        ph = uipanel('parent', hMainFigure, 'title', 'Image selector',...
                     'position', positionLeftPanel);

        % Menus
        mainMenu = uimenu('label', 'File');
        openFile = uimenu(mainMenu, 'label', 'Load image(s)', ...
                          'callback', @openFileCallback);
        optionsContrast = uimenu('label', 'Contrast', ...
                          'callback', @contrast);

        % Axe
        position = [.17 .02 .81 .94];
        [width height] = getSizeOfAxe(position, sizeOfScreen);
        mainAxe = axes('parent', hMainFigure, 'visible', 'on', ...
                       'position', position);
        set(mainAxe, 'yticklabel', '', 'xticklabel', '');

        % variables visibles in the inner functions
        I = [];
        sizeOfStep = 35;
        a = 1;
        b = 1;
        section = [];
        imageLoaded = 0;
    else
        figure(hMainFigure);
    end %end of Singleton

    % -------------------------------------------------- Functions and callbacks

    % function to convert percentage to pixels 
    function [width height] = getSizeOfAxe(percentages, sizeOfScreen)
        sizeOfScreen = sizeOfScreen(3:4);
        sizeOfScreen = [sizeOfScreen sizeOfScreen];
        pixels = int16(percentages .* sizeOfScreen);
        width = pixels(3)-pixels(1);
        height = pixels(4)-pixels(2);
    end

    % open files and load images in the axes
    function openFileCallback(hObject, eventdata)
        [files path] = uigetfile({'*dcm'; '*.dicomdir'; '*.*'},...
                                'multiselect', 'on');
        if ~path
            return;
        elseif ~iscell(files)
            temp = files;
            files = cell(1);
            files{1} = temp;
        end
        % load and show the image in the main Axe
        pathfile = strcat(path, files{1});
        fileSelected = dicomread(pathfile);
        showImage(fileSelected);
        % load and show the images(s) in the left side
        showImagesInPanel(path, files);
    end % ending openFileCallback function

    function showImageSelected(hObject, eventdata, fileSelected)
        axes(mainAxe); % use the Axe selected
        showImage(fileSelected);
    end % ending selectImage function

    function showImagesInPanel(path, files)
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
            imagesc(fileToSelect, 'buttondownfcn', ...
                    {@showImageSelected, fileToSelect});
            axis off; axis image;
        end
    end % ending showImagesInPanel function
 
    function showImage(fileSelected)
        axes(mainAxe); % use the Axe selected
        I = reduceWorkArea(fileSelected);
        [h w] = size(I);
        I = f12to16bits(I);
        % I = adpmedian(I, 7);
        if height < h && width < w
            section = I(1:height, 1:width);
            imshow(section);
        else
            section = I(1:h, 1:w);
            imshow(section);
        end
        colormap bone;
        imageLoaded = 1;
    end % ending showImage function

    % function to catch keyboard events, is possible control the 
    % image with the movement keys
    function mainKeyPressFcn(hObject, eventdata)
        [limitH limitW] = size(I);
        if strcmp(eventdata.Key, '0')
            disp('más');
        elseif strcmp(eventdata.Key, 'hyphen')
            disp('menos');
        elseif strcmp(eventdata.Key, 'uparrow')
            if (a - sizeOfStep > 0)
                a = a - sizeOfStep;
            end
        elseif strcmp(eventdata.Key, 'downarrow')
            if (a + sizeOfStep + height < limitH)
                a = a + sizeOfStep;
            end
        elseif strcmp(eventdata.Key, 'leftarrow')
            if (b - sizeOfStep > 0)
                b = b - sizeOfStep;
            end
        elseif strcmp(eventdata.Key, 'rightarrow')
            if (b + sizeOfStep + width < limitW)
                b = b + sizeOfStep;
            end
        end

        contrastGUI = findobj('tag', 'contrast');
        %contrastGUIData = getappdata(contrastGUI);
        % contrastGUIData = getappdata(contrastGUI, 'childGUI');
        %disp(contrastGUIData.value);
        
        if imageLoaded
            % show section of image only if is loaded in the axe
            section = I(a:a + height, b:b + width);
            axes(mainAxe);
            imshow(section);
            colormap bone;
        end
    end

    function close(hObject, eventdata)
        % delete all the windows
        % check the CloseRequestFcn property
        delete(findobj(0,'type','figure'));
    end

end % ending main function
