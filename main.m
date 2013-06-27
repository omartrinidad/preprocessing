function varargout = main(varargin)
    % Description of GUI and main variables
    % h is a handle structure
    sizeScreen = get(0,'ScreenSize');
    h.figure = figure('Position', sizeScreen,...
           'Name', 'Preprocessing System of Mammograms',...
           'NumberTitle', 'off',...
           'MenuBar', 'none');

    % GUI Controls
    %eth = uicontrol(hmf, 'Style','edit',...
    %                'String','Enter your name here.',...
    %                'Position',[130 150 130 120]);

    % Menus
    h.mainMenu = uimenu('Label', 'File');
    openFile = uimenu(h.mainMenu, 'Label', 'Load image(s)');
    set(openFile, 'callback', {@openFileCallback, h});

    % Axe
    h.mainAxe = axes('Units', 'Pixels', 'Position', [20, 20, 1200, 600]);

% Callback functions
function h = openFileCallback(hObject, eventdata, h)
    disp('Testing Callbacks');
    %[file path] = uigetfile({'*dcm'; '*.dicomdir'; '*.*'});
