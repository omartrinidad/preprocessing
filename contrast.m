
function varargout = contrast(varargin)
    % This GUI contains controls to change the values of CLAHE function.
    hContrastFigure = findall(0, 'tag', 'contrast');
    hMainFigure = findall(0, 'tag', 'maingui');
    
    %Start Singleton
    if (isempty(hMainFigure))
        fprintf('This instance can not run whitout first execute the primary GUI');
        return;
    elseif (isempty(hContrastFigure))
        % calculate the size and position in the screen of the GUI
        sizeOfScreen = get(0,'ScreenSize');
        position = sizeOfScreen;
        x = position(3)/5;
        y = position(4)/5;
        position(1) = x;
        position(2) = y;
        position(3) = position(3) - x - x;
        position(4) = position(4) - y - y;

        hContrastFigure = figure('position', position, ... 
                               'name', 'Contrast options', ... %'resize', 'off', ...
                               'numbertitle', 'off', 'dockcontrols', 'off', ...
                               'tag', 'contrast', 'menubar', 'none'); 

        % contrast enhancement limit
        uicontrol(hContrastFigure, 'style', 'text', ...
                        'string', 'Contrast Enhancement Limit', ...
                        'units', 'normalized', ...
                        'position', [0.02 0.02 0.25 0.05]);

        uicontrol(hContrastFigure, 'style', 'slider', ...
                         'min', 0, 'max', 1, 'sliderstep', [0.05 0.01], ...
                         'callback', @celCallback, ...
                         'units', 'normalized', ...
                         'position', [0.28 0.02 0.60 0.05]);

        celval = uicontrol(hContrastFigure, 'style', 'text', ...
                            'string', '0.0', ...
                            'units', 'normalized', ...
                            'position', [0.89 0.02 0.09 0.05]);
        
        % Number of tiles by row
        uicontrol(hContrastFigure, 'style', 'text', ...
                        'string', 'Tiles by Row', ...
                        'units', 'normalized', ...
                        'position', [0.02 0.08 0.25 0.05]);

        uicontrol(hContrastFigure, 'style', 'slider', ...
                         'min', 0, 'max', 1, 'sliderstep', [0.05 0.01], ...
                         'callback', @tilesByRow, ...
                         'units', 'normalized', ...
                         'position', [0.28 0.08 0.60 0.05]);

        tbrowval = uicontrol(hContrastFigure, 'style', 'text', ...
                            'string', '0.0', ...
                            'units', 'normalized', ...
                            'position', [0.89 0.08 0.09 0.05]);
        
        contrastGUIData.value = 100;
        setappdata(hContrastFigure, 'childGUI', contrastGUIData);
    else
        figure(hContrastFigure);
    end %end of Singleton
   
    % --------------------- Functions and Callbacks -------------------------

    function celCallback(hObject, eventdata)
        value = get(hObject, 'value');
        set(celval, 'string', value);
    end

    function tilesByRow(hObject, eventdata)
        value = get(hObject, 'value');
        set(tbrowval, 'string', value);
    end

end 

