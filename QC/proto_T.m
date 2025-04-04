function Annealing

% Annealing reads seismological records in format SAC stored inside an event database
% It performs clustering of the records and performs a simulated annealing
% in order to measure precisely differential and absolute travel times
% For more details on the simulated algorithm see Chevrot (2002)

% SCREEN DEFINITION

set(0, 'Units', 'pixels');
screen = get(0, 'ScreenSize');

% CREATE FIGURE
Anneal_fig = figure('position',[50,50,screen(3)-100,screen(4)-150], ...
    'numbertitle','off', ...
    'menubar','none', ...
    'HandleVisibility','callback', ...
    'name','Annealing 1.0');
hObject = Anneal_fig;

% CREATION OF THE GUI DATA STRUCTURE
data = guihandles(Anneal_fig);

data.NbDisp = 10;

% CREATE MENUS
menu1 = uimenu(Anneal_fig,'Label','QC_MAT');
uimenu(menu1,'Label','Preferences', ...
    'Callback', @Preferences_Callback);
uimenu(menu1,'Label','Quit', ...
    'Callback','quit');

menu2 = uimenu(Anneal_fig,'Label','File');
uimenu(menu2, ...
    'Label','Read Data', ...
    'Tag','open', ...
    'Callback', @Open_Callback);
uimenu(menu2, ...
    'Label','Save Results', ...
    'Tag','save', ...
    'Callback', @Save_Results_Callback);

menu3 = uimenu(Anneal_fig,'Label','Data Analysis');
uimenu(menu3, ...
    'Label','Align Traces', ...
    'Tag','Align Traces', ...
    'Callback', @Align_Traces_Callback);
uimenu(menu3, ...
    'Label','Polarisation', ...
    'Tag','pol', ...
    'Callback', @Polarisation_Callback);

% CREATE AXES1 (DATA PLOT)
axes1 = axes( 'Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes1', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.05 0.05 0.2 0.6]);

text1 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text1', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'String', 'Residuals', ...
    'Enable', 'On', ...
    'String', 'Event :', ...
    'HandleVisibility', 'On', ...
    'Position', [0.4 0.95 0.4 0.032], ...
    'Visible', 'Off');
text1b = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text1b', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'String', 'Residuals', ...
    'Enable', 'On', ...
    'String', 'Event :', ...
    'HandleVisibility', 'On', ...
    'Position', [0.38 0.95 0.07 0.032], ...
    'Visible', 'Off');

pushbutton1 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton1', ...
    'Callback', @pushbutton1_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.135 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton2 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton2', ...
    'Callback', @pushbutton2_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.18 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton3 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton3', ...
    'Callback', @pushbutton3_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.09 0.68 0.03 0.04], ...
    'Visible', 'On');

radiobutton5 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton5', ...
    'String', 'Align', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Enable', 'Off', ...
    'Callback', @chooseComponentAlign1_Callback, ...
    'Position', [0.05 0.68 0.04 0.04]);

% CREATE AXES2 (TIME RESIDUALS MAP)
axes2 = axes('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes2', ...
    'Box', 'on', ...
    'ButtonDownFcn', @axes2_ButtonDownFcn, ...
    'HandleVisibility','callback', ...
    'Position',[0.75 0.5 0.21 0.35]);

% CREATE AXES3 (TIME RESIDUALS LEGEND)
axes3 = axes( 'Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes3', ...
    'Xtick', [], ...
    'Ytick', [], ...
    'Box', 'on', ...
    'HandleVisibility','callback', ...
    'Position',[0.75 0.87 0.21 0.025]);
text13 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text13', ...
    'HorizontalAlignment', 'center', ...
    'String', 'Time Residuals', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.81 0.9 0.1 0.025], ...
    'Visible', 'On');



% CREATE AXES4 (Radial Components)
axes4 = axes('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes4', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.28 0.05 0.2 0.6]);

pushbutton4 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton4', ...
    'Callback', @pushbutton4_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.365 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton5 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton5', ...
    'Callback', @pushbutton5_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.41 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton6 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton6', ...
    'Callback', @pushbutton6_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.32 0.68 0.03 0.04], ...
    'Visible', 'On');
radiobutton6 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton6', ...
    'String', 'Align', ...
    'Value', 0, ...
    'Interruptible', 'On', ...
    'Enable', 'Off', ...
    'Callback', @chooseComponentAlign2_Callback, ...
    'Position', [0.28 0.68 0.04 0.04]);

% CREATE AXES5 (AMPLITUDE RESIDUALS MAP)
axes5 = axes('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes5', ...
    'Box', 'on', ...
    'ButtonDownFcn', @axes5_ButtonDownFcn, ...
    'HandleVisibility','callback', ...
    'Position',[0.75 0.05 0.21 0.35]);

% CREATE AXES6 (AMPLITUDE RESIDUALS LEGEND)
axes6 = axes( 'Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes6', ...
    'Xtick', [], ...
    'Ytick', [], ...
    'Box', 'on', ...
    'HandleVisibility','callback', ...
    'Position',[0.75 0.415 0.21 0.025]);
text14 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text14', ...
    'HorizontalAlignment', 'center', ...
    'String', 'Amplitude Residuals', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.81 0.445 0.1 0.025], ...
    'Visible', 'On');


% CREATE AXES7 (Transverse Component)
axes7 = axes('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes7', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.51 0.05 0.2 0.6]);

pushbutton7 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton7', ...
    'Callback', @pushbutton7_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.595 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton8 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton8', ...
    'Callback', @pushbutton8_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.64 0.68 0.03 0.04], ...
    'Visible', 'On');
pushbutton9 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton9', ...
    'Callback', @pushbutton9_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.55 0.68 0.03 0.04], ...
    'Visible', 'On');
radiobutton7 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton7', ...
    'String', 'Align', ...
    'Value', 0, ...
    'Interruptible', 'On', ...
    'Enable', 'Off', ...
    'Callback', @chooseComponentAlign3_Callback, ...
    'Position', [0.51 0.68 0.04 0.04]);


% Create event map
axes_map = axes( 'Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axes4', ...
    'Xtick', [], ...
    'Ytick', [], ...
    'Box', 'on', ...
    'HandleVisibility','callback', ...
    'Visible', 'off',...
    'Position',[0.39 0.74 0.20 0.22]);


% Create focal
axes_focal = axes('Parent', Anneal_fig,...
    'Position',[0.59 0.78 0.14 0.14],...
    'Box','on',...
    'Visible','off');




% CREATE UIPANEL PARAMETERS
hPanel = uipanel(Anneal_fig, ...
    'Title', 'Parameters', ...
    'Position', [0.05 0.73 0.3 0.26]);


text3 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text3', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.075 0.86 0.2 0.11], ...
    'Visible', 'On');
popupmenu1 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'PopUpMenu', ...
    'String', 'P', ...
    'Tag', 'popupmenu1', ...
    'HitTest', 'On', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.2 0.86 0.175 0.11], ...
    'Visible', 'On');
text4 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text4', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Dist. min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.4 0.89 0.2 0.11], ...
    'Visible', 'On');
text5 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text5', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Dist. Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.6 0.89 0.2 0.11], ...
    'Visible', 'On');
text19 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text19', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Dist. Mean', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.89 0.2 0.11], ...
    'Visible', 'On');

text17 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text17', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Baz. min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.4 0.83 0.2 0.11], ...
    'Visible', 'On');
text18 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text18', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Baz. Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.6 0.83 0.2 0.11], ...
    'Visible', 'On');
text20 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text20', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Baz. Mean', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.83 0.2 0.11], ...
    'Visible', 'On');
text21 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text21', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Slowness', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.75 0.77 0.25 0.11], ...
    'Visible', 'off');

radiobutton1 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton1', ...
    'String', 'Data Time Window', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.77 0.3 0.11]);
text6 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text6', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Before Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.125 0.66 0.2 0.11], ...
    'Visible', 'On');
edit1 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit1', ...
    'HorizontalAlignment', 'center', ...
    'String', '60', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.325 0.68 0.1 0.1], ...
    'Visible', 'On');
text7 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text7', ...
    'HorizontalAlignment', 'left', ...
    'String', 'After Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.475 0.66 0.2 0.11], ...
    'Visible', 'On');
edit2 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit2', ...
    'HorizontalAlignment', 'center', ...
    'String', '80', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.625 0.68 0.1 0.1], ...
    'Visible', 'On');

radiobutton2 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton2', ...
    'String', 'Butterworth Filter for Data', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.37 0.4 0.11]);
text8 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text8', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Frequency min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.125 0.26 0.2 0.11], ...
    'Visible', 'On');
edit3 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit3', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.04', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.325 0.28 0.1 0.1], ...
    'Visible', 'On');
text9 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text9', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq. max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.475 0.26 0.2 0.11], ...
    'Visible', 'On');
edit4 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit4', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.1', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.625 0.28 0.1 0.1], ...
    'Visible', 'On');
refilt_button = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Callback', @refilt_button_Callback, ...    
    'Style', 'pushbutton', ...
    'Tag', 'refilt_button', ...
    'String', 'Refilter', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.85 0.27 0.1 0.11]);


%%%%%%%%%%%55
% radiobutton4 = uicontrol('Parent', hPanel, ...
%     'Units', 'normalized', ...
%     'Style', 'Radio', ...
%     'Tag', 'radiobutton4', ...
%     'String', 'Clustering', ...
%     'HitTest', 'On', ...
%     'Enable', 'On', ...
%     'Value', 1, ...
%     'Interruptible', 'On', ...
%     'Position', [0.05 0.17 0.2 0.11]);
% text22 = uicontrol('Parent', hPanel, ...
%     'Units', 'normalized', ...
%     'Style', 'text', ...
%     'Tag', 'text22', ...
%     'HorizontalAlignment', 'left', ...
%     'String', 'Clustering', ...
%     'Enable', 'On', ...
%     'HandleVisibility', 'On', ...
%     'Position', [0.1 0.15 0.2 0.11], ...
%     'Visible', 'On');
% text11 = uicontrol('Parent', hPanel, ...
%     'Units', 'normalized', ...
%     'Style', 'text', ...
%     'Tag', 'text11', ...
%     'HorizontalAlignment', 'left', ...
%     'String', 'Min Correlation', ...
%     'Enable', 'On', ...
%     'HandleVisibility', 'On', ...
%     'Position', [0.125 0.06 0.2 0.11], ...
%     'Visible', 'On');
% edit6 = uicontrol('Parent', hPanel, ...
%     'Units', 'normalized', ...
%     'Style', 'edit', ...
%     'Tag', 'edit6', ...
%     'HorizontalAlignment', 'center', ...
%     'String', '0.65', ...
%     'Enable', 'On', ...
%     'HandleVisibility', 'On', ...
%     'Position', [0.325 0.08 0.1 0.1], ...
%     'Visible', 'On');

text15 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text15', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Beginning Time', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.125 0.46 0.3 0.11], ...
    'Visible', 'On');
edit7 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit7', ...
    'HorizontalAlignment', 'center', ...
    'String', '25', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.325 0.48 0.1 0.1], ...
    'Visible', 'On');
text16 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text16', ...
    'HorizontalAlignment', 'left', ...
    'String', 'End Time', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.475 0.46 0.3 0.11], ...
    'Visible', 'On');
edit8 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit8', ...
    'HorizontalAlignment', 'center', ...
    'String', '40', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.625 0.48 0.1 0.1], ...
    'Visible', 'On');

radiobutton4 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton4', ...
    'String', 'Parameters for Deconvolution', ...
    'HitTest', 'On', ...
    'Enable', 'Off', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.17 0.4 0.11]);
text25 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text25', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Time Before Phase', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.06 0.2 0.11], ...
    'Visible', 'On');
edit9 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit69', ...
    'HorizontalAlignment', 'center', ...
    'String', '20', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.275 0.08 0.1 0.1], ...
    'Visible', 'On');
text24 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text24', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Time After Phase', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.4 0.06 0.2 0.11], ...
    'Visible', 'On');
edit5 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit5', ...
    'HorizontalAlignment', 'center', ...
    'String', '130', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ... 
    'Position', [0.6 0.08 0.1 0.1], ...
    'Visible', 'On');
text25 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text25', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Water Level', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ...
    'Position', [0.725 0.06 0.2 0.11], ...
    'Visible', 'On');
edit6 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit6', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.01', ...
    'Enable', 'Off', ...
    'HandleVisibility', 'On', ... 
    'Position', [0.875 0.08 0.1 0.1], ...
    'Visible', 'On');

radiobuttonZNE = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobuttonZNE', ...
    'String', 'ZNE', ...
    'Value', 0, ...
    'Interruptible', 'On', ...
    'Enable', 'Off', ...
    'Callback', @radiobuttonZNE_Callback, ...
    'Position', [0.85 0.65 0.1 0.08]);

radiobuttonZRT = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobuttonZRT', ...
    'String', 'ZRT', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Callback', @radiobuttonZRT_Callback, ...
    'Position', [0.85 0.75 0.1 0.08]);


radiobuttonPlotOnMain = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobuttonPlotOnMain', ...
    'String', 'Plot here', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Callback', @radiobuttonPlotOnMain_Callback, ...
    'Position', [0.87 0.93 0.06 0.08]);


radiobuttonPlotOutside = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobuttonPlotOutside', ...
    'String', 'Plot outside', ...
    'Value', 0, ...
    'Interruptible', 'On', ...
    'Callback', @radiobuttonPlotOutside_Callback, ...
    'Position', [0.92 0.93 0.05 0.08]);


% CREATE POPUPMENU CLUSTERS
listbox1 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'String', '1', ...
    'Style', 'listbox', ...
    'Tag', 'listbox1', ...
    'Position', [0.93 0.775 0.04 0.125], ...
    'Visible', 'Off');
text12 = uicontrol('Parent', Anneal_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text12', ...
    'HorizontalAlignment', 'center', ...
    'String', 'Cluster', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.925 0.91 0.05 0.025], ...
    'Visible', 'Off');


%pushbutton11 = uicontrol('Parent', Anneal_fig, ...
%    'Units', 'normalized', ...
%    'Style', 'pushbutton', ...
%    'Tag', 'pushbutton11', ...
%    'Callback', @pushbutton11_Callback, ...
%    'HorizontalAlignment', 'center', ...
%    'String', 'Plot Stations', ...
%    'Enable', 'On', ...
%    'HandleVisibility', 'On', ...
%    'Position', [0.89 0.81 0.1 0.04], ...
%    'Visible', 'On');

%pushbutton12 = uicontrol('Parent', Anneal_fig, ...
%    'Units', 'normalized', ...
%    'Style', 'pushbutton', ...
%    'Tag', 'pushbutton12', ...
%    'Callback', @pushbutton12_Callback, ...
%    'HorizontalAlignment', 'center', ...
%    'String', 'ZNE / ZRT Analysis', ...
%    'Enable', 'On', ...
%    'HandleVisibility', 'On', ...
%    'Position', [0.89 0.735 0.1 0.04], ...
%    'Visible', 'On');

%pushbutton13 = uicontrol('Parent', Anneal_fig, ...
%    'Units', 'normalized', ...
%    'Style', 'pushbutton', ...
%    'Tag', 'pushbutton13', ...
%    'Callback', @pushbutton13_Callback, ...
%    'HorizontalAlignment', 'center', ...
%    'String', 'Axisem - Specfem', ...
%    'Enable', 'On', ...
%    'HandleVisibility', 'On', ...
%    'Position', [0.89 0.665 0.1 0.04], ...
%    'Visible', 'On');


data_initialize;

% for debugging to check the number of objects in figure
%numel(findobj(Anneal_fig))
function ui_initialize
    try 
        data = guidata(Anneal_fig);

        Ntraces = data.Ntraces;      
        delete(data.rb);
        delete(data.rb2);
        delete(data.rb3);

        delete(data.DispTraceZ);
        delete(data.DispTraceR);
        delete(data.DispTraceT);
        
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,data.Ntraces);
        data.NminR = 1;
        data.NmaxR = min(data.NbDisp,data.Ntraces);
        data.NminT = 1;
        data.NmaxT = min(data.NbDisp,data.Ntraces);

        axes(axes_focal);cla; 
        axes(axes1);cla;
        axes(axes2);cla;
        axes(axes3);cla;
        axes(axes4);cla;
        axes(axes5);cla;
        axes(axes6);cla;        
        axes(axes7);cla;

    catch
        return
    end
end

function data_initialize
    clear data

    % DEFINITION OF VARIABLES
    data.clust = 0;
    data.NstaBlack = 0;
    data.run_annealing = '/Users/chevrot/Programmes/AnealingWfV0.2'; % annealing code
%    data.Data_Dir = '/Users/leokan/GoogleDrive/00_doctorale/cascadia/P_phase.modified';  % default data directory
    data.Data_Dir = '/Users/leokan/P_phase_cas/1';  % default data directory

    % To be customized later
    data.NbDisp = 10;
    data.Align = 0;
    data.tshiftmax = 1;
    data.selected_comp = 1;
    data.need_rotate = 1;

    AllPhases = {'P';'PP';'PKP';'PKIKP';'Pdiff';'S'};
    set(popupmenu1,'String',AllPhases);

    guidata(Anneal_fig,data)
end

% --------------------------------------------------------------------
% --- Load Real Data
function Open_Callback(object,event)
    
ui_initialize;
data_initialize;

data = guidata(Anneal_fig);

data.Align = 0;
       
% GET CHOSEN PHASE
Phases = get(popupmenu1,'String');
ii = get(popupmenu1,'Value');
Phase = Phases{ii};
        
% CHOOSE SAC FILE DIRECTORY
data.DirSac = uigetdir(data.Data_Dir);

% user pressed cancel
if data.DirSac==0
  return
end

% go on with saving your data ...

% READ SAC FILES
SacTag = 'Z.sac'; % extension of files to be read
[StrcOut,d0,d1,baz0,baz1,distance,t0,t1,I,SacFilesZ] = ReadAllSacFile(data.DirSac,SacTag);
data.SigInZ = StrcOut;

SacTag = 'R.sac'; % extension of files to be read
[StrcOut,d0,d1,baz0,baz1,distance,t0,t1,I,SacFilesN] = ReadAllSacFile(data.DirSac,SacTag);
data.SigInN = StrcOut;

SacTag = 'T.sac'; % extension of files to be read
[StrcOut,d0,d1,baz0,baz1,distance,t0,t1,I,SacFilesE] = ReadAllSacFile(data.DirSac,SacTag);
data.SigInE = StrcOut;

SacTag = 'R.sac'; % extension of files to be read
[StrcOut,d0,d1,baz0,baz1,distance,t0,t1,I,SacFilesR] = ReadAllSacFile(data.DirSac,SacTag);
data.SigInR = StrcOut;

SacTag = 'T.sac'; % extension of files to be read
[StrcOut,d0,d1,baz0,baz1,distance,t0,t1,I,SacFilesT] = ReadAllSacFile(data.DirSac,SacTag);
data.SigInT = StrcOut;

data.SacFilesZ = SacFilesZ;
data.SacFilesN = SacFilesN;
data.SacFilesE = SacFilesE;
data.SacFilesR = SacFilesR;
data.SacFilesT = SacFilesT;
data.distmin = d0;
data.distmax = d1;
data.bazmin = baz0;
data.bazmax = baz1;
data.distance = distance;
data.I = I;

Longitude = [];
Latitude = [];
        
for k = 1:length(StrcOut)
   Longitude = [Longitude ; data.SigInZ(k).HdrData.STLO];
   Latitude = [Latitude ; data.SigInZ(k).HdrData.STLA];
end

data.lonmin = min(Longitude);
data.lonmax = max(Longitude);
data.latmin = min(Latitude);
data.latmax = max(Latitude);
        
distmin = sprintf('Dist Min: %4.1f',d0);
distmax = sprintf('Dist Max: %4.1f',d1);
distmean = sprintf('Dist Mean: %4.1f',(d0+d1)/2);
        
bazmin = sprintf('Baz Min: %4.1f',baz0);
bazmax = sprintf('Baz Max: %4.1f',baz1);
bazmean = sprintf('Baz Mean: %4.1f',(baz0+baz1)/2);
%smean = sprintf('Slowness: %4.4f', smean);
        
evlat = num2str(data.SigInZ(1).HdrData.EVLA);
evlon = num2str(data.SigInZ(1).HdrData.EVLO);
evdep = num2str(data.SigInZ(1).HdrData.EVDP);
evdate = strcat(num2str(data.SigInZ(1).HdrData.NZJDAY),'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
data.evdate = strcat(num2str(data.SigInZ(1).HdrData.NZJDAY),'_',num2str(data.SigInZ(1).HdrData.NZYEAR));
data.mag = num2str(data.SigInZ(1).HdrData.MAG);
        
DateString = {num2str(data.SigInZ(1).HdrData.NZJDAY)};
%t = cellstr(datetime(DateString,'InputFormat','D','Format','MM/dd'));
t = cellstr(datetime(DateString,'InputFormat','D','Format','dd/MM','Timezone','UTC'));
t = strcat(t,'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
data.t = t{1};
        
guidata(Anneal_fig,data);
        
set(text1,'Visible','On');
set(text1b,'Visible','On');
str1 = ['Latitude : ' evlat char(176) '  Longitude : ' evlon char(176) '  Depth : ' evdep ' km' ' Mag : ' data.mag];
%         str1b = ['Date : ' evdate];
str1b = ['Date : ' t{1}];
set(text1,'string',str1);
set(text1b,'string',str1b);
      
set(text4,'string',strcat(distmin,char(176)));
set(text5,'string',strcat(distmax,char(176)));
set(text19,'string',strcat(distmean,char(176)));
set(text17,'string',strcat(bazmin,char(176)));
set(text18,'string',strcat(bazmax,char(176)));
set(text20,'string',strcat(bazmean,char(176)));
%set(text21,'string',strcat(smean,' s/',char(176)));
        
% CHOOSE PHASE
phases = Phase;
        
% PHASES FOR DIST MIN
tt0 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d0);
        
% PHASES FOR DIST MAX
tt1 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d1);

k = 0;
for i = 1:size(tt0,2)
  if tt0(i).time > t0 && tt0(i).time < t1
    k = k+1;
    PhasesForDistMin{k} = tt0(i).phase;
  end
end
        
k = 0;
for i = 1:size(tt1,2)
  if tt1(i).time > t0 && tt1(i).time < t1
    k = k+1;
    PhasesForDistMax{k} = tt1(i).phase;
  end
end
        
% INTERSECTION
k = 0;
for i = 1:size(PhasesForDistMin,2)
  for j = 1:size(PhasesForDistMax,2)
    if strcmp(PhasesForDistMin{i},PhasesForDistMax{j}) == 1
      k = k+1;
      PhasesPot{k} = PhasesForDistMax{j};
    end
  end
end
        
% SELECT PHASE
[Sel_Phase,ok] = listdlg('PromptString','Choose Phase', ...
   'SelectionMode','single','ListString',PhasesPot);
        
% DEFAULT PHASE IS THE FIRST ONE
if ok ~= 1
  Sel_Phase = 1;
end
        
% SET SELECTABLE PHASES IN MENU
set(popupmenu1,'String',PhasesPot);
set(popupmenu1,'Value',Sel_Phase);

preprocess_trace;

guidata(Anneal_fig,data)
        
data.Align = 0;
data.deconvolution = zeros(100,1);
data.convolution = zeros(100,1);
data.SelectionZ(1:data.Ntraces) = 1;
data.SelectionR(1:data.Ntraces) = 1;
data.SelectionT(1:data.Ntraces) = 1;
axes(axes1); cla; hold off;
%axes(axes2); cla; hold off;
axes(axes3); cla; hold off;
set(listbox1,'String','1','Value',1);
        
% STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
data.NminZ = 1;
data.NmaxZ = min(data.NbDisp,data.Ntraces);
data.NminR = 1;
data.NmaxR = min(data.NbDisp,data.Ntraces);
data.NminT = 1;
data.NmaxT = min(data.NbDisp,data.Ntraces);


% Enable pushbuttons
set(pushbutton1,'Enable','on')
set(pushbutton2,'Enable','on')
set(pushbutton3,'Enable','on')
set(pushbutton4,'Enable','on')
set(pushbutton5,'Enable','on')
set(pushbutton6,'Enable','on')
set(pushbutton7,'Enable','on')
set(pushbutton8,'Enable','on')
set(pushbutton9,'Enable','on')
set(radiobutton5,'Enable','on')
set(radiobutton6,'Enable','on')
set(radiobutton7,'Enable','on')


% CHOOSE AXE5
guidata(Anneal_fig,data)
DisplayMap;

% CHOOSE panel_focal
guidata(Anneal_fig,data)

%DisplayFocal;

% CHOOSE AXES1
%axes(axes1);cla;hold on
        
guidata(Anneal_fig,data)
        
DisplayTraces;
        
guidata(Anneal_fig,data)

% CHOOSE AXIS4
%axes(axes4); cla; hold on

DisplayRadial;

% Choose axis7
DisplayTransverse;

guidata(Anneal_fig,data)



end
    function preprocess_trace(hObject, eventdata)

    data = guidata(Anneal_fig);

    data.Ntraces = size(data.SigInZ,2);

    Tmin = str2double(get(edit1,'String'));
    Tmax = str2double(get(edit2,'String'));
    FrqMin = str2double(get(edit3,'String'));
    FrqMax = str2double(get(edit4,'String'));
    % ReSamp = str2double(get(edit5,'String'));

    Window = get(radiobutton1,'Value');
    Filter = get(radiobutton2,'Value');
    % Resampling = get(radiobutton3,'Value');

    Phases = get(popupmenu1,'String');
    ii = get(popupmenu1,'Value');
    data.Phase = Phases{ii};

    %  ----
    h = waitbar(0,'Filtering');
    data.SigZ = [];
    data.SigR = [];
    data.SigT = [];

    guidata(Anneal_fig,data)

    % NUMBER OF SAMPLES IN TIME WINDOW
    if Window == 1
      NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInZ(1).HdrData.DELTA);
    else
      NsamplesTot = length(data.SigInZ(1).SeisData);
    end

    % INITIALIZE TRACE COUNTER
    ii = 0;

    for itrace = 1:data.Ntraces
      waitbar(itrace/data.Ntraces);

      % COPY DATA
      data.SigFlZ(itrace).HdrData = data.SigInZ(itrace).HdrData;
      data.SigFlR(itrace).HdrData = data.SigInR(itrace).HdrData;
      data.SigFlT(itrace).HdrData = data.SigInT(itrace).HdrData;

      % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
      deltat = data.SigInZ(itrace).HdrData.DELTA;
      Time = 0:deltat:(length(data.SigInZ(itrace).SeisData)-1)*data.SigInZ(itrace).HdrData.DELTA;
      Time = Time+data.SigInZ(itrace).HdrData.B-data.SigInZ(itrace).HdrData.O;

                %   if Resampling == 1;
                %     % reecrire : handles.SigIn(itrace).SeisData,
                %     % handles.SigIn(itrace).DELTA
                %     % handles.SigIn(itrace).DELTA.NPTS
                %   end

      if Window == 1

        % COMPUTE THEORETICAL TRAVEL TIMES
        tt = tauptime('mod','ak135','dep',data.SigInZ(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInZ(itrace).HdrData.GCARC);

        if isempty(tt) == 0 % the phase exists

          ii = ii+1;
          Ptheo = tt(1).time;
          data.slowness(ii) = tt.rayparameter;
          data.SigFlZ(itrace).HdrData.A = Ptheo;
          data.SigInZ(itrace).HdrData.A = Ptheo;

          TempsMin = Ptheo-Tmin;
          TempsMax = Ptheo+Tmax;

          i0 = find(Time<TempsMin,1,'last');

          if isempty(i0) == 1
            i0 = 1;
            ndeb = floor((Time(1)-TempsMin)/deltat)+2;
            Tdeb = Time(1)-floor((Time(1)-TempsMin)/deltat+1)*deltat;
            i1 = NsamplesTot-ndeb+1;
            nfin = NsamplesTot;
          else
            ndeb = 1;
            nfin = NsamplesTot;
            Tdeb = Time(i0);
            i1 = i0+NsamplesTot-1;
          end

          SigWin = zeros(NsamplesTot,1);
          data.SigZFl(ii).HdrData.B = Tdeb;
          data.SigRFl(ii).HdrData.B = Tdeb;
          data.SigTFl(ii).HdrData.B = Tdeb;
          data.i0 = i0;
          data.i1 = i1;

          if Filter == 1 % use band pass filter
            Fdata0 = filtbuth_hp(FrqMin,4,deltat,data.SigInZ(itrace).SeisData');
            Fdata1 = filtbuth_lp(FrqMax,4,deltat,Fdata0);
            data.SigInFlZ(ii).SeisData = Fdata1';
            data.SigFlZ(ii).SeisData = Fdata1(i0:i1)';

            Fdata0 = filtbuth_hp(FrqMin,4,deltat,data.SigInR(itrace).SeisData');
            Fdata1 = filtbuth_lp(FrqMax,4,deltat,Fdata0);
            data.SigInFlR(ii).SeisData = Fdata1';
            data.SigFlR(ii).SeisData = Fdata1(i0:i1)';

            Fdata0 = filtbuth_hp(FrqMin,4,deltat,data.SigInT(itrace).SeisData');
            Fdata1 = filtbuth_lp(FrqMax,4,deltat,Fdata0);
            data.SigInFlT(ii).SeisData = Fdata1';
            data.SigFlT(ii).SeisData = Fdata1(i0:i1)';

          else % wwssn filter
            Fdata0 = data.SigInZ(itrace).SeisData-mean(data.SigInZ(itrace).SeisData(i0:i1));
            Fdata1 = wwssn_sp(Fdata0');
            data.SigInFlZ(itrace).SeisData = Fdata1';
            data.SigFlZ(itrace).SeisData = Fdata1(i0:i1)';

            Fdata0 = data.SigInR(itrace).SeisData-mean(data.SigInR(itrace).SeisData(i0:i1));
            Fdata1 = wwssn_sp(Fdata0');
            data.SigInFlR(itrace).SeisData = Fdata1';
            data.SigFlR(itrace).SeisData = Fdata1(i0:i1)';

            Fdata0 = data.SigInT(itrace).SeisData-mean(data.SigInT(itrace).SeisData(i0:i1));
            Fdata1 = wwssn_sp(Fdata0');
            data.SigInFlT(itrace).SeisData = Fdata1';
            data.SigFlT(itrace).SeisData = Fdata1(i0:i1)';
          end

          if length(data.SigFlZ(itrace).SeisData) == 0
            data.SigFlZ(itrace).SeisData = zeros(1,size(data.Sig,1));
            data.SigFlR(itrace).SeisData = zeros(1,size(data.Sig,1));
            data.SigFlT(itrace).SeisData = zeros(1,size(data.Sig,1));

          end
          data.SigZ = [data.SigZ,data.SigFlZ(itrace).SeisData'];
          data.SigR = [data.SigR,data.SigFlR(itrace).SeisData'];
          data.SigT = [data.SigT,data.SigFlT(itrace).SeisData'];

        else

          %[NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
          data.SigZ = [data.SigZ, zeros(NsamplesTot,1)];
          data.SigR = [data.SigR, zeros(NsamplesTot,1)];
          data.SigT = [data.SigT, zeros(NsamplesTot,1)];

        end
      else % dont compute theorical travel time
        ii = ii+1;
        data.SigFlZ(itrace).SeisData = data.SigInZ(itrace).SeisData;
        data.SigFlR(itrace).SeisData = data.SigInR(itrace).SeisData;
        data.SigFlT(itrace).SeisData = data.SigInT(itrace).SeisData;
        i0 = 1;
        i1 = length(data.SigInZ(itrace).SeisData);
      end

    end

    data.Ntraces = ii;
    close(h)
    end
% --------------------------------------------------------------------
    function Preferences_Callback(hObject, eventdata)
        
        data = guidata(Anneal_fig);
        
        A = load('anneali.par');
        
        for i = 1:length(A)
            B{i} = num2str(A(i));
        end
        
        prompt = {'Enter number of loops:','Enter number of steps:','Enter alpha'};
        dlg_title = 'Input for annnealing';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines,B);
        
        for i = 1:length(A)
            A(i) = str2num(answer{i});
        end
        
        fid = fopen('anneali.par','w');
        fprintf(fid,'%10.0f\n',A(1))
        fprintf(fid,'%10.0f\n',A(2))
        fprintf(fid,'%20.10f\n',A(3))
        fclose(fid)
        
    end

% --- Executes on button press in pushbutton1
% --- Display 10 First Real Traces
    function pushbutton1_Callback(hObject, eventdata)
        %         display first 10 traces in cluster

        data = guidata(Anneal_fig);
        set(pushbutton2,'Enable','off')
        set(pushbutton3,'Enable','off')

        % disable rb from previous display
        if data.Align == 1 % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rb(ii),'Visible','off');
            end
        end
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,data.Ntraces);

        % CHOOSE AXES1
        %axes(axes1);cla;hold on
        
        guidata(Anneal_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayTraces;
        
        guidata(Anneal_fig,data)
        
        set(pushbutton2,'Enable','on')
        set(pushbutton3,'Enable','on')
    end

% --- Executes on button press in pushbutton2
% --- Display 10 Next Vertical Traces
    function pushbutton2_Callback(hObject, eventdata)
        %     display next traces
        
        set(pushbutton1,'Enable','off')
        set(pushbutton3,'Enable','off')

        data = guidata(Anneal_fig);

        % RETURN IF NO TRACE TO DISPLAY
        if (data.NmaxZ >= data.Ntraces)
            set(pushbutton1,'Enable','on')
            set(pushbutton3,'Enable','on')
            return
        end
        
        if data.Align == 1 % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rb(ii),'Visible','off');
            end
        end
        
        % RETURN IF NO TRACE TO DISPLAY
        %if (data.NmaxZ >= data.Ntraces) ; return; end
        
        % FIRST TRACE TO DISPLAY
        n1 = min(data.NmaxZ+1,data.Ntraces);
        
        % LAST TRACE TO DISPLAY
        n2 = min(data.NmaxZ+data.NbDisp,data.Ntraces);

        % STORE IN GLOBAL VARIABLE
        data.NminZ = n1;
        data.NmaxZ = n2;

        % CHOOSE AXES
        %axes(axes1);cla;hold on
        
        guidata(Anneal_fig,data)

        % DISPLAY 10 TRACES
        DisplayTraces;
        
        guidata(Anneal_fig,data)
        
        set(pushbutton1,'Enable','on')
        set(pushbutton3,'Enable','on')
    end

% --- Executes on button press in pushbutton3
% --- Display 10 Previous Vertical Traces
    function pushbutton3_Callback(hObject, eventdata)
        %     display previous traces
        set(pushbutton1,'Enable','off')
        set(pushbutton2,'Enable','off')

        data = guidata(Anneal_fig);
        
        % RETURN IF NO TRACE TO DISPLAY
        if (data.NminZ <= 1) 
            set(pushbutton1,'Enable','on')
            set(pushbutton2,'Enable','on')
            return 
        end
        
        if data.Align == 1 % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rb(ii),'Visible','off');
            end
        end
        
        % FIRST TRACE TO DISPLAY
        n1 = max(data.NminZ-data.NbDisp,1);
        
        % LAST TRACE TO DISPLAY
        n2 = max(data.NminZ-1,1);
        
        % STORE IN GLOBAL VARIABLE
        data.NminZ = n1;
        data.NmaxZ = n2;
        
        % CHOOSE AXES
        %axes(axes1);cla;hold on
        
        guidata(Anneal_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayTraces;
        
        guidata(Anneal_fig,data);
        
        set(pushbutton1,'Enable','on')
        set(pushbutton2,'Enable','on')
    end

% --- Executes on button press in pushbutton4
% --- Display 10 First Radial Traces
    function pushbutton4_Callback(hObject, eventdata)
        %         display first 10 traces in cluster
        
        data = guidata(Anneal_fig);
        
        % disable rb from previous display
        if data.Align == 1 % annealing runned
            for ii = data.NminR:data.NmaxR
                set(data.rb2(ii),'Visible','off');
            end
        end
    
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminR = 1;
        data.NmaxR = min(data.NbDisp,data.Ntraces);
        
        
        % CHOOSE AXES4
%        axes(axes4);cla;hold on
        
        guidata(Anneal_fig,data);
        
        % DISPLAY 10 TRACES
        DisplayRadial;
        
        guidata(Anneal_fig,data);
        
    end
% --- Executes on button press in pushbutton5
% --- Display 10 Next Radial Traces
    function pushbutton5_Callback(hObject, eventdata)
        %     display next traces
        
        data = guidata(Anneal_fig);
        
        % RETURN IF NO TRACE TO DISPLAY
        if (data.NmaxR >= data.Ntraces) ; return; end
        
        if data.Align == 1; % annealing runned
       %     [data.NminR data.NmaxR data.Ntraces]
            for ii = data.NminR:data.NmaxR
                set(data.rb2(ii),'Visible','off');
            end
        end
        % FIRST TRACE TO DISPLAY
        n1 = min(data.NmaxR+1,data.Ntraces);
        
        % LAST TRACE TO DISPLAY
        n2 = min(data.NmaxR+data.NbDisp,data.Ntraces);
        
        % STORE IN GLOBAL VARIABLE
        data.NminR = n1;
        data.NmaxR = n2;
        
%        guidata(Anneal_fig,data)
        
        % CHOOSE AXES
%        axes(axes4);cla;hold on
        
        guidata(Anneal_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayRadial;
        
        guidata(Anneal_fig,data)
        
    end

% --- Executes on button press in pushbutton6
% --- Display 10 Previous Radial Traces
    function pushbutton6_Callback(hObject, eventdata)
        %     display previous traces
        
        data = guidata(Anneal_fig);
        
        % RETURN IF NO TRACE TO DISPLAY
        if (data.NminR <= 1) ; return; end
        
        if data.Align == 1; % annealing runned
            for ii = data.NminR:data.NmaxR
                set(data.rb2(ii),'Visible','off');
            end
        end
        
%        guidata(Anneal_fig,data);
        
        % FIRST TRACE TO DISPLAY
        n1 = max(data.NminR-data.NbDisp,1);
        
        % LAST TRACE TO DISPLAY
        n2 = max(data.NminR-1,1);
        
        % STORE IN GLOBAL VARIABLE
        data.NminR = n1;
        data.NmaxR = n2;
        
        % CHOOSE AXES
%        axes(axes4);cla;hold on
        
        guidata(Anneal_fig,data);
        
        % DISPLAY 10 TRACES
        DisplayRadial;
        
        guidata(Anneal_fig,data);
        
    end

% --- Executes on button press in pushbutton7
% --- Display 10 First Trans Traces
    function pushbutton7_Callback(hObject, eventdata)
        %         display first 10 traces in cluster

        data = guidata(Anneal_fig);
        set(pushbutton8,'Enable','off')
        set(pushbutton9,'Enable','off')
        
        % disable rb from previous display
        if data.Align == 1 % annealing runned
            for ii = data.NminT:data.NmaxT
                set(data.rb3(ii),'Visible','off');
            end
        end

        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminT = 1;
        data.NmaxT = min(data.NbDisp,data.Ntraces);
                
        guidata(Anneal_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayTransverse;
        
        guidata(Anneal_fig,data)
        
        set(pushbutton8,'Enable','on')
        set(pushbutton9,'Enable','on')
    end

% --- Executes on button press in pushbutton8
% --- Display 10 Next Trans Traces
    function pushbutton8_Callback(hObject, eventdata)
        %     display next traces
        
        set(pushbutton7,'Enable','off')
        set(pushbutton9,'Enable','off')

        data = guidata(Anneal_fig);

        % RETURN IF NO TRACE TO DISPLAY
        if (data.NmaxT >= data.Ntraces)
            set(pushbutton7,'Enable','on')
            set(pushbutton9,'Enable','on')
            return
        end
        
        if data.Align == 1 % annealing runned
            for ii = data.NminT:data.NmaxT
                set(data.rb3(ii),'Visible','off');
            end
        end
        
        % FIRST TRACE TO DISPLAY
        n1 = min(data.NmaxT+1,data.Ntraces);
        
        % LAST TRACE TO DISPLAY
        n2 = min(data.NmaxT+data.NbDisp,data.Ntraces);

        % STORE IN GLOBAL VARIABLE
        data.NminT = n1;
        data.NmaxT = n2;

        guidata(Anneal_fig,data)

        % DISPLAY 10 TRACES
        DisplayTransverse;
        
        guidata(Anneal_fig,data)
        
        set(pushbutton7,'Enable','on')
        set(pushbutton9,'Enable','on')

    end

% --- Executes on button press in pushbutton9
% --- Display 10 Previous Trans Traces
    function pushbutton9_Callback(hObject, eventdata)
        %     display previous traces
        set(pushbutton7,'Enable','off')
        set(pushbutton8,'Enable','off')

        data = guidata(Anneal_fig);
        
        % RETURN IF NO TRACE TO DISPLAY
        if (data.NminT <= 1) 
            set(pushbutton7,'Enable','on')
            set(pushbutton8,'Enable','on')
            return 
        end
        
        if data.Align == 1 % annealing runned
            for ii = data.NminT:data.NmaxT
                set(data.rb3(ii),'Visible','off');
            end
        end
        
        % FIRST TRACE TO DISPLAY
        n1 = max(data.NminT-data.NbDisp,1);
        
        % LAST TRACE TO DISPLAY
        n2 = max(data.NminT-1,1);
        
        % STORE IN GLOBAL VARIABLE
        data.NminT = n1;
        data.NmaxT = n2;
                
        guidata(Anneal_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayTransverse;
        
        guidata(Anneal_fig,data);
        
        set(pushbutton7,'Enable','on')
        set(pushbutton8,'Enable','on')

    end
    
    function refilt_button_Callback(hObject, eventdata)
         ui_initialize
         preprocess_trace

         guidata(Anneal_fig,data)
         data.Align = 0;
         guidata(Anneal_fig,data)

         DisplayTraces;
         DisplayRadial;
         DisplayTransverse;
    end

    function chooseComponentAlign1_Callback(hObject, eventdata)
       set(radiobutton5,'Value',1)
       set(radiobutton6,'Value',0)
       set(radiobutton7,'Value',0)
       
       data = guidata(Anneal_fig);
       data.selected_comp=1;
       guidata(Anneal_fig,data)
    end

    function chooseComponentAlign2_Callback(hObject, eventdata)
       set(radiobutton5,'Value',0)
       set(radiobutton6,'Value',1)
       set(radiobutton7,'Value',0) 
       
       data = guidata(Anneal_fig);
       data.selected_comp=2;
       guidata(Anneal_fig,data)
    end

    function chooseComponentAlign3_Callback(hObject, eventdata)
       set(radiobutton5,'Value',0)
       set(radiobutton6,'Value',0)
       set(radiobutton7,'Value',1)   
       
       data = guidata(Anneal_fig);
       data.selected_comp=3;
       guidata(Anneal_fig,data)
    end
    function radiobuttonZRT_Callback(hObject, eventdata)
       set(radiobuttonZNE,'Value',0)
       set(radiobuttonZRT,'Value',1)   
       
       data = guidata(Anneal_fig);
       data.need_rotate=1;
       guidata(Anneal_fig,data)
    end
    function radiobuttonZNE_Callback(hObject, eventdata)
       set(radiobuttonZNE,'Value',1)
       set(radiobuttonZRT,'Value',0)   
       
       data = guidata(Anneal_fig);
       data.need_rotate=0;
       guidata(Anneal_fig,data)
    end

    function radiobuttonPlotOnMain_Callback(hObject, eventdata)
       set(radiobuttonPlotOnMain,'Value',1)
       set(radiobuttonPlotOutside,'Value',0)   
    end

    function radiobuttonPlotOutside_Callback(hObject, eventdata)
       set(radiobuttonPlotOnMain,'Value',0)
       set(radiobuttonPlotOutside,'Value',1)   
    end
% --------------------------------------------------------------------
% --- Align Traces considereing the displayed Time Window
    function Align_Traces_Callback(hObject, eventdata)
        
        data = guidata(Anneal_fig);
    
        if data.Align == 1
            delete(data.rb);
            delete(data.rb2);
            delete(data.rb3);
        end
        
        % GET CLUSTER INDEX
        ic = get(listbox1,'Value');
        
        % GET PARAMETERS
        Ntraces = data.Ntraces;
        dt = data.SigFlZ(1).HdrData.DELTA;
        
        % SELECTION OF TRACES IN CLUSTER
        %SelectionZ = data.SelectionZ;
        switch  data.selected_comp
            case 1
                SelectionZ = data.SelectionZ;
            case 2
                SelectionZ = data.SelectionR;
            case 3
                SelectionZ = data.SelectionT;
        end

        NbSelected = length(find(SelectionZ));
        
        % GET TIME BEFORE THEORETICAL P ARRIVAL
        Tmin = str2double(get(edit1,'String'));
        Tmax = str2double(get(edit2,'String'));
        
        % DELAY BETWEEN SIGNALS AND FIRST MEAN TRACE 
        S = []; PtheoMean = 0;
        for i = 1:Ntraces
            switch data.selected_comp
                case 1 
                    S(i,:) = data.SigFlZ(i).SeisData(:);
                case 2
                    S(i,:) = data.SigFlR(i).SeisData(:);
                case 3
                    S(i,:) = data.SigFlT(i).SeisData(:);
            end
            Ptheo = data.SigFlZ(i).HdrData.A-data.SigFlZ(i).HdrData.B;
            PtheoMean = PtheoMean + Ptheo;
        end
        data.PtheoMean = PtheoMean/Ntraces;

%        [sig_align,delay] = aligne_trace_cc(S,dt,0,Tmin+Tmax);     
        [sig_align,delay] = aligne_trace_cc_int(S,dt,0,Tmin+Tmax,data.tshiftmax);     

%        [delay]

        Stack = sum(sig_align)./Ntraces;
        Npts = length(Stack);

%        whos S Stack

        % Align traces on Stack trace
%        for i = 1:Ntraces
%            s = S(i,:);
%            [Cor,Cor_max,tshift] = correl_max(Stack,s,Npts,dt);
%            sig_align(i,:) = phaseshift(s,Npts,dt,-tshift);
%            delay(i) = -tshift;
%        end
        
        for i = 1:Ntraces
            switch data.selected_comp
                case 1
                    data.SigFlZ(i).SeisDataAlign = sig_align(i,:);
                    data.SigFlR(i).SeisDataAlign(:) = phaseshift(data.SigFlR(i).SeisData(:)',length(Stack),dt,delay(i));
                    data.SigFlT(i).SeisDataAlign(:) = phaseshift(data.SigFlT(i).SeisData(:)',length(Stack),dt,delay(i));
                case 2
                    data.SigFlZ(i).SeisDataAlign = phaseshift(data.SigFlZ(i).SeisData(:)',length(Stack),dt,delay(i));;
                    data.SigFlR(i).SeisDataAlign(:) = sig_align(i,:);
                    data.SigFlT(i).SeisDataAlign(:) = phaseshift(data.SigFlT(i).SeisData(:)',length(Stack),dt,delay(i));
                case 3
                    data.SigFlZ(i).SeisDataAlign = phaseshift(data.SigFlZ(i).SeisData(:)',length(Stack),dt,delay(i));;
                    data.SigFlR(i).SeisDataAlign(:) = phaseshift(data.SigFlR(i).SeisData(:)',length(Stack),dt,delay(i));
                    data.SigFlT(i).SeisDataAlign(:) = sig_align(i,:);
            end
        end

        % AMPLITUDE ANOMALIES
        for i = 1:Ntraces
           sigZ(i,:) = data.SigFlZ(i).SeisDataAlign;
           sigR(i,:) = data.SigFlR(i).SeisDataAlign;
           sigT(i,:) = data.SigFlT(i).SeisDataAlign;

        end

        wavelet = Stack;

        for i = 1:Ntraces
            switch data.selected_comp
                case 1
                    s = sigZ(i,:);
                case 2
                    s = sigR(i,:);
                case 3
                    s = sigT(i,:);
            end
           dAmp(i) = (s*wavelet')./(wavelet*wavelet');
        end

        % SNR Radial Component
        for i = 1:Ntraces
           num = sqrt(sum(sigR(i,:).*sigR(i,:)));
           den = sqrt(sum(data.SigInFlR(i).SeisData(101:100+length(Stack)).*data.SigInFlR(i).SeisData(101:100+length(Stack))));
           SNR(i) = max(abs(sigR(i,:)));
        end
        SNR = SNR./(sum(SNR)/Ntraces);

        % Correlation coefficient between Z and R
        for i = 1:Ntraces
          s = sigR(i,:);
          s2 = sigZ(i,:);
          data.CorrR(i) = (s*wavelet')./(sqrt(wavelet*wavelet')*sqrt(s*s'));
          data.AmpR(i) = (s*s2')./(s2*s2');
        end
 
        data.TimeDelay = delay;
        data.AmpZ = dAmp;
        data.SNR = SNR;
        data.Stack = Stack;
        data.MeanTrace = data.Stack;
%        data.MeanTrace = wavelet;
        TimeMean = (0:dt:(length(data.MeanTrace)-1)*dt);

        % DISPLAY MEAN TRACE ON AXES1
        axes(axes1);cla;
        set(gca,'YlimMode','auto')
        plot(TimeMean,data.MeanTrace,'r');
        hold on
        plot([data.PtheoMean data.PtheoMean],[-max(data.MeanTrace)*0.1,max(data.MeanTrace)*0.1],'g','LineWidth',1);
        title('Pick first arrival')

        % ZOOM
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        zoom1 = get(gca,'CurrentPoint');
        rbbox;
        zoom2 = get(gca,'CurrentPoint');
        axes_lim = get(gca,'Xlim');
        fzoom = 8;
        if zoom1(1,1) == zoom2(1,1)
            tlen = axes_lim(2)-axes_lim(1);
            axes_lim(1) = max(0,zoom1(1,1)-tlen/fzoom);
            axes_lim(2) = zoom2(1,1)+tlen/fzoom;
        else
            axes_lim(1) = zoom1(1,1);
            axes_lim(2) = zoom2(1,1);
        end
        
        set(axes1,'Xlim',[axes_lim(1) axes_lim(2)]);

        % PICK ARRIVAL TIME ON MEAN TRACE
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        pt = get(axes1, 'CurrentPoint');
        x = pt(1);
        xmin = x-str2double(get(edit1,'String'));
        xmax = x+str2double(get(edit2,'String'));
        ipick = find(TimeMean<=x,1,'last');     % find index
        data.WavePick(ic) = ipick; % and store it.
        data.tpick = TimeMean(ipick);
        
        for i = 1:Ntraces
            % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
            res(i) = data.tpick-data.TimeDelay(i)-Tmin;
        end

        data.ResMean = mean(res);
            
        for i = 1:Ntraces
            data.residu(i) = res(i)-mean(res);
        end
    
        MeanTrace = data.MeanTrace;
        ss = data.SigFlZ(1).SeisData;
        for i = 1:Ntraces
            s = sigZ(i,:);
            num = Stack*s';
            denom = sqrt(s*s')*sqrt(Stack*Stack');
%            num = sum(data.MeanTrace*data.SigFlZ(i).SeisData);
%            denom = sqrt(sum(abs(data.SigFlZ(i).SeisData.^2)))*sqrt(sum(abs(data.MeanTrace.^2)));
            data.CoefCor(i) = num/denom;
        end

        % RESET THE BUTTON DOWN FUNCTION
        set(gcf,'pointer','default');
        
        guidata(Anneal_fig,data)
        axes(axes1);cla;hold on;
        set(gca,'YlimMode','manual');
        set(gca,'Ylim',[0 data.NbDisp+2]);
        set(gca,'Ydir', 'reverse');
        

        Display_Time_Residuals;

        Display_Amplitude_Residuals;

       
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.Nmin = 1;
        data.Nmax = min(data.NbDisp,Ntraces);
        
        data.Align = 1;
        
        guidata(Anneal_fig,data)
        
        % CHOOSE AXES1
        axes(axes1)
        Radiobutton_trace;
        DisplayTraces;
        guidata(Anneal_fig,data)

        % CHOOSE AXIS4
        Radiobutton_radial;
        DisplayRadial;
        guidata(Anneal_fig,data)
        
        % CHOOSE AXIS7
        Radiobutton_transverse;
        DisplayTransverse;
        guidata(Anneal_fig,data)
        
        if isfile( fullfile(data.DirSac,'../STATIONS_weight'))
            read_station_weight;
        end


    end
% --------------------------------------------------------------------
    function read_station_weight(hObject, eventdata)
        data = guidata(Anneal_fig);
        [~,w1,w2,w3] = textread(fullfile(data.DirSac,'../STATIONS_weight'),'%s %d %d %d');
        for i = 1:data.Ntraces
            if (w1(i)~=1 && w2(i)~=1)
                data.SelectionR(i) = 0;
            end
            if (w3(i)~=1)
                data.SelectionZ(i) = 0;
            end
        end
        
        guidata(Anneal_fig,data)
        DisplayTraces;
        DisplayRadial;
        DisplayTransverse;
    end

% --- Choose Time Window Beginning
    function ChooseT0_Callback(hObject, eventdata)
        
        data = guidata(Anneal_fig);
        
        % GET CLUSTER INDEX
        ic = get(listbox1,'Value');
        
        % GET PARAMETERS
        Ntraces = data.Ntraces;
        dt = data.SigFlZ(1).HdrData.DELTA;
        
        % SELECTION OF TRACES IN CLUSTER
        SelectionZ = data.SelectionZ;
        NbSelected = length(find(SelectionZ));
        
        % GET TIME BEFORE THEORETICAL P ARRIVAL
        Tmin = str2double(get(edit1,'String'));
        Tmax = str2double(get(edit2,'String'));

        TimeMean = (0:dt:(length(data.MeanTrace)-1)*dt)';

        % DISPLAY MEAN TRACE ON AXES1
        axes(axes1);cla;
        set(gca,'YlimMode','auto')
        plot(TimeMean,data.MeanTrace,'r');
        title('Pick T0')

        % ZOOM
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        zoom1 = get(gca,'CurrentPoint');
        rbbox;
        zoom2 = get(gca,'CurrentPoint');
        axes_lim = get(gca,'Xlim');
        fzoom = 8;
        if zoom1(1,1) == zoom2(1,1)
            tlen = axes_lim(2)-axes_lim(1);
            axes_lim(1) = max(0,zoom1(1,1)-tlen/fzoom);
            axes_lim(2) = zoom2(1,1)+tlen/fzoom;
        else
            axes_lim(1) = zoom1(1,1);
            axes_lim(2) = zoom2(1,1);
        end

        set(axes1,'Xlim',[axes_lim(1) axes_lim(2)]);

        % PICK T0 ON MEAN TRACE
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        pt = get(axes1, 'CurrentPoint');
        x = pt(1);
        ipick = find(TimeMean<=x,1,'last');     % find index
        data.T0(ic) = ipick; % and store it.
        data.T0pick(ic) = TimeMean(ipick);
        
        % RESET THE BUTTON DOWN FUNCTION
        set(gcf,'pointer','default');
        
        guidata(Anneal_fig,data)
        axes(axes1);cla;hold on;
        set(gca,'YlimMode','manual');
        set(gca,'Ylim',[0 data.NbDisp+2]);
        set(gca,'Ydir', 'reverse');
                
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.Nmin = 1;
        data.Nmax = min(data.NbDisp,Ntraces);
        
        data.Align = 1;
        
        guidata(Anneal_fig,data)
        
        % CHOOSE AXES1
        %axes(axes1);cla;hold on
        
        DisplayTraces;
        
        guidata(Anneal_fig,data)
        
    end

% --------------------------------------------------------------------
% --- Choose Time Window End
    function ChooseT1_Callback(hObject, eventdata)
        
        data = guidata(Anneal_fig);
        
        % GET CLUSTER INDEX
        ic = get(listbox1,'Value');
        
        % GET PARAMETERS
        Ntraces = data.Ntraces;
        dt = data.SigFlZ(1).HdrData.DELTA;
        
        % SELECTION OF TRACES IN CLUSTER
        SelectionZ = data.SelectionZ;
        NbSelected = length(find(SelectionZ));
        
        % GET TIME BEFORE THEORETICAL P ARRIVAL
        Tmin = str2double(get(edit1,'String'));
        Tmax = str2double(get(edit2,'String'));

        TimeMean = (0:dt:(length(data.MeanTrace)-1)*dt)';
        
        % DISPLAY MEAN TRACE ON AXES1
        axes(axes1);cla;
        set(gca,'YlimMode','auto')
        plot(TimeMean,data.MeanTrace,'r');
        title('Pick T1')

        % ZOOM
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        zoom1 = get(gca,'CurrentPoint');
        rbbox;
        zoom2 = get(gca,'CurrentPoint');
        axes_lim = get(gca,'Xlim');
        fzoom = 8;
        if zoom1(1,1) == zoom2(1,1)
            tlen = axes_lim(2)-axes_lim(1);
            axes_lim(1) = max(0,zoom1(1,1)-tlen/fzoom);
            axes_lim(2) = zoom2(1,1)+tlen/fzoom;
        else
            axes_lim(1) = zoom1(1,1);
            axes_lim(2) = zoom2(1,1);
        end

        set(axes1,'Xlim',[axes_lim(1) axes_lim(2)]);

        % PICK T0 ON MEAN TRACE
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        pt = get(axes1, 'CurrentPoint');
        x = pt(1);
        ipick = find(TimeMean<=x,1,'last');     % find index
        data.T1(ic) = ipick; % and store it.
        data.T1pick(ic) = TimeMean(ipick);
        
        % RESET THE BUTTON DOWN FUNCTION
        set(gcf,'pointer','default');
        
        guidata(Anneal_fig,data)
        axes(axes1);cla;hold on;
        set(gca,'YlimMode','manual');
        set(gca,'Ylim',[0 data.NbDisp+2]);
        set(gca,'Ydir', 'reverse');
                
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.Nmin = 1;
        data.Nmax = min(data.NbDisp,Ntraces);
        
        data.Align = 1;
        
        guidata(Anneal_fig,data)
        
        % CHOOSE AXES1
        %axes(axes1);cla;hold on
        
        DisplayTraces;
        
        guidata(Anneal_fig,data)
        
    end

% --------------------------------------------------------------------
    function SaveWV_Callback(hObject, eventdata)
        % Write outputs of simulated annealing in file
        
        data = guidata(Anneal_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % ANNEALING NOT RUN YET
        if (data.Align==0);
            mess = msgbox('Annealing Not Done Yet');
            return;
        end
        
        if isfield(data,'OutputDir') == 0
            data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
        end

        E = exist([data.OutputDir,'/','Wavelet'],'file');
        
        if E == 2        
            
            choice = questdlg('Wavelet File already exists, do you want to replace it ?', ...
                'Wavelet File already exists', ...
                'Yes','No','Yes');
            
            switch choice
                case 'Yes'
                    fid = fopen([data.OutputDir,'/','Wavelet'],'w');
                    
                case 'No'
                    OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                    fid = fopen([OutputDir2,'/','Wavelet'],'w');
            end
            
        else 
            fid = fopen([data.OutputDir,'/','Wavelet'],'w');
            
        end
        
        for i = 1:length(data.WaveletMean)
            LINE = sprintf('%f', ...
                data.WaveletMean(i));
            fprintf(fid,'%s\n',LINE);
        end

        fclose(fid)
        
        guidata(Anneal_fig,data)
        
    end
        
% -------------------------------------------------------------------------
function DisplayMap
        axes(axes_map);cla;hold on
        
        data = guidata(Anneal_fig);

        evlo = data.SigFlZ(1).HdrData.EVLO;
        evla = data.SigFlZ(1).HdrData.EVLA;
        m_proj('mercator','lon',[-300,100],'lat',[-65,65]);
        m_coast('color','k');
        m_grid('linestyle','none','tickdir','out','linewidth',3);

        for i = 1:data.Ntraces
            Sta(2) = data.SigFlZ(i).HdrData.STLA;
            Sta(1) = data.SigFlZ(i).HdrData.STLO;
            StaName = data.SigFlZ(i).HdrData.KSTNM;
            m_plot(Sta(1),Sta(2),'o','MarkerFaceColor','blue');
            %h=m_text(Sta(1),Sta(2),StaName,'FontSize',10,'HorizontalAlignment', 'left', ...
            %    'VerticalAlignment', 'bottom');
            %set(h,'Rotation',30);
        end
        if (evlo > 100)
            evlo = evlo - 360;
        end
        m_plot(evlo,evla,'-p','MarkerSize',10,'MarkerFaceColor','red','MarkerEdgeColor','black');       
    end
% --------------------------------------------------------------------
function DisplayFocal
    
data = guidata(Anneal_fig);


if isfile( fullfile(data.DirSac,'CMTSOLUTION'))
    M = readcmt_localfile(fullfile(data.DirSac,'CMTSOLUTION'));
else
    % We have to download the focal solution from GCMT first
    M = DownloadGCMT(); %[mrr, mtt, mff, mrt, mrf, mtf]
end
axes(axes_focal); cla; hold on

azimuth = data.SigFlZ(1).HdrData.AZ;
distant = data.SigFlZ(1).HdrData.GCARC;
depth = data.SigFlZ(1).HdrData.EVDP;

%focalmech(M,0,0,2,'r','dc','text',text,'piecring',1,'azimuth',azimuth,'degree',distant,'depth',depth,'phase','P')
focalmech(M,0,0,2,'r','dc','piecring',1,'azimuth',azimuth,'degree',distant,'depth',depth,'phase','P')
hold off
end
% -------------------------------------------------------------------------
function M = DownloadGCMT

data = guidata(Anneal_fig);
evt_jyear = data.SigFlZ(1).HdrData.NZYEAR;
evt_jday  = data.SigFlZ(1).HdrData.NZJDAY;
evlo =  data.SigFlZ(1).HdrData.EVLO;
evla =  data.SigFlZ(1).HdrData.EVLA;

url = strcat("http://www.globalcmt.org/cgi-bin/globalcmt-cgi-bin/CMT5/form?itype=jul", ...
    "&jyr=", string(evt_jyear), ...
    "&jday=", string(evt_jday), ...
    "&otype=nd", ...
    "&nday", string(1), ...
    "&lmw=", string(str2double(data.mag)-0.1), ...
    "&llat=", string(evla-3), ...
    "&ulat=", string(evla+3), ...
    "&llon=", string(evlo-3), ...
    "&ulon=", string(evlo+3), ...
    "&list=3");

outfilename = websave("cmt.html",url,'RequestMethod','POST');
[M,text] = readcmt_html(outfilename);
saveGCMT
return 

end

function saveGCMT
    data = guidata(Anneal_fig);
evt_jyear = data.SigFlZ(1).HdrData.NZYEAR;
evt_jday  = data.SigFlZ(1).HdrData.NZJDAY;
evlo =  data.SigFlZ(1).HdrData.EVLO;
evla =  data.SigFlZ(1).HdrData.EVLA;
output_dir = data.DirSac;
    url = strcat("http://www.globalcmt.org/cgi-bin/globalcmt-cgi-bin/CMT5/form?itype=jul", ...
    "&jyr=", string(evt_jyear), ...
    "&jday=", string(evt_jday), ...
    "&otype=nd", ...
    "&nday", string(1), ...
    "&lmw=", string(5.8), ...
    "&llat=", string(evla-1), ...
    "&ulat=", string(evla+1), ...
    "&llon=", string(evlo-1), ...
    "&ulon=", string(evlo+1), ...
    "&list=4");
outfilename = websave("cmt.html",url,'RequestMethod','POST');

extract_cmt_from_html(outfilename, output_dir);
    end
% -------------------------------------------------------------------
function Radiobutton_trace
        data = guidata(Anneal_fig);
        for ii = 1:data.Ntraces
            row = mod(ii,data.NbDisp);
            if row == 0
                row = 10;
            end
            data.rb(ii) = uicontrol( ...
              'Units', 'normalized', ...
              'Style', 'Radio', ...
              'HitTest', 'On', ...
              'Enable', 'On', ...
              'Value', 0, ...
              'Visible', 'off', ...
              'HandleVisibility', 'On', ...
              'Callback', @UpdateDisplayZ, ...
              'Interruptible', 'On', ...
              'Position', [0.03 0.65-(row -1 +1.75)*(0.6/(data.NbDisp+2)) 0.02 0.02]);
        end
        guidata(Anneal_fig,data)
end
% ----------------------------------------------------------------------
function Radiobutton_radial
        data = guidata(Anneal_fig);
        for ii = 1:data.Ntraces
            row = mod(ii,data.NbDisp);
            if row == 0
               row = 10;
            end
            data.rb2(ii) = uicontrol( ...
              'Units', 'normalized', ...
              'Style', 'Radio', ...
              'HitTest', 'On', ...
              'Enable', 'On', ...
              'Value', 0, ...
              'Visible', 'off', ...
              'HandleVisibility', 'On', ...
              'Callback', @UpdateDisplayR, ...
              'Interruptible', 'On', ...
              'Position', [0.26 0.65-(row -1 +1.75)*(0.6/(data.NbDisp+2)) 0.02 0.02]);
        end
        guidata(Anneal_fig,data)
end
% ----------------------------------------------------------------------
function Radiobutton_transverse
        data = guidata(Anneal_fig);
        for ii = 1:data.Ntraces
            row = mod(ii,data.NbDisp);
            if row == 0
               row = 10;
            end
            data.rb3(ii) = uicontrol( ...
              'Units', 'normalized', ...
              'Style', 'Radio', ...
              'HitTest', 'On', ...
              'Enable', 'On', ...
              'Value', 0, ...
              'Visible', 'off', ...
              'HandleVisibility', 'On', ...
              'Callback', @UpdateDisplayT, ...
              'Interruptible', 'On', ...
              'Position', [0.49 0.65-(row -1 +1.75)*(0.6/(data.NbDisp+2)) 0.02 0.02]);
        end
        guidata(Anneal_fig,data)
end

% ----------------------------------------------------------------------
function DisplayTraces
        
axes(axes1);cla;hold on

data = guidata(Anneal_fig);
        
% GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
SelectionZ = data.SelectionZ;

% TIME
Tmax = 0;
Tmin = 1000;

% loop over 10 events in cluster.
for ii = data.NminZ:data.NmaxZ
            
    if (data.Align == 1)
        TimeShift = data.residu(ii);
    else
        TimeShift = 0;
    end
            
    % STATION NAME
    StaName = [data.SigFlZ(ii).HdrData.KSTNM];
    [t0,t1,hpl] = PlotOnTrace(data.SigFlZ(ii).SeisData,-TimeShift,data.SigFlZ(ii).HdrData.DELTA,ii-data.NminZ+2);
    data.DispTraceZ(ii) = hpl;
    Tmax = max(Tmax,t1);
    Tmin = min(Tmin,t0);
            
    % ADD STATION NAME
    text(Tmin-3.5,ii-data.NminZ+1.5,StaName, ...
        'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');

    if SelectionZ(ii) == 0
            
        set(hpl,'Color',[0.8 0.8 0.8]);
                
        if (data.Align == 1)  % annealing runned
            set(data.rb(ii),'Visible','On');
            set(data.rb(ii),'Value',0);
        end
                
    else
        
        if (data.Align == 1) ; % annealing runned
            set(data.rb(ii),'Visible','On');
            set(data.rb(ii),'Value',1);
                    
            % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
            % EACH TRACE
            residual = data.residu(ii);
            RESIDU = num2str(residual,'%5.3f');
            amp = data.AmpZ(ii);
            dAmp = num2str(amp,'%4.3f');
            strtr = strcat(RESIDU,'/',dAmp);
            %text(Tmin-1,ii-data.NminZ+1.8,RESIDU,...
            text(Tmin+2,ii-data.NminZ+1.8,strtr,...
              'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    
            Coef = data.CoefCor(ii);
            COEF = num2str(Coef,'%4.3f');
            text(Tmin-6.5,ii-data.NminZ+2,COEF,...
              'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
            text(Tmin-6.5,1,'R^2',...
              'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

            % PLOT THEORETICAL ARRIVAL TIME
            plot([data.SigFlZ(ii).HdrData.A-data.SigFlZ(ii).HdrData.B data.SigFlZ(ii).HdrData.A-data.SigFlZ(ii).HdrData.B]-TimeShift,[ii-data.NminZ+1.5, ii-data.NminZ+2.5],'g');
                                       
        else  % ANNEALING NOT RUNNED
              % add station Name
              
            text(Tmin-3.5,ii-data.NminZ+1.5,StaName,...
              'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                    
        end
                
    end
            
end
        
% ADD MEAN TRACE
if (data.Align == 1 && data.selected_comp ==1)  % annealing runned
    % PLOT MEAN TRACE FOR CLUSTER
    AddTrace(data.MeanTrace,0,data.SigFlZ(ii).HdrData.DELTA,1);
    % TIME PICK
    plot([data.tpick data.tpick],[0.7,1.3],'k','LineWidth',1);
%    hold on
    plot([data.PtheoMean data.PtheoMean],[0.7,1.3],'g','LineWidth',1);
end

xlabel('Time (s)');
title(['Z  ',num2str(data.NminZ),'-',num2str(data.NmaxZ),'/',num2str(data.Ntraces)]);
xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
set(axes1,'yticklabel',[]);

guidata(Anneal_fig,data)
        
end

% -------------------------------------------------------------------------
function DisplayRadial
        
axes(axes4);cla;hold on

data = guidata(Anneal_fig);
        
% GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
SelectionR = data.SelectionR;
        
% TIME
Tmax = 0;
Tmin = 1000;
        
% loop over 10 events in cluster.
for ii = data.NminR:data.NmaxR

    if (data.Align == 1) ;
      TimeShift = data.residu(ii);
    else
      TimeShift = 0;
    end
            
    % STATION NAME
    StaName = [data.SigFlR(ii).HdrData.KSTNM];
    [t0,t1,hpl] = PlotOnTrace(data.SigFlR(ii).SeisData,-TimeShift,data.SigFlR(ii).HdrData.DELTA,ii-data.NminR+2);
    data.DispTraceR(ii) = hpl;
    Tmax = max(Tmax,t1);
    Tmin = min(Tmin,t0);
           
    % ADD STATION NAME
    text(Tmin-3.5,ii-data.NminR+1.5,StaName, ...
        'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
            
    if SelectionR(ii) == 0
                
        set(hpl,'Color',[0.8 0.8 0.8]);
        
        if (data.Align == 1)  % annealing runned
            % ADD RADIOBUTTON
            set(data.rb2(ii),'Visible','On');
            set(data.rb2(ii),'Value',0);
        end
                
    else %selected
                
        if (data.Align == 1) ; % annealing runned
                    
            % ADD RADIOBUTTON
            set(data.rb2(ii),'Visible','On');
            set(data.rb2(ii),'Value',1);
            
            % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
            % EACH TRACE
            snr = data.SNR(ii);
            SNR = num2str(snr,'%4.3f');
            snr = data.AmpR(ii);
            SNR = num2str(snr,'%4.3f');
            text(Tmin-1,ii-data.NminR+1.8,SNR,...
                'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    
            Coef = data.CorrR(ii);
            COEF = num2str(Coef,'%4.3f');
            text(Tmin-6.,ii-data.NminR+2,COEF,...
                'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

            % PLOT THEORETICAL ARRIVAL TIME
            plot([data.SigFlR(ii).HdrData.A-data.SigFlR(ii).HdrData.B data.SigFlR(ii).HdrData.A-data.SigFlR(ii).HdrData.B]-TimeShift,[ii-data.NminR+1.5, ii-data.NminR+2.5],'g');
                                       
        else  % ANNEALING NOT RUNNED
            % add station Name
            text(Tmin-3.5,ii-data.NminR+1.5,StaName,...
                'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                 
        end
                
    end
          
end
        
% ADD MEAN TRACE
if (data.Align == 1 && data.selected_comp == 2)
    text(Tmin-6.5,1,'R^2',...
    'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

    % PLOT MEAN TRACE FOR CLUSTER
    AddTrace(data.MeanTrace,0,data.SigFlZ(ii).HdrData.DELTA,1);
    % TIME PICK
    plot([data.tpick data.tpick],[0.7,1.3],'k','LineWidth',1);
    plot([data.PtheoMean data.PtheoMean],[0.7,1.3],'g','LineWidth',1);
end
        
xlabel('Time (s)');
title(['R  ',num2str(data.NminR),'-',num2str(data.NmaxR),'/',num2str(data.Ntraces)]);
xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
set(axes4,'yticklabel',[]);
        
guidata(Anneal_fig,data)
       
end

%----------------------------------------------------------------------------------
function DisplayTransverse
        
axes(axes7);cla;hold on

data = guidata(Anneal_fig);
        
% GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
SelectionT = data.SelectionT;
        
% TIME
Tmax = 0;
Tmin = 1000;
        
% loop over 10 events in cluster.
for ii = data.NminT:data.NmaxT

    if (data.Align == 1) ;
      TimeShift = data.residu(ii);
    else
      TimeShift = 0;
    end
            
    % STATION NAME
    StaName = [data.SigFlT(ii).HdrData.KSTNM];
    [t0,t1,htl] = PlotOnTrace(data.SigFlT(ii).SeisData,-TimeShift,data.SigFlT(ii).HdrData.DELTA,ii-data.NminT+2);
    data.DispTraceT(ii) = htl;
    Tmax = max(Tmax,t1);
    Tmin = min(Tmin,t0);
           
    % ADD STATION NAME
    text(Tmin-3.5,ii-data.NminT+1.5,StaName, ...
        'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
            
    if SelectionT(ii) == 0

        set(htl,'Color',[0.8 0.8 0.8]);
        
        if (data.Align == 1)  % annealing runned
            % ADD RADIOBUTTON
            set(data.rb3(ii),'Visible','On');
            set(data.rb3(ii),'Value',0);
        end
                
    else
                
        if (data.Align == 1) ; % annealing runned
                    
            % ADD RADIOBUTTON
            set(data.rb3(ii),'Visible','On');
            set(data.rb3(ii),'Value',1);
            
            % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
            % EACH TRACE
            snr = data.SNR(ii);
            SNR = num2str(snr,'%4.3f');
            %snr = data.AmpT(ii);
            %SNR = num2str(snr,'%4.3f');
            %text(Tmin-1,ii-data.NminT+1.8,SNR,...
            %    'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    
            %Coef = data.CorrT(ii);
            %COEF = num2str(Coef,'%4.3f');
            %text(Tmin-6.,ii-data.NminT+2,COEF,...
            %    'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
            %text(Tmin-6.5,1,'R^2',...
            %    'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

            % PLOT THEORETICAL ARRIVAL TIME
            plot([data.SigFlT(ii).HdrData.A-data.SigFlT(ii).HdrData.B data.SigFlT(ii).HdrData.A-data.SigFlT(ii).HdrData.B]-TimeShift,[ii-data.NminT+1.5, ii-data.NminT+2.5],'g');
                                       
        else  % ANNEALING NOT RUNNED
            % add station Name
            text(Tmin-3.5,ii-data.NminT+1.5,StaName,...
                'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                 
        end 
    end
          
end
        
% ADD MEAN TRACE
if (data.Align == 1 && data.selected_comp == 3)  % annealing runned
    % PLOT MEAN TRACE FOR CLUSTER
    AddTrace(data.MeanTrace,0,data.SigFlT(ii).HdrData.DELTA,1);
    % TIME PICK
    plot([data.tpick data.tpick],[0.7,1.3],'k','LineWidth',1);
    plot([data.PtheoMean data.PtheoMean],[0.7,1.3],'g','LineWidth',1);
end
        
xlabel('Time (s)');
title(['T  ',num2str(data.NminT),'-',num2str(data.NmaxT),'/',num2str(data.Ntraces)]);
xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
set(axes7,'yticklabel',[]);
        
guidata(Anneal_fig,data)
       
end


%----------------------------------------------------------------------------------
% --- Display Map of Time Residuals
    function Display_Time_Residuals
        
        % DISPLAY RESIDUALS ON MAP
        
        data = guidata(Anneal_fig);

        Ntraces = data.Ntraces;

        switch data.selected_comp
            case 1
                Selection = data.SelectionZ;
                SigFl = data.SigFlZ;
            case 2
                Selection = data.SelectionR;
                SigFl = data.SigFlR;
            case 3
                Selection = data.SelectionT;
                SigFl = data.SigFlT;
        end
        
        % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
        
        % COLORS RO DISPLAY RESIDUALS
        couleur = flipud(RtoB(100));
        
        for i = 1:Ntraces
            if Selection(i) == 1
                residu(i) = data.residu(i);
            else
                residu(i) = 999.;
            end
        end
        [Couleurs,rr] = CalculeCouleur_dt(residu,couleur);

        % CHOOSE AXES
        whereToPlot = get(radiobuttonPlotOnMain,'Value');
        if whereToPlot == 1 %plot on main panel
            axes(axes2);cla;hold on
            axtoolbar(axes2,{'datacursor','zoomin','zoomout','restoreview'});
            
        else
            map(2,1)
        end
        
        m_proj('lambert','lon',[data.lonmin-0.5 data.lonmax+0.5],'lat',[data.latmin-0.5 data.latmax+0.5]);
        m_grid('linestyle','none','tickdir','out','linewidth',1);

        count = 0;
        for i = 1:Ntraces      
            count = count + 1 ;
            if Selection(i) == 1
                % PLOT RESIDUALS AT STATION LOCATIONS
                Sta(count,1) = SigFl(i).HdrData.STLO;
                Sta(count,2) = SigFl(i).HdrData.STLA;
                Sta(count,3) = data.residu(i);
                staname = SigFl(i).HdrData.KSTNM; %convertCharsToStrings(SigFl(i).HdrData.KSTNM);
                m_plot(Sta(count,1),Sta(count,2),'o','MarkerFaceColor',couleur(Couleurs(i),:),'Color',couleur(Couleurs(i),:),...
                    'tag',sprintf('Sta: %s \nRes: %f\nRow: %d', staname, Sta(count,3), count));
            end
        end
        datacursormode on
        dcm = datacursormode(gcf);
        set(dcm,'UpdateFcn',@myupdatefcn);
        
        % AXES TO PLOT THE COLOR SCALE
        if whereToPlot == 1   % on main panel
            axes(axes3);cla;hold on
        else
            map(2,2)
        end
        
        for i = 1:5
            plot(0.95*i-1.8,-3,'o','MarkerFaceColor',couleur(rr(i,2),:));
            if rr(i,1) > 0.
                Notation = sprintf('+%4.3f',rr(i,1));
            else
                Notation = sprintf('%5.3f',rr(i,1));
            end
            text(0.95*i-1.7,-3,Notation,'FontSize',8);
        end
        xlim([-1 3.5]);
        ylim([-7  1]);
        
        guidata(Anneal_fig,data)

    end

%----------------------------------------------------------------------------------
% --- Display Map of Amplitude Residuals
    function Display_Amplitude_Residuals
        
    % DISPLAY AMPLITUDE RESIDUALS ON MAP
        
    data = guidata(Anneal_fig);
        
    % GET CLUSTER INDEX
    ic = (get(listbox1,'value'));
       
    Ntraces = data.Ntraces;
    
    % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
    switch data.selected_comp
        case 1
            Selection = data.SelectionZ;
            SigFl = data.SigFlZ;
            Amp = data.AmpZ;
        case 2
            Selection = data.SelectionR;
            SigFl = data.SigFlR;
            Amp = data.AmpZ;
        case 3
            Selection = data.SelectionT;
            SigFl = data.SigFlT;
            Amp = data.AmpZ;
    end
        
    % COLORS TO DISPLAY RESIDUALS
    couleur = flipud(RtoB(100));
    for i = 1:Ntraces
        if Selection(i) == 1
            residu(i) = Amp(i);
        else
            residu(i) = 999.;
        end
    end
%    [residu(1:Ntraces)]
    [Couleurs,rr] = CalculeCouleur_amp(residu,couleur);
        
    % CHOOSE AXES
        whereToPlot = get(radiobuttonPlotOnMain,'Value');
        if whereToPlot == 1 %plot on main panel
            axes(axes5);cla;hold on
axtoolbar(axes5,{'datacursor','zoomin','zoomout','restoreview'});
        else
            map(3,1)
        end
    
    m_proj('lambert','lon',[data.lonmin-0.5 data.lonmax+0.5],'lat',[data.latmin-0.5 data.latmax+0.5]);
    m_grid('linestyle','none','tickdir','out','linewidth',1);
    
    count=0;
    for i = 1:Ntraces      
        count = count + 1 ;
        if Selection(i) == 1
            % PLOT RESIDUALS AT STATION LOCATIONS
            Sta(count,1) = SigFl(i).HdrData.STLO;
            Sta(count,2) = SigFl(i).HdrData.STLA;
            Sta(count,3) = residu(i);
            staname = SigFl(i).HdrData.KSTNM; %convertCharsToStrings(SigFl(i).HdrData.KSTNM);
            m_plot(Sta(count,1),Sta(count,2),'o','MarkerFaceColor',couleur(Couleurs(i),:),'Color',couleur(Couleurs(i),:),...
                'tag',sprintf('Sta: %s \nRes: %f\nRow: %d', staname, Sta(count,3), count));
        end
    end
        datacursormode on
        dcm = datacursormode(gcf);
        set(dcm,'UpdateFcn',@myupdatefcn)
        
    % AXES TO PLOT THE COLOR SCALE
        if whereToPlot == 1 %plot on main panel
            axes(axes6);cla;hold on
        else
            map(3,2)
        end    
        
    for i = 1:5
        plot(0.95*i-1.8,-3,'o','MarkerFaceColor',couleur(rr(i,2),:));
        if rr(i,1) > 0.
            Notation = sprintf('+%4.3f',rr(i,1));
        else
            Notation = sprintf('%5.3f',rr(i,1));
        end
        text(0.95*i-1.7,-3,Notation,'FontSize',8);
    end
    xlim([-1 3.5]);
    ylim([-7  1]);
        
    guidata(Anneal_fig,data)
        
    end

%----------------------------------------------------------------------------------
function UpdateDisplayZ(hObject, eventdata)
        
data = guidata(Anneal_fig);
        
Ntraces = data.Ntraces;
        
itrace = find(gco == data.rb);
        
% UPDATE SELECTION
iselect = get(gco,'Value');
if iselect == 0
    data.SelectionZ(itrace) = 0;
elseif iselect == 1
    data.SelectionZ(itrace) = 1;
end

% UPDATE DISPLAY
guidata(Anneal_fig,data)

UpdateMeanTrace;

guidata(Anneal_fig,data)
     
DisplayTraces;

guidata(Anneal_fig,data)

Display_Time_Residuals;

guidata(Anneal_fig,data)
Display_Amplitude_Residuals;
                       
%if data.Align == 1; % annealing runned
%    for ii = data.NminZ:data.NmaxZ
%        [ii data.rb(ii).Value]
%        if data.rb(ii) == 0
%          [t0,t1,hpl] = PlotOnTrace2(data.SigFlR(ii).SeisData,-TimeShift,data.SigFlR(ii).HdrData.DELTA,ii-data.NminR+2,'b');
%          set(hpl,'Color','Blue');
%        end
%        set(data.rb(ii),'Visible','off');
%        set(data.rb(ii),'Enable','off');
%        set(data.rb(ii),'Interruptible','off');
%    end
%end

guidata(Anneal_fig,data)
        
% UPDATE DISPLAY
%guidata(Anneal_fig,data)
        
end
       
%----------------------------------------------------------------------------------
function UpdateDisplayR(hObject, eventdata)
        
data = guidata(Anneal_fig);
        
Ntraces = data.Ntraces;
        
itrace = find(gco == data.rb2);
        
% UPDATE SELECTION
iselect = get(gco,'Value');
if iselect == 0
    data.SelectionR(itrace) = 0;
elseif iselect == 1
    data.SelectionR(itrace) = 1;
end

% UPDATE DISPLAY
guidata(Anneal_fig,data)

UpdateCoeffR;
guidata(Anneal_fig,data)

UpdateMeanTrace;
guidata(Anneal_fig,data)
     
% CHOOSE AXES4
%axes(axes4);cla;hold on
DisplayRadial;

guidata(Anneal_fig,data)

Display_Time_Residuals;

guidata(Anneal_fig,data)

Display_Amplitude_Residuals;
guidata(Anneal_fig,data)

end

%----------------------------------------------------------------------------------
function UpdateDisplayT(hObject, eventdata)
        
data = guidata(Anneal_fig);
        
Ntraces = data.Ntraces;
        
itrace = find(gco == data.rb3);
        
% UPDATE SELECTION
iselect = get(gco,'Value');
if iselect == 0
    data.SelectionT(itrace) = 0;
elseif iselect == 1
    data.SelectionT(itrace) = 1;
end

guidata(Anneal_fig,data)

UpdateMeanTrace;

% UPDATE DISPLAY
guidata(Anneal_fig,data)
     
% CHOOSE AXES4
%axes(axes4);cla;hold on
DisplayTransverse;

guidata(Anneal_fig,data)

Display_Time_Residuals;

guidata(Anneal_fig,data)

Display_Amplitude_Residuals;  
guidata(Anneal_fig,data)

end

%----------------------------------------------------------------------------------
function UpdateMeanTrace(hObject, eventdata)
        
data = guidata(Anneal_fig);
        
% GET TIME BEFORE THEORETICAL P ARRIVAL
Tmin = str2double(get(edit1,'String'));

% GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
switch data.selected_comp
    case 1
        Selection = data.SelectionZ;
        SigFl = data.SigFlZ;
    case 2
        Selection = data.SelectionR;
        SigFl = data.SigFlR;
    case 3
        Selection = data.SelectionT;
        SigFl = data.SigFlT;
end
            
Ntraces = data.Ntraces;
IndexSelected = find(Selection);
NbSelected = length(IndexSelected);

dt = data.SigFlZ(1).HdrData.DELTA;



for i = 1:Ntraces
    sigZ(i,:) = SigFl(i).SeisDataAlign;
end

Stack(1,:) = zeros(1,length(sigZ(1,:)));
Npts = length(Stack);
        
for k = 1:NbSelected
    Stack = Stack + sigZ(IndexSelected(k),:);
end
Stack = Stack./NbSelected;
wavelet = Stack;

% Align traces on Stack trace
for i = 1:Ntraces
    if (Selection(i) == 1)
        s = SigFl(i).SeisData(:)';
%        [Cor,Cor_max,tshift] = correl_max(Stack,s,Npts,dt);
        [Cor,Cor_max,tshift] = correl_max_int(Stack,s,Npts,dt,data.tshiftmax);
        sig_align(i,:) = phaseshift(s,Npts,dt,-tshift);
        delay(i) = -tshift;
    else
        sig_align(i,:) = SigFl(i).SeisData(:);
        delay(i) = 0;
    end
    switch data.selected_comp
        case 1
            data.SigFlZ(i).SeisDataAlign = sig_align(i,:);
        case 2
            data.SigFlR(i).SeisDataAlign = sig_align(i,:);
        case 3
            data.SigFlT(i).SeisDataAlign = sig_align(i,:);
    end
end
        
% Update Amplitudes

for i = 1:Ntraces
    sigZ(i,:) = SigFl(i).SeisDataAlign;
    if (Selection(i)==1) 
        s = sigZ(i,:);
        switch data.selected_comp
            case 1
                data.AmpZ(i) = (s*wavelet')./(wavelet*wavelet');
            case 2
                data.AmpZ(i) = (s*wavelet')./(wavelet*wavelet');            
            case 3
                data.AmpZ(i) = (s*wavelet')./(wavelet*wavelet');
        end
    else
        data.AmpZ(i) = 999.;
    end
end

data.TimeDelay = delay;
data.Stack = Stack;
data.MeanTrace = data.Stack;

for i = 1:Ntraces
    % Update travel time residues
    if (Selection(i) == 1)
        res(i) = data.tpick-data.TimeDelay(i)-Tmin;
    else
        res(i) = 0;
    end
end

data.ResMean = sum(res)./NbSelected;
            
for i = 1:Ntraces
    if (Selection(i) == 1)
        data.residu(i) = res(i)-mean(res);
    else
        data.residu(i) = 999.;
    end
end

TimeMean = (0:dt:(length(data.MeanTrace)-1)*dt)';
    
for k = 1:NbSelected
    s = sigZ(IndexSelected(k),:);
    num = Stack*s';
    denom = sqrt(s*s')*sqrt(Stack*Stack');
    data.CoefCor(IndexSelected(k)) = num/denom;
end
        
% UPDATE DISPLAY
guidata(Anneal_fig,data)
        
% CHOOSE AXES1
%axes(axes1);cla;hold on
        
%guidata(Anneal_fig,data)

%DisplayTraces;

%guidata(Anneal_fig,data)

%Display_Time_Residuals;

%Display_Amplitude_Residuals;
                       
%guidata(Anneal_fig,data)
        
end

%----------------------------------------------------------------------------------
function UpdateCoeffR(hObject, eventdata)
        
data = guidata(Anneal_fig);
        
% GET TIME BEFORE THEORETICAL P ARRIVAL
Tmin = str2double(get(edit1,'String'));

% GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
Selection = data.SelectionZ;
Ntraces = data.Ntraces;
IndexSelected = find(Selection);
NbSelected = length(IndexSelected);
        
dt = data.SigFlZ(1).HdrData.DELTA;
        
for i = 1:Ntraces
    sigZ(i,:) = data.SigFlZ(i).SeisDataAlign;
    sigR(i,:) = data.SigFlR(i).SeisDataAlign;
end

wavelet = data.MeanTrace;

% Correlation coefficient between Z and R
for i = 1:Ntraces
    s = sigR(i,:);
    s2 = sigZ(i,:);
    data.CorrR(i) = (s*wavelet')./(sqrt(wavelet*wavelet')*sqrt(s*s'));
    data.AmpR(i) = (s*s2')./(s2*s2');
end

% UPDATE DISPLAY
guidata(Anneal_fig,data)
        
% CHOOSE AXES1
%axes(axes1);cla;hold on
        
%guidata(Anneal_fig,data)

%DisplayTraces;
               
%guidata(Anneal_fig,data)

end
%----------------------------------------------------------------------------------
function Save_Results_Callback(object,event)
        
data = guidata(Anneal_fig);

if (data.Align == 0) ; return; end

Seldir = strcat(data.DirSac,'/Selection');
commande = ['mkdir ',Seldir];
%commande
if (exist(Seldir,'dir') == 0)
  system(commande);
end

fid = fopen([data.DirSac,'/Selection/Residus_P.txt'],'w');
%LINE = ('Station  slat    slon    selev    evlat  evlon    evdep distance azimuth phase ttheo   tres   tshift coherence AmpZ');
LINE = ('Station  slat    slon    selev    evlat  evlon    evdep distance slowness azimuth      phase ttheo   tres cor_elev  tshift coherence AmpZ');
fprintf(fid,'%s\n',LINE);

fid2 = fopen([data.DirSac,'/Selection/Info.txt'],'w');

LINE = sprintf('%s','% FILTER');
fprintf(fid2,'%s\n',LINE);
Filter = get(radiobutton2,'Value');
if Filter == 0
  LINE = sprintf('%s','WWSSN_SP');
  fprintf(fid2,'%s\n',LINE);
else
  LINE = sprintf('%s','BUTTERWORTH');
  fprintf(fid2,'%s\n',LINE);
  LINE = sprintf('%s','% FREQ MIN');
  FrqMin = str2double(get(edit3,'String'));
  LINE = sprintf('%5.3f',FrqMin);
  fprintf(fid2,'%s\n',LINE);
  LINE = sprintf('%s','% FREQ MAX');
  FrqMax = str2double(get(edit4,'String'));
  LINE = sprintf('%5.3f',FrqMax);
  fprintf(fid2,'%s\n',LINE);
end
LINE = sprintf('%s','% TIME BEFORE ARRIVAL');
fprintf(fid2,'%s\n',LINE);
Tmin = str2double(get(edit1,'String'));
LINE = sprintf('%3.0f',Tmin);
fprintf(fid2,'%s\n',LINE);
LINE = sprintf('%s','% TIME AFTER ARRIVAL');
fprintf(fid2,'%s\n',LINE);
Tmax = str2double(get(edit2,'String'));
fprintf(fid2,'%3.0f\n',Tmax);
fclose(fid2);

rsurf = 6371;
deg2km = 2*pi*rsurf/360;
vp = 5.;

for ii = 1:data.Ntraces

  if data.SelectionZ(ii) == 1

    % STATION NAME
    StaName = data.SigFlZ(ii).HdrData.KSTNM;

    % RESIDUAL
    TimeShift = data.TimeDelay(ii);
    residual = data.residu(ii);

    % COHERENCY
    coherency = data.CoefCor(ii);
    corrR = data.CorrR(ii);
    AmpZ = data.AmpZ(ii);
    AmpR = data.AmpR(ii);

    % STATION COORDINATES
    STLA = data.SigFlZ(ii).HdrData.STLA;
    STLO = data.SigFlZ(ii).HdrData.STLO;
    STEL = data.SigFlZ(ii).HdrData.STEL;

    % EVENT COORDINATES
    EVLA = data.SigFlZ(ii).HdrData.EVLA;
    EVLO = data.SigFlZ(ii).HdrData.EVLO;
    EVDP = data.SigFlZ(ii).HdrData.EVDP;

    % THEORETICAL TRAVEL TIME
    theo = data.SigInZ(ii).HdrData.A;

    % DISTANCE
    dist = data.SigInZ(ii).HdrData.GCARC;

    % AZIMUTH
    azi = data.SigInZ(ii).HdrData.BAZ;

    % CORRECTION TOPO
    pp = data.slowness(ii);
    pp = pp/deg2km;
    cosi = sqrt(1.-(pp*vp)^2);
    hcor = STEL/1000./vp*cosi;

    LINE = sprintf('%-6s %7.3f %7.3f %5.0f    %7.3f %7.3f %6.1f %7.3f %7.3f %6.1f %-6s %7.2f  %5.2f  %5.2f %5.2f %6.3f %5.3f',...
    StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,data.slowness(ii),azi,data.Phase,theo,residual,hcor,TimeShift,coherency,AmpZ);
%    LINE = sprintf('%-6s %7.3f %7.3f %5.0f    %7.3f %7.3f %6.1f %7.3f %6.1f %-6s %7.2f  %5.2f  %5.2f %6.3f %5.3f',...
%    StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,residual,TimeShift,coherency,AmpZ);
%    LINE = sprintf('%-6s %7.3f %7.3f %10.1f    %7.3f %7.3f %6.1f %7.3f %6.1f  %-6s  %15.5f  %10.5f  %6.3f %6.3f',...
%    StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,residual,TimeShift,coherency);
    fprintf(fid,'%s\n',LINE);

  end
end
fclose(fid);

fid = fopen([data.DirSac,'/Selection/Selection_R.txt'],'w');
for ii = 1:data.Ntraces
  if data.SelectionR(ii) == 1
    % STATION NAME
    SacFile = char(data.SacFilesR(ii));
    I = findstr('_',SacFile);
    Trace = SacFile(1:I(2)-1);
    RF = strcat(Trace,'_BHR.SAC');

    LINE = sprintf('%-30s %6.3f %6.3f',RF,data.CorrR(ii),data.AmpR(ii));
    fprintf(fid,'%s\n',LINE);
  end
end
fclose(fid);

fid = fopen([data.DirSac,'/Selection/STATIONS'],'w');
for ii = 1:data.Ntraces
    if data.SelectionZ(ii) == 1 || data.SelectionR(ii) == 1
        StaName = data.SigFlZ(ii).HdrData.KSTNM;
        StaNetwk = data.SigFlZ(ii).HdrData.KNETWK;
        STLA = data.SigFlZ(ii).HdrData.STLA;
        STLO = data.SigFlZ(ii).HdrData.STLO;

        LINE = sprintf('%-5s %-3s %7.4f %7.4f 0.0 0.0',StaName, StaNetwk, STLA, STLO);
        fprintf(fid,'%s\n',LINE);
    end
end

fid = fopen([data.DirSac,'/Selection/STATIONS_weight'],'w');
for ii = 1:data.Ntraces
    weight = [0,0,0];
    StaName = data.SigFlZ(ii).HdrData.KSTNM;

    if data.SelectionZ(ii) == 1
        weight(3) = 1;
    end
    
    if data.SelectionR(ii) == 1
        weight(1:2) = [1,1];
    end
    
    LINE = sprintf('%-s %1d %1d %1d',StaName, weight);
    fprintf(fid,'%s\n',LINE);
end

end
%----------------------------------------------------------------------------
end