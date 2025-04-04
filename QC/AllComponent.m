function AllComponent

% SCREEN DEFINITION
set(0, 'Units', 'pixels');
screen = get(0, 'ScreenSize');

% CREATE FIGURE
Comp_fig = figure('position',[50,50,screen(3)-100,screen(4)-150], ...
    'numbertitle','off', ...
    'menubar','none', ...
    'HandleVisibility','callback', ...
    'name','Component Analysis');
hObject = Comp_fig;

% CREATION OF THE GUI DATA STRUCTURE
data = guihandles(Comp_fig);

data.NbDisp = 10;
data.AnnealingRun = zeros(100,1);

% CREATE MENUS
menu1 = uimenu(Comp_fig,'Label','Component');
uimenu(menu1,'Label','Quit', ...
    'Callback','quit');

menu2 = uimenu(Comp_fig,'Label','File');
uimenu(menu2, ...
    'Label','Load Parameter File for Z Selection', ...
    'Tag','Load Parameter File for Z Selection', ...
    'Callback', @LoadParam_Callback);
uimenu(menu2, ...
    'Label','Load Wavelet', ...
    'Tag','Load Wavelet', ...
    'Callback', @LoadWavelet_Callback);
m2 = uimenu(menu2, ...
    'Label','Load Z/N/E Component', ...
    'Tag','openZNE', ...
    'Callback', @openZNE_Callback);
set(m2,'Separator','on');
uimenu(menu2, ...
    'Label','Load Z/R/T Component', ...
    'Tag','openZRT', ...
    'Callback', @openZRT_Callback);
m2 = uimenu(menu2, ...
    'Label','Convert ZNE to ZRT', ...
    'Tag','convertZNE2ZRT', ...
    'Callback', @convertZNE2ZRT_Callback);
set(m2,'Separator','on');

menu3 = uimenu(Comp_fig,'Label','Data Analysis');
uimenu(menu3, ...
    'Label','Clustering Z', ...
    'Tag','Clustering Z', ...
    'Callback', @clusteringZ_Callback);
uimenu(menu3, ...
    'Label','Clustering N / R', ...
    'Tag','Clustering N / R', ...
    'Callback', @clusteringNR_Callback);
uimenu(menu3, ...
    'Label','Clustering E / T', ...
    'Tag','Clustering E / T', ...
    'Callback', @clusteringET_Callback);
m3 = uimenu(menu3, ...
    'Label','Align ZNE / ZRT Component', ...
    'Tag','Align ZNE / ZRT Component', ...
    'Callback', @annealing_Callback);
set(m3,'Separator','on');
m3 = uimenu(menu3, ...
    'Label','Deconvolution Z / R', ...
    'Tag','Deconvolution Z / R', ...
    'Callback', @deconvolution_Callback);
set(m3,'Separator','on'); 

menu4 = uimenu(Comp_fig,'Label','Save Results');
uimenu(menu4, ...
    'Label','Write STATIONS File from TmpSTATIONS File', ...
    'Tag','Write STATIONS File from TmpSTATIONS File', ...
    'Callback', @UpdateStations_Callback);
m4 = uimenu(menu4, ...
    'Label','Save Gather ZNE / ZRT Binary', ...
    'Tag','Save Gather ZNE / ZRT Binary', ...
    'Callback', @SaveGatherBin_Callback);
m4 = uimenu(menu4, ...
    'Label','Save Gather Z Binary', ...
    'Tag','Save Gather Z Binary', ...
    'Callback', @SaveZGatherBin_Callback);
uimenu(menu4, ...
    'Label','Save Gather N / R Binary', ...
    'Tag','Save Gather N / R Binary', ...
    'Callback', @SaveGatherNRBin_Callback);
uimenu(menu4, ...
    'Label','Save Gather E / T Binary', ...
    'Tag','Save Gather E / T Binary', ...
    'Callback', @SaveGatherETBin_Callback);
set(m4,'Separator','on');

% CREATE AXES TO PLOT DATA
% Z COMPONENT
axesZ = axes('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axesZ', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.05 0.10 0.2 0.7]);

% NR COMPONENT
axesNR = axes('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axesNR', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.275 0.10 0.2 0.7]);

% T COMPONENT
axesET = axes('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Tag', 'axesET', ...
    'Box', 'on', ...
    'YlimMode', 'manual', ...
    'Ylim',[0 data.NbDisp+2], ...
    'Ydir', 'reverse', ...
    'HandleVisibility','callback', ...
    'Position',[0.5 0.10 0.2 0.7]);

text1 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text1', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'String', 'Residuals', ...
    'Enable', 'On', ...
    'String', 'Event :', ...
    'HandleVisibility', 'On', ...
    'Position', [0.175 0.90 0.4 0.032], ...
    'Visible', 'Off');
text1b = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text1b', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'String', 'Residuals', ...
    'Enable', 'On', ...
    'String', 'Event :', ...
    'HandleVisibility', 'On', ...
    'Position', [0.175 0.94 0.4 0.032], ...
    'Visible', 'Off');

pushbutton1 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton1', ...
    'Callback', @pushbutton1_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.135 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton2 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton2', ...
    'Callback', @pushbutton2_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.18 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton3 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton3', ...
    'Callback', @pushbutton3_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.09 0.84 0.03 0.04], ...
    'Visible', 'On');

pushbutton4 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton4', ...
    'Callback', @pushbutton4_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.36 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton5 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton5', ...
    'Callback', @pushbutton5_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.405 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton6 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton6', ...
    'Callback', @pushbutton6_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.315 0.84 0.03 0.04], ...
    'Visible', 'On');

pushbutton7 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton7', ...
    'Callback', @pushbutton7_Callback, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white', ...
    'Cdata', imread('sac.img','BMP'), ...
    'ForegroundColor', 'black', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.585 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton8 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton8', ...
    'Callback', @pushbutton8_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('next.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.63 0.84 0.03 0.04], ...
    'Visible', 'On');
pushbutton9 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton6', ...
    'Callback', @pushbutton9_Callback, ...
    'HorizontalAlignment', 'center', ...
    'Cdata', imread('back.img','BMP'), ...
    'BackgroundColor', 'white', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.54 0.84 0.03 0.04], ...
    'Visible', 'On');

% CREATE UIPANEL PARAMETERS
hPanel = uipanel(Comp_fig, ...
    'Title', 'Parameters', ...
    'Position', [0.725 0.1 0.225 0.85]);

text3 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text3', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.875 0.15 0.11], ...
    'Visible', 'On');
popupmenu1 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'PopUpMenu', ...
    'String', 'P', ...
    'Tag', 'popupmenu1', ...
    'HitTest', 'On', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.2 0.875 0.225 0.11], ...
    'Visible', 'On');
text4 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text4', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Dist. Min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.45 0.875 0.2 0.11], ...
    'Visible', 'On');
text5 = uicontrol('Parent', hPanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text5', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Dist. Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.7 0.875 0.2 0.11], ...
    'Visible', 'On');

Zpanel = uipanel('Parent',hPanel, ...
    'Title', 'Parameters for Z', ...
    'Position', [0.05 0.625 0.9 0.3]);

radiobutton1 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton1', ...
    'String', 'Time Window', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.85 0.4 0.125]);
text6 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text6', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Before Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.73 0.275 0.125], ...
    'Visible', 'On');
edit1 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit1', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.73 0.125 0.125], ...
    'Visible', 'On');
text7 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text7', ...
    'HorizontalAlignment', 'left', ...
    'String', 'After Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.525 0.73 0.275 0.125], ...
    'Visible', 'On');
edit2 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit2', ...
    'HorizontalAlignment', 'center', ...
    'String', '10', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.73 0.125 0.125], ...
    'Visible', 'On');

radiobutton2 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton2', ...
    'String', 'Butterworth Filter', ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.55 0.5 0.125]);
text8 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text8', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.43 0.275 0.125], ...
    'Visible', 'On');
edit3 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit3', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.05', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.43 0.125 0.125], ...
    'Visible', 'On');
text9 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text9', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.525 0.43 0.275 0.125], ...
    'Visible', 'On');
edit4 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit4', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.43 0.125 0.125], ...
    'Visible', 'On');

radiobutton3 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton3', ...
    'String', 'Clustering', ...
    'HitTest', 'On', ...
    'Enable', 'On', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.25 0.4 0.125]);
text10 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text10', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Min Corr', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.13 0.275 0.125], ...
    'Visible', 'On');
edit5 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit5', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.65', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.13 0.125 0.125], ...
    'Visible', 'On');

pushbutton10 = uicontrol('Parent', Zpanel, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton10', ...
    'Callback', @pushbutton10_Callback, ...
    'HorizontalAlignment', 'center', ...
    'String', 'Update Z', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.65 0.13 0.3 0.125], ...
    'Visible', 'On');

NRpanel = uipanel('Parent',hPanel, ...
    'Title', 'Parameters for N / R', ...
    'Position', [0.05 0.325 0.9 0.3]);

radiobutton4 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton4', ...
    'String', 'Time Window', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.85 0.4 0.11]);
text11 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text11', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Before Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.73 0.275 0.11], ...
    'Visible', 'On');
edit6 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit6', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.73 0.11 0.11], ...
    'Visible', 'On');
text12 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text12', ...
    'HorizontalAlignment', 'left', ...
    'String', 'After Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.5 0.73 0.275 0.11], ...
    'Visible', 'On');
edit7 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit7', ...
    'HorizontalAlignment', 'center', ...
    'String', '10', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.73 0.11 0.11], ...
    'Visible', 'On');

radiobutton5 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton5', ...
    'String', 'Butterworth Filter', ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.55 0.5 0.125]);
text13 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text13', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.43 0.275 0.125], ...
    'Visible', 'On');
edit8 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit8', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.05', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.43 0.125 0.125], ...
    'Visible', 'On');
text14 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text14', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.525 0.43 0.275 0.125], ...
    'Visible', 'On');
edit9 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit9', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.43 0.125 0.125], ...
    'Visible', 'On');

radiobutton6 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton6', ...
    'String', 'Clustering', ...
    'HitTest', 'On', ...
    'Enable', 'On', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.25 0.4 0.125]);
text15 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text15', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Min Corr', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.13 0.275 0.125], ...
    'Visible', 'On');
edit10 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit10', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.65', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.13 0.125 0.125], ...
    'Visible', 'On');

pushbutton11 = uicontrol('Parent', NRpanel, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton11', ...
    'Callback', @pushbutton11_Callback, ...
    'HorizontalAlignment', 'center', ...
    'String', 'Update N / R', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.65 0.13 0.3 0.125], ...
    'Visible', 'On');

ETpanel = uipanel('Parent',hPanel, ...
    'Title', 'Parameters for E / T', ...
    'Position', [0.05 0.025 0.9 0.3]);

radiobutton7 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton7', ...
    'String', 'Time Window', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.85 0.4 0.11]);
text16 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text16', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Before Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.73 0.275 0.11], ...
    'Visible', 'On');
edit11 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit11', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.73 0.11 0.11], ...
    'Visible', 'On');
text17 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text17', ...
    'HorizontalAlignment', 'left', ...
    'String', 'After Phase', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.5 0.73 0.275 0.11], ...
    'Visible', 'On');
edit12 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit12', ...
    'HorizontalAlignment', 'center', ...
    'String', '10', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.73 0.11 0.11], ...
    'Visible', 'On');

radiobutton8 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton8', ...
    'String', 'Butterworth Filter', ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.55 0.5 0.125]);
text18 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text18', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Min', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.43 0.275 0.125], ...
    'Visible', 'On');
edit13 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit13', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.05', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.43 0.125 0.125], ...
    'Visible', 'On');
text19 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text19', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Freq Max', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.525 0.43 0.275 0.125], ...
    'Visible', 'On');
edit14 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit14', ...
    'HorizontalAlignment', 'center', ...
    'String', '5', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.8 0.43 0.125 0.125], ...
    'Visible', 'On');

radiobutton9 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'Radio', ...
    'Tag', 'radiobutton9', ...
    'String', 'Clustering', ...
    'HitTest', 'On', ...
    'Enable', 'On', ...
    'Value', 1, ...
    'Interruptible', 'On', ...
    'Position', [0.05 0.25 0.4 0.125]);
text20 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text20', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Min Corr', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.05 0.13 0.275 0.125], ...
    'Visible', 'On');
edit15 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'edit', ...
    'Tag', 'edit15', ...
    'HorizontalAlignment', 'center', ...
    'String', '0.65', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.35 0.13 0.125 0.125], ...
    'Visible', 'On');

pushbutton12 = uicontrol('Parent', ETpanel, ...
    'Units', 'normalized', ...
    'Style', 'pushbutton', ...
    'Tag', 'pushbutton12', ...
    'Callback', @pushbutton12_Callback, ...
    'HorizontalAlignment', 'center', ...
    'String', 'Update E / T', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.65 0.13 0.3 0.125], ...
    'Visible', 'On');


% CREATE POPUPMENU CLUSTERS
listbox1 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'String', '1', ...
    'Style', 'listbox', ...
    'Tag', 'listbox1', ...
    'Position', [0.93 0.775 0.04 0.125], ...
    'Visible', 'Off');
text12 = uicontrol('Parent', Comp_fig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Tag', 'text12', ...
    'HorizontalAlignment', 'center', ...
    'String', 'Cluster', ...
    'Enable', 'On', ...
    'HandleVisibility', 'On', ...
    'Position', [0.925 0.91 0.05 0.025], ...
    'Visible', 'Off');

% DEFINITION OF VARIABLES
data.clust = 0;
data.NstaBlack = 0;
data.run_annealing = '/Users/goubet/Documents/Codes/AnealingWfV0.2'; % annealing code
%data.Data_Dir = '/Volumes/data/PYROPE/P';                     % default data directory
data.Data_Dir = '/Users/goubet/Pyrope_DATA';  % default data directory
data.NameDir = '201205242247';
data.PickingSyn = zeros(100,1);
data.Param = zeros(100,1);
data.deconvolution = zeros(100,1);
data.ZNE = zeros(100,1);
data.ZRT = zeros(100,1);
% To be customized later
data.NbDisp = 10;

% AllPhases = {'p';'s';'P';'S';'pP';'sS';'Pn';'Sn';'PcP';'ScS';'Pdiff';'Sdiff';...
%            'PKP';'SKS';'PKiKP';'SKiKS';'PKIKP';'SKIKS'};
AllPhases = {'P'};
set(popupmenu1,'String',AllPhases);

guidata(Comp_fig,data)

% -------------------------------------------------------------------------
% --- Load Parameter File
    function LoadParam_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        [ParamFile,Path] = uigetfile(...
            {'*.*','All Files'}, ...
            'Select Your Temporary STATIONS File');

        % CHECK FOR DATA_COMPONENTS PARAMETER
        fid = fopen([Path ParamFile]);
        Param = textscan(fid,'%s	%f');
        
        station = Param{1};
        
        SelectionZ = zeros(size(Param{2},1),size(Param{2},2));
        SelectionZ = Param{2};
             
        fclose(fid);
        
        data.Class(1).SelectionZ(1:length(SelectionZ)) = SelectionZ;

        data.Param(ic) = 1;
        
        mess = msgbox('Param File Loaded');
        
        guidata(Comp_fig,data);
        
    end

% -------------------------------------------------------------------------
% --- Load Wavelet File
    function LoadWavelet_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        [WaveletFile,Path] = uigetfile({'*.*','All Files'},data.Data_Dir);
        fid = fopen([Path WaveletFile]);
        W = textscan(fid,'%f');
        data.WaveletMean = W{1};
        class(data.WaveletMean)
        fclose(fid);
        
        fst = figure('numbertitle','off', ...
            'menubar','none', ...
            'toolbar','figure', ...
            'name','Estimated Wavelet');
        axst = axes('Parent',fst);
        
        axes(axst);hold on
        PlotOnTrace(-data.WaveletMean,0,0.05,1)
        
        guidata(Comp_fig,data);
        
    end

% -------------------------------------------------------------------------
% --- Load Z/N/E Component
    function openZNE_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        SacTagZ = 'Z.sac'; % extension of files to be read
        SacTagN = 'N.sac';
        SacTagE = 'E.sac';
        
        % GET CHOSEN PHASE
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        Phase = Phases{ii};
        
        % CHOOSE SAC FILE DIRECTORY
        data.DirSac = uigetdir(data.Data_Dir);
        
        % READ Z SAC FILES
        [StrcOutZ,d0,d1,distance,t0,t1,I] = ReadAllSacFile(data.DirSac,SacTagZ,Phase);
        
        t1 = 0;
        for i = 1:length(I)
            t1 = max(t1,StrcOutZ(i).HdrData.B-StrcOutZ(i).HdrData.O+(StrcOutZ(i).HdrData.NPTS-1)*StrcOutZ(i).HdrData.DELTA);
        end
        
        % STORE DATA
        data.SigInZ = StrcOutZ;
        data.distmin = d0;
        data.distmax = d1;
        data.distance = distance;
        data.I = I;
        
        % READ R SAC FILES
        [StrcOutN,d0N,d1N,distance,t0N,t1N,I] = ReadAllSacFile(data.DirSac,SacTagN,Phase);
        
        % STORE DATA
        data.SigInN = StrcOutN;
        
        % READ T SAC FILES
        [StrcOutE,d0E,d1E,distance,t0E,t1E,I] = ReadAllSacFile(data.DirSac,SacTagE,Phase);
        
        % STORE DATA
        data.SigInE = StrcOutE;
        
        Longitude = [];
        Latitude = [];
        
        for k = 1:length(StrcOutZ)
            Longitude = [Longitude ; data.SigInZ(k).HdrData.STLO];
            Latitude = [Latitude ; data.SigInZ(k).HdrData.STLA];
        end
        
        data.lonmin = min(Longitude);
        data.lonmax = max(Longitude);
        data.latmin = min(Latitude);
        data.latmax = max(Latitude);
        
        distmin = sprintf('Dist Min: %4.1f',d0);
        distmax = sprintf('Dist Max: %4.1f',d1);
        
        ClockFile = load('/Users/goubet/DSM_FOR_SPECFEM3D/Preprocessing_MATLAB_Interface/clock.mat');
        ClockCor = ClockFile.clock;
        ClockCorSTA = ClockFile.clock.sta;
        ClockCorVAL = ClockFile.clock.dti;
        
        STA2Correct = cellfun(@(x) x(7:end), ClockCorSTA, 'UniformOutput', false);
        
        nfft = 2^nextpow2(length(data.SigInZ(1).SeisData));
         
        for k = 1:length(StrcOutZ)
            indexSTA2Correct = find(strcmp(data.SigInZ(k).HdrData.KSTNM,STA2Correct));
            if (isempty(indexSTA2Correct) == 0)
                correction(k) = ClockCorrection(STA2Correct,data.NameDir,data.SigInZ(k).HdrData.KSTNM,indexSTA2Correct,ClockFile);
            else
                correction(k) = 0;
            end
        end

        data.Correction = round(correction);
        
        % keyboard
        
        evlat = num2str(data.SigInZ(1).HdrData.EVLA);
        evlon = num2str(data.SigInZ(1).HdrData.EVLO);
        evdep = num2str(data.SigInZ(1).HdrData.EVDP);
        evdate = strcat(num2str(data.SigInZ(1).HdrData.NZJDAY),'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
        mag = num2str(data.SigInZ(1).HdrData.MAG);
        
        DateString = {num2str(data.SigInZ(1).HdrData.NZJDAY)};
        t = cellstr(datetime(DateString,'InputFormat','D','Format','MM/dd'));
        t = strcat(t,'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
        data.t = t{1};
        
        guidata(Comp_fig,data);
        
        set(text1,'Visible','On');
        set(text1b,'Visible','On');
        str1 = ['Latitude : ' evlat char(176) '  Longitude : ' evlon char(176) '  Depth : ' evdep ' km' ' Mag : ' mag];
        str1b = ['Date : ' t{1}];
        set(text1,'string',str1);
        set(text1b,'string',str1b);
        
        set(text4,'string',strcat(distmin,char(176)));
        set(text5,'string',strcat(distmax,char(176)));
        
        % CHOOSE PHASE
        % phases = 'P S pP sS PP PPP SS SSS PcP ScS Pdiff Sdiff PKIKP SKIKS SKS';
        phases = 'P';
        
        % PHASES FOR DIST MIN
        tt0 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d0);
        
        % PHASES FOR DIST MAX
        tt1 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d1);

        [d0 d1];     
       
        k = 0;
        for i = 1:size(tt0,2)
            if tt0(i).time > t0 && tt0(i).time < t1
                k = k+1;
%                        PhasesForDistMin{k} = tt0(i).phaseName;
                PhasesForDistMin{k} = tt0(i).phase;
            end
        end
        
        k = 0;
        for i = 1:size(tt1,2)
            if tt1(i).time > t0 && tt1(i).time < t1
                k = k+1;
                %        PhasesForDistMax{k} = tt1(i).phaseName;
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
        [Selection,ok] = listdlg('PromptString','Choose Phase', ...
            'SelectionMode','single','ListString',PhasesPot);
        
        % DEFAULT PHASE IS THE FIRST ONE
        if ok ~= 1
            Selection = 1;
        end
        
        % SET SELECTABLE PHASES IN MENU
        set(popupmenu1,'String',PhasesPot);
        set(popupmenu1,'Value',Selection);
        
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
        h = waitbar(0,'Filtering Z Component');
        data.SigZ = [];

        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));

        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbZ)
                set(data.rbZ(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
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
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInZ(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInZ(itrace).SeisData)-1)*data.SigInZ(itrace).HdrData.DELTA;
            Time = Time+data.SigInZ(itrace).HdrData.B-data.SigInZ(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInZ(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInZ(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInZ(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInZ(itrace).HdrData.KSTNM;
                    
                    SigWinZ = zeros(NsamplesTot,1);
                    data.SigFlZ(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0Z = filtbuth_hp(FrqMin,2,deltat,data.SigInZ(itrace).SeisData');
                        Fdata1Z = filtbuth_lp(FrqMax,2,deltat,Fdata0Z);
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(ii).SeisData = SigWinZ';
                    else % wwssn filter
                        Fdata0Z = data.SigInZ(itrace).SeisData-mean(data.SigInZ(itrace).SeisData(i0:i1));
                        Fdata1Z = wwssn_sp(Fdata0Z');
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(itrace).SeisData = SigWinZ';
                    end
                    
                    if length(data.SigFlZ(itrace).SeisData) == 0;
                        data.SigFlZ(itrace).SeisData = zeros(1,size(data.SigZ,1));
                    end
                    data.SigZ = [data.SigZ,data.SigFlZ(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigZ = [data.SigZ, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlZ(itrace).SeisData = data.SigInZ(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInZ(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        Tmin = str2double(get(edit6,'String'));
        Tmax = str2double(get(edit7,'String'));
        FrqMin = str2double(get(edit8,'String'));
        FrqMax = str2double(get(edit9,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton4,'Value');
        Filter = get(radiobutton5,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        %  ----
        h = waitbar(0,'Filtering N Component');
        data.SigN = [];
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbN)
                set(data.rbN(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % NUMBER OF SAMPLES IN TIME WINDOW
        if Window == 1
            NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInN(1).HdrData.DELTA);
        else
            NsamplesTot = length(data.SigInN(1).SeisData);
        end
        
        % INITIALIZE TRACE COUNTER
        ii = 0;
        
        for itrace = 1:data.Ntraces
            
            waitbar(itrace/data.Ntraces);
            
            % COPY DATA
            data.SigFlN(itrace).HdrData = data.SigInN(itrace).HdrData;
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInN(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInN(itrace).SeisData)-1)*data.SigInN(itrace).HdrData.DELTA;
            Time = Time+data.SigInN(itrace).HdrData.B-data.SigInN(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInN(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInN(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
                    data.SigFlN(itrace).HdrData.A = Ptheo;
                    data.SigInN(itrace).HdrData.A = Ptheo;
                    
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInN(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInN(itrace).HdrData.KSTNM;
                    
                    SigWinN = zeros(NsamplesTot,1);
                    data.SigFlN(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0N = filtbuth_hp(FrqMin,2,deltat,data.SigInN(itrace).SeisData');
                        Fdata1N = filtbuth_lp(FrqMax,2,deltat,Fdata0N);
                        SigWinN(ndeb:nfin) = Fdata1N(i0:i1);
                        data.SigFlN(ii).SeisData = SigWinN';
                    else % wwssn filter
                        Fdata0N = data.SigInN(itrace).SeisData-mean(data.SigInN(itrace).SeisData(i0:i1));
                        Fdata1N = wwssn_sp(Fdata0N');
                        SigWinN(ndeb:nfin) = Fdata1N(i0:i1);
                        data.SigFlN(itrace).SeisData = SigWinN';
                    end
                    
                    if length(data.SigFlN(itrace).SeisData) == 0;
                        data.SigFlN(itrace).SeisData = zeros(1,size(data.SigN,1));
                    end
                    data.SigN = [data.SigN,data.SigFlN(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigN = [data.SigN, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlN(itrace).SeisData = data.SigInN(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInN(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        Tmin = str2double(get(edit11,'String'));
        Tmax = str2double(get(edit12,'String'));
        FrqMin = str2double(get(edit13,'String'));
        FrqMax = str2double(get(edit14,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton7,'Value');
        Filter = get(radiobutton8,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        %  ----
        h = waitbar(0,'Filtering E Component');
        data.SigE = [];
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbE)
                set(data.rbE(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % NUMBER OF SAMPLES IN TIME WINDOW
        if Window == 1
            NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInE(1).HdrData.DELTA);
        else
            NsamplesTot = length(data.SigInE(1).SeisData);
        end
        
        % INITIALIZE TRACE COUNTER
        ii = 0;
        
        for itrace = 1:data.Ntraces
            
            waitbar(itrace/data.Ntraces);
            
            % COPY DATA
            data.SigFlE(itrace).HdrData = data.SigInE(itrace).HdrData;
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInE(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInE(itrace).SeisData)-1)*data.SigInE(itrace).HdrData.DELTA;
            Time = Time+data.SigInE(itrace).HdrData.B-data.SigInE(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInE(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInE(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
                    data.SigFlE(itrace).HdrData.A = Ptheo;
                    data.SigInE(itrace).HdrData.A = Ptheo;
                    
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInE(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInE(itrace).HdrData.KSTNM;
                    
                    SigWinE = zeros(NsamplesTot,1);
                    data.SigFlE(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0E = filtbuth_hp(FrqMin,2,deltat,data.SigInE(itrace).SeisData');
                        Fdata1E = filtbuth_lp(FrqMax,2,deltat,Fdata0E);
                        SigWinE(ndeb:nfin) = Fdata1E(i0:i1);
                        data.SigFlE(ii).SeisData = SigWinE';
                    else % wwssn filter
                        Fdata0E = data.SigInE(itrace).SeisData-mean(data.SigInE(itrace).SeisData(i0:i1));
                        Fdata1E = wwssn_sp(Fdata0E');
                        SigWinE(ndeb:nfin) = Fdata1E(i0:i1);
                        data.SigFlE(itrace).SeisData = SigWinE';
                    end
                    
                    if length(data.SigFlE(itrace).SeisData) == 0;
                        data.SigFlE(itrace).SeisData = zeros(1,size(data.SigE,1));
                    end
                    data.SigE = [data.SigE,data.SigFlE(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigE = [data.SigE, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlE(itrace).SeisData = data.SigInE(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInE(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        data.Ntraces = ii;
        data.AnnealingRun = zeros(100,1);
        data.deconvolution = zeros(100,1);
        if data.Param == 0
            data.Class(1).SelectionZ(1:data.Ntraces) = 1;
        end
      
        data.Class(1).IndZ = 1:data.Ntraces;
        data.Class(1).SelectionN(1:data.Ntraces) = 1;
        data.Class(1).IndN = 1:data.Ntraces;
        data.Class(1).SelectionE(1:data.Ntraces) = 1;
        data.Class(1).IndE = 1:data.Ntraces;
        
        axes(axesZ); cla; hold off;
        axes(axesNR); cla; hold off;
        axes(axesET); cla; hold off;
        set(listbox1,'String','1','Value',1);       
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NminN = 1;
        data.NminE = 1;
        data.NmaxZ = min(data.NbDisp,data.Ntraces);
        data.NmaxN = min(data.NbDisp,data.Ntraces);
        data.NmaxE = min(data.NbDisp,data.Ntraces);
        
        % STORE INDICES OF TRACES
        data.CurrentClassZ = data.Class(1).IndZ;
        data.CurrentClassN = data.Class(1).IndN;
        data.CurrentClassE = data.Class(1).IndE;
        
        % STORE WHICH COMPONENT TYPE HAD BEEN LOADED
        data.ZNE(ic) = 1;
        
        % CHOOSE AXES1
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% -------------------------------------------------------------------------
% --- Load Z/R/T Component
    function openZRT_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        SacTagZ = 'Z.sac'; % extension of files to be read
        SacTagR = 'R.sac';
        SacTagT = 'T.sac';
        
        % GET CHOSEN PHASE
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        Phase = Phases{ii};
        
        % CHOOSE SAC FILE DIRECTORY
        data.DirSac = uigetdir(data.Data_Dir);
        
        % READ Z SAC FILES
        [StrcOut,d0,d1,distance,t0,t1,I] = ReadAllSacFile(data.DirSac,SacTagZ,Phase);
        
        % STORE DATA
        data.SigInZ = StrcOut;
        data.distmin = d0;
        data.distmax = d1;
        data.distance = distance;
        data.I = I;
        
        % READ R SAC FILES
        [StrcOut,d0,d1,distance,t0,t1,I] = ReadAllSacFile(data.DirSac,SacTagR,Phase);
        
        % STORE DATA
        data.SigInR = StrcOut;
        
        % READ T SAC FILES
        [StrcOut,d0,d1,distance,t0,t1,I] = ReadAllSacFile(data.DirSac,SacTagT,Phase);
        
        % STORE DATA
        data.SigInT = StrcOut;
        
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
        
        ClockFile = load('/Users/goubet/Documents/Codes/MATLAB/wavelet_estimation_20120524/clock.mat');
        ClockCor = ClockFile.clock;
        ClockCorSTA = ClockFile.clock.sta;
        ClockCorVAL = ClockFile.clock.dti;
        
        STA2Correct = cellfun(@(x) x(7:end), ClockCorSTA, 'UniformOutput', false);
        
        nfft = 2^nextpow2(length(data.SigInZ(1).SeisData));
         
        for k = 1:length(StrcOut)
            indexSTA2Correct = find(strcmp(data.SigInZ(k).HdrData.KSTNM,STA2Correct));
            if (isempty(indexSTA2Correct) == 0)
                correction(k) = ClockCorrection(STA2Correct,data.NameDir,data.SigInZ(k).HdrData.KSTNM,indexSTA2Correct,ClockFile);
            else
                correction(k) = 0;
            end
        end

        data.Correction = round(correction);
        
        % keyboard
        
        evlat = num2str(data.SigInZ(1).HdrData.EVLA);
        evlon = num2str(data.SigInZ(1).HdrData.EVLO);
        evdep = num2str(data.SigInZ(1).HdrData.EVDP);
        evdate = strcat(num2str(data.SigInZ(1).HdrData.NZJDAY),'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
        
                DateString = {num2str(data.SigInZ(1).HdrData.NZJDAY)};
        t = cellstr(datetime(DateString,'InputFormat','D','Format','MM/dd'));
        t = strcat(t,'/',num2str(data.SigInZ(1).HdrData.NZYEAR));
        data.t = t{1};
        
        guidata(Comp_fig,data);
        
        set(text1,'Visible','On');
        set(text1b,'Visible','On');
        str1 = ['Latitude : ' evlat char(176) '  Longitude : ' evlon char(176) '  Depth : ' evdep ' km'];
        str1b = ['Date : ' t{1}];
        set(text1,'string',str1);
        set(text1b,'string',str1b);
        
        set(text4,'string',strcat(distmin,char(176)));
        set(text5,'string',strcat(distmax,char(176)));
        
        % CHOOSE PHASE
        % phases = 'P S pP sS PP PPP SS SSS PcP ScS Pdiff Sdiff PKIKP SKIKS SKS';
        phases = 'P';
        
        % PHASES FOR DIST MIN
        tt0 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d0);
        
        % PHASES FOR DIST MAX
        tt1 = tauptime('mod','ak135','dep',data.SigInZ(1).HdrData.EVDP,'ph',phases,'deg',d1);
        
        [d0 d1];
        
        k = 0;
        for i = 1:size(tt0,2)
            if tt0(i).time > t0 && tt0(i).time < t1
                k = k+1;
                %        PhasesForDistMin{k} = tt0(i).phaseName;
                PhasesForDistMin{k} = tt0(i).phase;
            end
        end
        
        k = 0;
        for i = 1:size(tt1,2)
            if tt1(i).time > t0 && tt1(i).time < t1
                k = k+1;
                %        PhasesForDistMax{k} = tt1(i).phaseName;
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
        [Selection,ok] = listdlg('PromptString','Choose Phase', ...
            'SelectionMode','single','ListString',PhasesPot);
        
        % DEFAULT PHASE IS THE FIRST ONE
        if ok ~= 1
            Selection = 1;
        end
        
        % SET SELECTABLE PHASES IN MENU
        set(popupmenu1,'String',PhasesPot);
        set(popupmenu1,'Value',Selection);
        
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
        h = waitbar(0,'Filtering Z Component');
        data.SigZ = [];

        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));

        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbZ)
                set(data.rbZ(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
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
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInZ(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInZ(itrace).SeisData)-1)*data.SigInZ(itrace).HdrData.DELTA;
            Time = Time+data.SigInZ(itrace).HdrData.B-data.SigInZ(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInZ(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInZ(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInZ(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInZ(itrace).HdrData.KSTNM;
                    
                    SigWinZ = zeros(NsamplesTot,1);
                    data.SigFlZ(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0Z = filtbuth_hp(FrqMin,2,deltat,data.SigInZ(itrace).SeisData');
                        Fdata1Z = filtbuth_lp(FrqMax,2,deltat,Fdata0Z);
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(ii).SeisData = SigWinZ';
                    else % wwssn filter
                        Fdata0Z = data.SigInZ(itrace).SeisData-mean(data.SigInZ(itrace).SeisData(i0:i1));
                        Fdata1Z = wwssn_sp(Fdata0Z');
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(itrace).SeisData = SigWinZ';
                    end
                    
                    if length(data.SigFlZ(itrace).SeisData) == 0;
                        data.SigFlZ(itrace).SeisData = zeros(1,size(data.SigZ,1));
                    end
                    data.SigZ = [data.SigZ,data.SigFlZ(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigZ = [data.SigZ, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlZ(itrace).SeisData = data.SigInZ(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInZ(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        Tmin = str2double(get(edit6,'String'));
        Tmax = str2double(get(edit7,'String'));
        FrqMin = str2double(get(edit8,'String'));
        FrqMax = str2double(get(edit9,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton4,'Value');
        Filter = get(radiobutton5,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        %  ----
        h = waitbar(0,'Filtering R Component');
        data.SigR = [];
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbR)
                set(data.rbR(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % NUMBER OF SAMPLES IN TIME WINDOW
        if Window == 1
            NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInR(1).HdrData.DELTA);
        else
            NsamplesTot = length(data.SigInR(1).SeisData);
        end
        
        % INITIALIZE TRACE COUNTER
        ii = 0;
        
        for itrace = 1:data.Ntraces
            
            waitbar(itrace/data.Ntraces);
            
            % COPY DATA
            data.SigFlR(itrace).HdrData = data.SigInR(itrace).HdrData;
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInR(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInR(itrace).SeisData)-1)*data.SigInR(itrace).HdrData.DELTA;
            Time = Time+data.SigInR(itrace).HdrData.B-data.SigInR(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInR(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInR(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
                    data.SigFlR(itrace).HdrData.A = Ptheo;
                    data.SigInR(itrace).HdrData.A = Ptheo;
                    
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInR(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInR(itrace).HdrData.KSTNM;
                    
                    SigWinR = zeros(NsamplesTot,1);
                    data.SigFlR(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0R = filtbuth_hp(FrqMin,2,deltat,data.SigInR(itrace).SeisData');
                        Fdata1R = filtbuth_lp(FrqMax,2,deltat,Fdata0R);
                        SigWinR(ndeb:nfin) = Fdata1R(i0:i1);
                        data.SigFlR(ii).SeisData = SigWinR';
                    else % wwssn filter
                        Fdata0R = data.SigInR(itrace).SeisData-mean(data.SigInR(itrace).SeisData(i0:i1));
                        Fdata1R = wwssn_sp(Fdata0R');
                        SigWinR(ndeb:nfin) = Fdata1R(i0:i1);
                        data.SigFlR(itrace).SeisData = SigWinR';
                    end
                    
                    if length(data.SigFlR(itrace).SeisData) == 0;
                        data.SigFlR(itrace).SeisData = zeros(1,size(data.SigR,1));
                    end
                    data.SigR = [data.SigR,data.SigFlR(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigR = [data.SigR, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlR(itrace).SeisData = data.SigInR(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInR(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        Tmin = str2double(get(edit11,'String'));
        Tmax = str2double(get(edit12,'String'));
        FrqMin = str2double(get(edit13,'String'));
        FrqMax = str2double(get(edit14,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton7,'Value');
        Filter = get(radiobutton8,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        %  ----
        h = waitbar(0,'Filtering T Component');
        data.SigT = [];
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbT)
                set(data.rb(itraceT),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % NUMBER OF SAMPLES IN TIME WINDOW
        if Window == 1
            NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInT(1).HdrData.DELTA);
        else
            NsamplesTot = length(data.SigInT(1).SeisData);
        end
        
        % INITIALIZE TRACE COUNTER
        ii = 0;
        
        for itrace = 1:data.Ntraces
            
            waitbar(itrace/data.Ntraces);
            
            % COPY DATA
            data.SigFlT(itrace).HdrData = data.SigInT(itrace).HdrData;
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInT(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInT(itrace).SeisData)-1)*data.SigInT(itrace).HdrData.DELTA;
            Time = Time+data.SigInT(itrace).HdrData.B-data.SigInT(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInT(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInT(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
                    data.SigFlT(itrace).HdrData.A = Ptheo;
                    data.SigInT(itrace).HdrData.A = Ptheo;
                    
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInT(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInT(itrace).HdrData.KSTNM;
                    
                    SigWinT = zeros(NsamplesTot,1);
                    data.SigFlT(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0T = filtbuth_hp(FrqMin,2,deltat,data.SigInT(itrace).SeisData');
                        Fdata1T = filtbuth_lp(FrqMax,2,deltat,Fdata0T);
                        SigWinT(ndeb:nfin) = Fdata1T(i0:i1);
                        data.SigFlT(ii).SeisData = SigWinT';
                    else % wwssn filter
                        Fdata0T = data.SigInT(itrace).SeisData-mean(data.SigInT(itrace).SeisData(i0:i1));
                        Fdata1T = wwssn_sp(Fdata0T');
                        SigWinT(ndeb:nfin) = Fdata1T(i0:i1);
                        data.SigFlT(itrace).SeisData = SigWinT';
                    end
                    
                    if length(data.SigFlT(itrace).SeisData) == 0;
                        data.SigFlT(itrace).SeisData = zeros(1,size(data.SigT,1));
                    end
                    data.SigT = [data.SigT,data.SigFlT(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigT = [data.SigT, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlT(itrace).SeisData = data.SigInT(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInT(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        data.Ntraces = ii;
        data.AnnealingRun = zeros(100,1);
        data.deconvolution = zeros(100,1);
        if data.Param == 0
            data.Class(1).SelectionZ(1:data.Ntraces) = 1;
        end
        
        data.Class(1).IndZ = 1:data.Ntraces;
        data.Class(1).SelectionR(1:data.Ntraces) = 1;
        data.Class(1).IndR = 1:data.Ntraces;
        data.Class(1).SelectionT(1:data.Ntraces) = 1;
        data.Class(1).IndT = 1:data.Ntraces;
        
        axes(axesZ); cla; hold off;
        axes(axesNR); cla; hold off;
        axes(axesET); cla; hold off;
        set(listbox1,'String','1','Value',1);       
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NminR = 1;
        data.NminT = 1;
        data.NmaxZ = min(data.NbDisp,data.Ntraces);
        data.NmaxR = min(data.NbDisp,data.Ntraces);
        data.NmaxT = min(data.NbDisp,data.Ntraces);
        
        % STORE INDICES OF TRACES
        data.CurrentClassZ = data.Class(1).IndZ;
        data.CurrentClassR = data.Class(1).IndR;
        data.CurrentClassT = data.Class(1).IndT;
        
        % STORE WHICH COMPONENT TYPE HAD BEEN LOADED
        data.ZRT(ic) = 1;
        
        % CHOOSE AXES1
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% -------------------------------------------------------------------------
    function DisplayZComponent
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % TIME BEFORE THEORETICAL ARRIVAL TIME
        TimeWindowBegin = str2double(get(edit1,'String'));
        
        % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
        Selection = data.Class(ic).SelectionZ;
        class(Selection);
        
        % TIME
        Tmax = 0;
        Tmin = 1000;
        
        % loop over 10 events in cluster.
        for ii = data.NminZ:data.NmaxZ
            
            % GET TRACE INDEX
            i = data.CurrentClassZ(ii);

            if (data.AnnealingRun(ic) == 1) ;
                if data.Correction(i) < 0
                    TimeShift = data.residu(i)+data.Correction(i);
                else
                    TimeShift = data.residu(i)-data.Correction(i);
                end
            else
                if data.Correction(i) < 0
                    TimeShift = +data.Correction(i);
                else
                    TimeShift = -data.Correction(i);
                end
            end
            
            % STATION NAME
            StaName = [data.SigFlZ(i).HdrData.KSTNM];
            
            [t0,t1,hpl] = PlotOnTrace(-data.SigFlZ(i).SeisData,-TimeShift,data.SigFlZ(i).HdrData.DELTA,ii-data.NminZ+2);
            data.DispTraceZ(ii) = hpl;
            Tmax = max(Tmax,t1);
            Tmin = min(Tmin,t0);
            
            % ADD STATION NAME
            text(Tmin-3.5,ii-data.NminZ+1.5,StaName, ...
                'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
            
            if Selection(i) == 0
                
                set(hpl,'Color','Blue');
                
                if (data.AnnealingRun(ic) == 1) | data.Param(ic) == 1; % annealing runned
                    % ADD RADIOBUTTON
                    data.rbZ(ii) = uicontrol( ...
                        'Units', 'normalized', ...
                        'Style', 'Radio', ...
                        'HitTest', 'On', ...
                        'Enable', 'On', ...
                        'Value', 0, ...
                        'Visible', 'On', ...
                        'HandleVisibility', 'On', ...
                        'Callback', @UpdateZDisplay, ...
                        'Interruptible', 'On', ...
                        'Position', [0.02 0.8-(ii-data.NminZ+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                end
                
            else
                
                if (data.AnnealingRun(ic) == 1) %| data.Param(ic) == 1; % annealing runned
                    
                    % ADD RADIOBUTTON
                    data.rbZ(ii) = uicontrol( ...
                        'Units', 'normalized', ...
                        'Style', 'Radio', ...
                        'HitTest', 'On', ...
                        'Enable', 'On', ...
                        'Value', 1, ...
                        'Visible', 'On', ...
                        'HandleVisibility', 'On', ...
                        'Callback', @UpdateZDisplay, ...
                        'Interruptible', 'On', ...
                        'Position', [0.02 0.8-(ii-data.NminZ+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                    
                    % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
                    % EACH TRACE
                    residual = data.residu(i);
                    RESIDU = num2str(residual,'%4.3f');
                    text(Tmin-0.75,ii-data.NminZ+1.85,RESIDU,...
                        'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    
                    Coef = data.CoefCorZ(i);
                    COEF = num2str(Coef,'%4.3f');
                    text(Tmin-6.5,ii-data.NminZ+2,COEF,...
                        'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    text(Tmin-7,1,'R^2',...
                        'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

                    % PLOT THEORETICAL ARRIVAL TIME
                    plot([data.SigFlZ(i).HdrData.A-data.SigFlZ(i).HdrData.B data.SigFlZ(i).HdrData.A-data.SigFlZ(i).HdrData.B]-TimeShift,[ii-data.NminZ+1.5, ii-data.NminZ+2.5],'g');
                                       
                else  % ANNEALING NOT RUNNED
                    % add station Name
                    text(Tmin-3.5,ii-data.NminZ+1.5,StaName,...
                        'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                    
                end
                
            end
            
        end
        
        % ADD MEAN TRACE
        if (data.AnnealingRun(ic)==1) ; % annealing runned
            % PLOT MEAN TRACE FOR CLUSTER
            AddTrace(-data.MeanTraceZ,0,data.SigFlZ(i).HdrData.DELTA,1);
            % TIME PICK
            plot([data.tpick(ic) data.tpick(ic)],[0.7, 1.3],'k','LineWidth',1);
        end
        
        xlabel('Time (s)');
        title(['Z : ',num2str(data.NminZ),'-',num2str(data.NmaxZ),'/',num2str(length(data.CurrentClassZ))]);
        xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
        set(axesZ,'yticklabel',[]);
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton1
% --- Display 10 First Traces For Z
    function pushbutton1_Callback(hObject, eventdata)
        %         display first 10 traces in cluster
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % INDICES OF TRACES IN THIS CLUSTER
        data.CurrentClassZ = data.Class(ic).IndZ;
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,length(data.CurrentClassZ));
        
        % CHOOSE AXESZ
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayZComponent;

        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton2
% --- Display 10 Next Traces For Z
    function pushbutton2_Callback(hObject, eventdata)
        %     display next traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        % INDICES OF TRACES IN THIS CLUSTER
        data.CurrentClassZ = data.Class(ic).IndZ;

        % RETURN IF NO TRACE TO DISPLAY
        if (data.NmaxZ >= length(data.CurrentClassZ)) ; return; end
        
        if data.AnnealingRun(ic) == 1; % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rbZ(ii),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % FIRST TRACE TO DISPLAY
        n1Z = min(data.NmaxZ+1,length(data.CurrentClassZ));
        
        % LAST TRACE TO DISPLAY
        n2Z = min(data.NmaxZ+data.NbDisp,length(data.CurrentClassZ));
        
        % STORE IN GLOBAL VARIABLE
        data.NminZ = n1Z;
        data.NmaxZ = n2Z;

        % CHOOSE AXESZ
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton3
% --- Display 10 Previous Real Traces For Z
    function pushbutton3_Callback(hObject, eventdata)
        %     display previous traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        % INDICES OF TRACES IN THIS CLUSTER
        data.CurrentClassZ = data.Class(ic).IndZ;
        
        % RETURN IF NO TRACE TO DISPLAY
        if (data.NminZ <= 1) ; return; end
        
        if data.AnnealingRun(ic) == 1; % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rbZ(ii),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
        % FIRST TRACE TO DISPLAY
        n1Z = max(data.NminZ-data.NbDisp,1);
        
        % LAST TRACE TO DISPLAY
        n2Z = max(data.NminZ-1,1);
        
        % STORE IN GLOBAL VARIABLE
        data.NminZ = n1Z;
        data.NmaxZ = n2Z;
       
        % CHOOSE AXESZ
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton10
% --- Update Display of Z Component According to Parameters
    function pushbutton10_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        Tmin = str2double(get(edit1,'String'));
        Tmax = str2double(get(edit2,'String'));
        FrqMin = str2double(get(edit3,'String'));
        FrqMax = str2double(get(edit4,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton1,'Value');
        Filter = get(radiobutton2,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        % Phases = get(popupmenu1,'String');
        % ii = get(popupmenu1,'Value');
        % data.Phase = Phases{ii};
        
        %  ----
        h = waitbar(0,'Filtering Z Component');
        data.SigZ = [];

        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % REFRESH RADIO BUTTONS
        sum(data.AnnealingRun);
        if sum(data.AnnealingRun) > 0
            for itrace = 1:length(data.rbZ)
                set(data.rbZ(itrace),'Visible','off');
            end
        end
        
        guidata(Comp_fig,data)
        
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
            
            % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
            deltat = data.SigInZ(itrace).HdrData.DELTA;
            Time = 0:deltat:(length(data.SigInZ(itrace).SeisData)-1)*data.SigInZ(itrace).HdrData.DELTA;
            Time = Time+data.SigInZ(itrace).HdrData.B-data.SigInZ(itrace).HdrData.O;
            
            %   if Resampling == 1;
            %     % reecrire : handles.SigIn(itrace).SeisData,
            %     % handles.SigIn(itrace).DELTA
            %     % handles.SigIn(itrace).DELTA.NPTS
            %   end
            
            if Window == 1;
                
                % COMPUTE THEORETICAL TRAVEL TIMES
                tt = tauptime('mod','ak135','dep',data.SigInZ(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInZ(itrace).HdrData.GCARC);
                
                if isempty(tt) == 0 % the phase exists
                    
                    ii = ii+1;
                    Ptheo = tt(1).time;
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
                    
                    [itrace ndeb nfin];
                    [i0 i1 data.SigInZ(itrace).HdrData.NPTS NsamplesTot];
                    data.SigInZ(itrace).HdrData.KSTNM;
                    
                    SigWinZ = zeros(NsamplesTot,1);
                    data.SigFlZ(ii).HdrData.B = Tdeb;
                    
                    if Filter == 1; % use band pass filter
                        Fdata0Z = filtbuth_hp(FrqMin,2,deltat,data.SigInZ(itrace).SeisData');
                        Fdata1Z = filtbuth_lp(FrqMax,2,deltat,Fdata0Z);
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(ii).SeisData = SigWinZ';
                    else % wwssn filter
                        Fdata0Z = data.SigInZ(itrace).SeisData-mean(data.SigInZ(itrace).SeisData(i0:i1));
                        Fdata1Z = wwssn_sp(Fdata0Z');
                        SigWinZ(ndeb:nfin) = Fdata1Z(i0:i1);
                        data.SigFlZ(itrace).SeisData = SigWinZ';
                    end
                    
                    if length(data.SigFlZ(itrace).SeisData) == 0;
                        data.SigFlZ(itrace).SeisData = zeros(1,size(data.SigZ,1));
                    end
                    data.SigZ = [data.SigZ,data.SigFlZ(itrace).SeisData'];
                    
                else
                    
                    % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                    data.SigZ = [data.SigZ, zeros(NsamplesTot,1)];
                    
                end
                
                
            else % dont compute theorical travel time
                ii = ii+1;
                data.SigFlZ(itrace).SeisData = data.SigInZ(itrace).SeisData;
                i0 = 1;
                i1 = length(data.SigInZ(itrace).SeisData);
            end
            
        end
        
        guidata(Comp_fig,data)
        close(h)
        
        axes(axesZ); cla; hold off;
        set(listbox1,'String','1','Value',1);
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,data.Ntraces);
        
        % STORE INDICES OF TRACES
        data.CurrentClassZ = data.Class(1).IndZ;
        
        % CHOOSE AXES1
        axes(axesZ);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
    end

% -------------------------------------------------------------------------
    function DisplayNRComponent
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % TIME BEFORE THEORETICAL ARRIVAL TIME
        TimeWindowBegin = str2double(get(edit6,'String'));
        
        % TIME
        Tmax = 0;
        Tmin = 1000;
        
        if data.ZRT(ic) == 1
            % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
            Selection = data.Class(ic).SelectionR;
            
            % loop over 10 events in cluster.
            for ii = data.NminR:data.NmaxR
                
                % GET TRACE INDEX
                i = data.CurrentClassR(ii);
               
                if (data.AnnealingRun(ic) == 1) ;
                    if data.Correction(i) < 0
                        TimeShift = data.residuR(i)+data.Correction(i);
                    else
                        TimeShift = data.residuR(i)-data.Correction(i);
                    end
                else
                    if data.Correction(i) < 0
                        TimeShift = +data.Correction(i);
                    else
                        TimeShift = -data.Correction(i);
                    end
                end
                
                % STATION NAME
                StaName = [data.SigFlR(i).HdrData.KSTNM];
                
                [t0,t1,hpl] = PlotOnTrace(-data.SigFlR(i).SeisData,-TimeShift,data.SigFlR(i).HdrData.DELTA,ii-data.NminR+2);
                data.DispTraceR(ii) = hpl;
                Tmax = max(Tmax,t1);
                Tmin = min(Tmin,t0);
                
                % ADD STATION NAME
                text(Tmin-3.5,ii-data.NminR+1.5,StaName, ...
                    'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                
                if Selection(ii) == 0
                    
                    set(hpl,'Color','Blue');
                    
                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        % ADD RADIOBUTTON
                        data.rbR(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 0, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateNRDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.255 0.8-(ii-data.NminR+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                    end
                    
                else
                    
                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        
                        % ADD RADIOBUTTON
                        data.rbR(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 1, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateNRDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.255 0.8-(ii-data.NminR+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                        
                        % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
                        % EACH TRACE
                        residual = data.tpick(ic)-data.TimeDelay(i)-data.Correction(i)-TimeWindowBegin-data.ResMeanR;
                        RESIDU = num2str(residual,'%4.3f');
                        text(Tmin-0.75,ii-data.NminR+1.85,RESIDU,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        
                        Coef = data.CoefCorR(i);
                        COEF = num2str(Coef,'%4.3f');
                        text(Tmin-5.25,ii-data.NminR+2,COEF,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        text(Tmin-5.75,1,'R^2',...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        
                        % PLOT THEORETICAL ARRIVAL TIME
                        plot([data.SigFlR(i).HdrData.A-data.SigFlR(i).HdrData.B data.SigFlR(i).HdrData.A-data.SigFlR(i).HdrData.B]-TimeShift,[ii-data.NminR+1.5, ii-data.NminR+2.5],'g');
                        
                    else  % ANNEALING NOT RUNNED
                        % add station Name
                        text(Tmin-3.5,ii-data.NminR+1.5,StaName,...
                            'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                        
                    end
                    
                end
                
            end
            
            % ADD MEAN TRACE
            if (data.AnnealingRun(ic) == 1) ; % annealing runned
                % PLOT MEAN TRACE FOR CLUSTER
                AddTrace(-data.MeanTraceR,0,data.SigFlR(i).HdrData.DELTA,1);
                % TIME PICK
                plot([data.tpick(ic) data.tpick(ic)],[0.7, 1.3],'k','LineWidth',1);
            end
            
            xlabel('Time (s)');
            title(['R : ',num2str(data.NminR),'-',num2str(data.NmaxR),'/',num2str(length(data.CurrentClassR))]);
            xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
            set(axesNR,'yticklabel',[]);
            
            if data.deconvolution(ic) == 1
                axes(axesNR);cla; hold on
                
                % loop over 10 events in cluster.
                for ii = data.NminR:data.NmaxR
                    
                    % GET TRACE INDEX
                    i = data.CurrentClassR(ii);
                    
                    if (data.AnnealingRun(ic) == 1) ;
                        TimeShift = data.residuR(i);
                        %                     TimeShift = data.TimeDelay(i);
                    else
                        TimeShift = -data.Correction(i);
                    end
                    
                    % STATION NAME
                    StaName = [data.SigFlR(i).HdrData.KSTNM];
                    
                    [t0,t1,hpl] = PlotOnTrace(-data.DeconvSig(:,i),-TimeShift,data.SigFlR(i).HdrData.DELTA,ii-data.NminR+2);
                    data.DispTraceDeconv(ii) = hpl;
                    Tmax = max(Tmax,t1);
                    Tmin = min(Tmin,t0);
                    
                    Coef = data.CoefCorR(i);
                    COEF = num2str(Coef,'%4.3f');
                    text(Tmin-5.25,ii-data.NminR+2,COEF,...
                        'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    text(Tmin-5.75,1,'R^2',...
                        'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                    
                    % ADD STATION NAME
                    text(0,ii-data.NminR+1.5,StaName, ...
                        'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                    
                    if Selection(ii) == 0
                        
                        set(hpl,'Color','Blue');
                    end
                    
                    xlabel('Time (s)');
                    title(['R : ',num2str(data.NminR),'-',num2str(data.NmaxR),'/',num2str(length(data.CurrentClassR))]);
                    xlim([Tmin-5-0.1,400]);
                    set(axesNR,'yticklabel',[]);
                end
                
            end
            
        else
            % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
            Selection = data.Class(ic).SelectionN;
            
            % loop over 10 events in cluster.
            for ii = data.NminN:data.NmaxN
                
                % GET TRACE INDEX
                i = data.CurrentClassN(ii);
                
                if (data.AnnealingRun(ic) == 1) ;
                    if data.Correction(i) < 0
                        TimeShift = data.residuN(i)+data.Correction(i);
                    else
                        TimeShift = data.residuN(i)-data.Correction(i);
                    end
                else
                    if data.Correction(i) < 0
                        TimeShift = +data.Correction(i);
                    else
                        TimeShift = -data.Correction(i);
                    end
                end
                
                % STATION NAME
                StaName = [data.SigFlN(i).HdrData.KSTNM];
                
                [t0,t1,hpl] = PlotOnTrace(-data.SigFlN(i).SeisData,-TimeShift,data.SigFlN(i).HdrData.DELTA,ii-data.NminN+2);
                data.DispTraceN(ii) = hpl;
                Tmax = max(Tmax,t1);
                Tmin = min(Tmin,t0);
                
                % ADD STATION NAME
                text(Tmin-3.5,ii-data.NminN+1.5,StaName, ...
                    'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                
                if Selection(ii) == 0
                    
                    set(hpl,'Color','Blue');
                    
                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        % ADD RADIOBUTTON
                        data.rbN(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 0, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateNRDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.255 0.8-(ii-data.NminN+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                    end
                    
                else
                    
                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        
                        % ADD RADIOBUTTON
                        data.rbN(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 1, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateNRDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.255 0.8-(ii-data.NminN+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                        
                        % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
                        % EACH TRACE
                        residual = data.tpick(ic)-data.TimeDelay(i)-data.Correction(i)-TimeWindowBegin-data.ResMeanN;
                        RESIDU = num2str(residual,'%4.3f');
                        text(Tmin-0.75,ii-data.NminN+1.85,RESIDU,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        
                        Coef = data.CoefCorN(i);
                        COEF = num2str(Coef,'%4.3f');
                        text(Tmin-5.25,ii-data.NminN+2,COEF,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        text(Tmin-5.75,1,'R^2',...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        
                        % PLOT THEORETICAL ARRIVAL TIME
                        plot([data.SigFlN(i).HdrData.A-data.SigFlN(i).HdrData.B data.SigFlN(i).HdrData.A-data.SigFlN(i).HdrData.B]-TimeShift,[ii-data.NminN+1.5, ii-data.NminN+2.5],'g');
                        
                    else  % ANNEALING NOT RUNNED
                        % add station Name
                        text(Tmin-3.5,ii-data.NminN+1.5,StaName,...
                            'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');
                        
                    end
                    
                end
                
            end
            
            % ADD MEAN TRACE
            if (data.AnnealingRun(ic) == 1) ; % annealing runned
                % PLOT MEAN TRACE FOR CLUSTER
                AddTrace(-data.MeanTraceN,0,data.SigFlN(i).HdrData.DELTA,1);
                % TIME PICK
                plot([data.tpick(ic) data.tpick(ic)],[0.7, 1.3],'k','LineWidth',1);
            end
            
            xlabel('Time (s)');
            title(['N : ',num2str(data.NminN),'-',num2str(data.NmaxN),'/',num2str(length(data.CurrentClassN))]);
            xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
            set(axesNR,'yticklabel',[]);
        end
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton4
% --- Display 10 First Traces For N / R
    function pushbutton4_Callback(hObject, eventdata)
        %         display first 10 traces in cluster
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassR = data.Class(ic).IndR;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminR = 1;
            data.NmaxR = min(data.NbDisp,length(data.CurrentClassR));
        else
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassN = data.Class(ic).IndN;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminN = 1;
            data.NmaxN = min(data.NbDisp,length(data.CurrentClassN));

        end
        
        % CHOOSE AXESR
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayNRComponent;

        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton5
% --- Display 10 Next Traces For N / R
    function pushbutton5_Callback(hObject, eventdata)
        %     display next traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassR = data.Class(ic).IndR;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NmaxR >= length(data.CurrentClassR)) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned            
                for ii = data.NminR:data.NmaxR
                    set(data.rbR(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1R = min(data.NmaxR+1,length(data.CurrentClassR));

            % LAST TRACE TO DISPLAY
            n2R = min(data.NmaxR+data.NbDisp,length(data.CurrentClassR));

            % STORE IN GLOBAL VARIABLE
            data.NminR = n1R;
            data.NmaxR = n2R;
        
        else
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassN = data.Class(ic).IndN;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NmaxN >= length(data.CurrentClassN)) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned            
                for ii = data.NminN:data.NmaxN
                    set(data.rbN(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1N = min(data.NmaxN+1,length(data.CurrentClassN));

            % LAST TRACE TO DISPLAY
            n2N = min(data.NmaxN+data.NbDisp,length(data.CurrentClassN));

            % STORE IN GLOBAL VARIABLE
            data.NminN = n1N;
            data.NmaxN = n2N;
        end
                        
        % CHOOSE AXESR
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton6
% --- Display 10 Previous Real Traces For N / R
    function pushbutton6_Callback(hObject, eventdata)
        %     display previous traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassR = data.Class(ic).IndR;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NminR <= 1) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminR:data.NmaxR
                    set(data.rbR(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1R = max(data.NminR-data.NbDisp,1);

            % LAST TRACE TO DISPLAY
            n2R = max(data.NminR-1,1);

            % STORE IN GLOBAL VARIABLE
            data.NminR = n1R;
            data.NmaxR = n2R;
        
        else
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassN = data.Class(ic).IndN;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NminN <= 1) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminN:data.NmaxN
                    set(data.rbN(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1N = max(data.NminN-data.NbDisp,1);

            % LAST TRACE TO DISPLAY
            n2N = max(data.NminN-1,1);

            % STORE IN GLOBAL VARIABLE
            data.NminN = n1N;
            data.NmaxN = n2N;

        end
                
        % CHOOSE AXESR
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton11
% --- Update Display of N / R Component According to Parameters
    function pushbutton11_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        Tmin = str2double(get(edit6,'String'));
        Tmax = str2double(get(edit7,'String'));
        FrqMin = str2double(get(edit8,'String'));
        FrqMax = str2double(get(edit9,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton4,'Value');
        Filter = get(radiobutton5,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        if data.ZRT(ic) == 1
            %  ----
            h = waitbar(0,'Filtering R Component');
            data.SigR = [];
            
            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));
            
            % REFRESH RADIO BUTTONS
            sum(data.AnnealingRun);
            if sum(data.AnnealingRun) > 0
                for itrace = 1:length(data.rbR)
                    set(data.rbR(itrace),'Visible','off');
                end
            end
            
            guidata(Comp_fig,data)
            
            % NUMBER OF SAMPLES IN TIME WINDOW
            if Window == 1
                NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInR(1).HdrData.DELTA);
            else
                NsamplesTot = length(data.SigInR(1).SeisData);
            end
            
            % INITIALIZE TRACE COUNTER
            ii = 0;
            
            for itrace = 1:data.Ntraces
                
                waitbar(itrace/data.Ntraces);
                
                % COPY DATA
                data.SigFlR(itrace).HdrData = data.SigInR(itrace).HdrData;
                
                % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
                deltat = data.SigInR(itrace).HdrData.DELTA;
                Time = 0:deltat:(length(data.SigInR(itrace).SeisData)-1)*data.SigInR(itrace).HdrData.DELTA;
                Time = Time+data.SigInR(itrace).HdrData.B-data.SigInR(itrace).HdrData.O;
                
                %   if Resampling == 1;
                %     % reecrire : handles.SigIn(itrace).SeisData,
                %     % handles.SigIn(itrace).DELTA
                %     % handles.SigIn(itrace).DELTA.NPTS
                %   end
                
                if Window == 1;
                    
                    % COMPUTE THEORETICAL TRAVEL TIMES
                    tt = tauptime('mod','ak135','dep',data.SigInR(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInR(itrace).HdrData.GCARC);
                    
                    if isempty(tt) == 0 % the phase exists
                        
                        ii = ii+1;
                        Ptheo = tt(1).time;
                        data.SigFlR(itrace).HdrData.A = Ptheo;
                        data.SigInR(itrace).HdrData.A = Ptheo;
                        
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
                        
                        [itrace ndeb nfin];
                        [i0 i1 data.SigInR(itrace).HdrData.NPTS NsamplesTot];
                        data.SigInR(itrace).HdrData.KSTNM;
                        
                        SigWinR = zeros(NsamplesTot,1);
                        data.SigFlR(ii).HdrData.B = Tdeb;
                        
                        if Filter == 1; % use band pass filter
                            Fdata0R = filtbuth_hp(FrqMin,2,deltat,data.SigInR(itrace).SeisData');
                            Fdata1R = filtbuth_lp(FrqMax,2,deltat,Fdata0R);
                            SigWinR(ndeb:nfin) = Fdata1R(i0:i1);
                            data.SigFlR(ii).SeisData = SigWinR';
                        else % wwssn filter
                            Fdata0R = data.SigInR(itrace).SeisData-mean(data.SigInR(itrace).SeisData(i0:i1));
                            Fdata1R = wwssn_sp(Fdata0R');
                            SigWinR(ndeb:nfin) = Fdata1R(i0:i1);
                            data.SigFlR(itrace).SeisData = SigWinR';
                        end
                        
                        if length(data.SigFlR(itrace).SeisData) == 0;
                            data.SigFlR(itrace).SeisData = zeros(1,size(data.SigR,1));
                        end
                        data.SigR = [data.SigR,data.SigFlR(itrace).SeisData'];
                        
                    else
                        
                        % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                        data.SigR = [data.SigR, zeros(NsamplesTot,1)];
                        
                    end
                    
                    
                else % dont compute theorical travel time
                    ii = ii+1;
                    data.SigFlR(itrace).SeisData = data.SigInR(itrace).SeisData;
                    i0 = 1;
                    i1 = length(data.SigInR(itrace).SeisData);
                end
                
            end
            
            guidata(Comp_fig,data)
            close(h)
            
            axes(axesNR); cla; hold off;
            set(listbox1,'String','1','Value',1);
            
            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminR = 1;
            data.NmaxR = min(data.NbDisp,data.Ntraces);
            
            % STORE INDICES OF TRACES
            data.CurrentClassR = data.Class(1).IndR;
        
        else
            %  ----
            h = waitbar(0,'Filtering N Component');
            data.SigN = [];

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % REFRESH RADIO BUTTONS
            sum(data.AnnealingRun);
            if sum(data.AnnealingRun) > 0
                for itrace = 1:length(data.rbN)
                    set(data.rbN(itrace),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % NUMBER OF SAMPLES IN TIME WINDOW
            if Window == 1
                NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInN(1).HdrData.DELTA);
            else
                NsamplesTot = length(data.SigInN(1).SeisData);
            end

            % INITIALIZE TRACE COUNTER
            ii = 0;

            for itrace = 1:data.Ntraces

                waitbar(itrace/data.Ntraces);

                % COPY DATA
                data.SigFlN(itrace).HdrData = data.SigInN(itrace).HdrData;

                % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
                deltat = data.SigInN(itrace).HdrData.DELTA;
                Time = 0:deltat:(length(data.SigInN(itrace).SeisData)-1)*data.SigInN(itrace).HdrData.DELTA;
                Time = Time+data.SigInN(itrace).HdrData.B-data.SigInN(itrace).HdrData.O;

                %   if Resampling == 1;
                %     % reecrire : handles.SigIn(itrace).SeisData,
                %     % handles.SigIn(itrace).DELTA
                %     % handles.SigIn(itrace).DELTA.NPTS
                %   end

                if Window == 1;

                    % COMPUTE THEORETICAL TRAVEL TIMES
                    tt = tauptime('mod','ak135','dep',data.SigInN(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInN(itrace).HdrData.GCARC);

                    if isempty(tt) == 0 % the phase exists

                        ii = ii+1;
                        Ptheo = tt(1).time;
                        data.SigFlN(itrace).HdrData.A = Ptheo;
                        data.SigInN(itrace).HdrData.A = Ptheo;

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

                        [itrace ndeb nfin];
                        [i0 i1 data.SigInN(itrace).HdrData.NPTS NsamplesTot];
                        data.SigInN(itrace).HdrData.KSTNM;

                        SigWinN = zeros(NsamplesTot,1);
                        data.SigFlN(ii).HdrData.B = Tdeb;

                        if Filter == 1; % use band pass filter
                            Fdata0N = filtbuth_hp(FrqMin,2,deltat,data.SigInN(itrace).SeisData');
                            Fdata1N = filtbuth_lp(FrqMax,2,deltat,Fdata0N);
                            SigWinN(ndeb:nfin) = Fdata1N(i0:i1);
                            data.SigFlN(ii).SeisData = SigWinN';
                        else % wwssn filter
                            Fdata0N = data.SigInN(itrace).SeisData-mean(data.SigInN(itrace).SeisData(i0:i1));
                            Fdata1N = wwssn_sp(Fdata0N');
                            SigWinN(ndeb:nfin) = Fdata1N(i0:i1);
                            data.SigFlN(itrace).SeisData = SigWinN';
                        end

                        if length(data.SigFlN(itrace).SeisData) == 0;
                            data.SigFlN(itrace).SeisData = zeros(1,size(data.SigN,1));
                        end
                        data.SigN = [data.SigN,data.SigFlN(itrace).SeisData'];

                    else

                        % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                        data.SigN = [data.SigN, zeros(NsamplesTot,1)];

                    end


                else % dont compute theorical travel time
                    ii = ii+1;
                    data.SigFlN(itrace).SeisData = data.SigInN(itrace).SeisData;
                    i0 = 1;
                    i1 = length(data.SigInN(itrace).SeisData);
                end

            end

            guidata(Comp_fig,data)
            close(h)

            axes(axesNR); cla; hold off;
            set(listbox1,'String','1','Value',1);

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminN = 1;
            data.NmaxN = min(data.NbDisp,data.Ntraces);

            % STORE INDICES OF TRACES
            data.CurrentClassN = data.Class(1).IndN;
        end
        
        % CHOOSE AXES1
        axes(axesNR);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
    end

% -------------------------------------------------------------------------
    function DisplayETComponent
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % TIME BEFORE THEORETICAL ARRIVAL TIME
        TimeWindowBegin = str2double(get(edit11,'String'));

        % TIME
        Tmax = 0;
        Tmin = 1000;        
        
        if data.ZRT(ic) == 1
            % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
            Selection = data.Class(ic).SelectionT;

            % loop over 10 events in cluster.
            for ii = data.NminT:data.NmaxT

                % GET TRACE INDEX
                i = data.CurrentClassT(ii);

                if (data.AnnealingRun(ic) == 1) ;
                    if data.Correction(i) < 0
                        TimeShift = data.residuT(i)+data.Correction(i);
                    else
                        TimeShift = data.residuT(i)-data.Correction(i);
                    end
                else
                    if data.Correction(i) < 0
                        TimeShift = +data.Correction(i);
                    else
                        TimeShift = -data.Correction(i);
                    end
                end

                % STATION NAME
                StaName = [data.SigFlT(i).HdrData.KSTNM];

                [t0,t1,hpl] = PlotOnTrace(-data.SigFlT(i).SeisData,-TimeShift,data.SigFlT(i).HdrData.DELTA,ii-data.NminT+2);
                data.DispTraceT(ii) = hpl;
                Tmax = max(Tmax,t1);
                Tmin = min(Tmin,t0);

                % ADD STATION NAME
                text(Tmin-3.5,ii-data.NminT+1.5,StaName, ...
                    'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');

                if Selection(ii) == 0

                    set(hpl,'Color','Blue');

                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        % ADD RADIOBUTTON
                        data.rbT(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 0, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateETDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.48 0.8-(ii-data.NminT+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                    end

                else

                    if (data.AnnealingRun(ic) == 1) ; % annealing runned

                        % ADD RADIOBUTTON
                        data.rbT(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 1, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateETDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.48 0.8-(ii-data.NminT+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);

                        % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
                        % EACH TRACE
                        residual = data.tpick(ic)-data.TimeDelay(i)-data.Correction(i)-TimeWindowBegin-data.ResMeanT;
                        RESIDU = num2str(residual,'%4.3f');
                        text(Tmin-0.5,ii-data.NminT+1.85,RESIDU,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

                        Coef = data.CoefCorT(i);
                        COEF = num2str(Coef,'%4.3f');
                        text(Tmin-5.25,ii-data.NminT+2,COEF,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        text(Tmin-5.75,1,'R^2',...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

                        % PLOT THEORETICAL ARRIVAL TIME
                        plot([data.SigFlT(i).HdrData.A-data.SigFlT(i).HdrData.B data.SigFlT(i).HdrData.A-data.SigFlT(i).HdrData.B]-TimeShift,[ii-data.NminT+1.5, ii-data.NminT+2.5],'g');

                    else  % ANNEALING NOT RUNNED
                        % add station Name
                        text(Tmin-3.5,ii-data.NminT+1.5,StaName,...
                            'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');

                    end

                end

            end

            % ADD MEAN TRACE
            if (data.AnnealingRun(ic)==1) ; % annealing runned
                % PLOT MEAN TRACE FOR CLUSTER
                AddTrace(-data.MeanTraceT,0,data.SigFlT(i).HdrData.DELTA,1);
                % TIME PICK
                plot([data.tpick(ic) data.tpick(ic)],[0.7, 1.3],'k','LineWidth',1);
            end
        
        else
            % GET CURRENT SELECTION OF TRACES INSIDE CLUSTER
            Selection = data.Class(ic).SelectionE;

            % loop over 10 events in cluster.
            for ii = data.NminE:data.NmaxE

                % GET TRACE INDEX
                i = data.CurrentClassE(ii);

                if (data.AnnealingRun(ic) == 1) ;
                    if data.Correction(i) < 0
                        TimeShift = data.residuE(i)+data.Correction(i);
                    else
                        TimeShift = data.residuE(i)-data.Correction(i);
                    end
                else
                    if data.Correction(i) < 0
                        TimeShift = +data.Correction(i);
                    else
                        TimeShift = -data.Correction(i);
                    end
                end

                % STATION NAME
                StaName = [data.SigFlE(i).HdrData.KSTNM];

                [t0,t1,hpl] = PlotOnTrace(-data.SigFlE(i).SeisData,-TimeShift,data.SigFlE(i).HdrData.DELTA,ii-data.NminE+2);
                data.DispTraceE(ii) = hpl;
                Tmax = max(Tmax,t1);
                Tmin = min(Tmin,t0);

                % ADD STATION NAME
                text(Tmin-3.5,ii-data.NminE+1.5,StaName, ...
                    'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');

                if Selection(ii) == 0

                    set(hpl,'Color','Blue');

                    if (data.AnnealingRun(ic) == 1) ; % annealing runned
                        % ADD RADIOBUTTON
                        data.rbE(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 0, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateETDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.48 0.8-(ii-data.NminE+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);
                    end

                else

                    if (data.AnnealingRun(ic) == 1) ; % annealing runned

                        % ADD RADIOBUTTON
                        data.rbE(ii) = uicontrol( ...
                            'Units', 'normalized', ...
                            'Style', 'Radio', ...
                            'HitTest', 'On', ...
                            'Enable', 'On', ...
                            'Value', 1, ...
                            'Visible', 'On', ...
                            'HandleVisibility', 'On', ...
                            'Callback', @UpdateETDisplay, ...
                            'Interruptible', 'On', ...
                            'Position', [0.48 0.8-(ii-data.NminE+1.75)*(0.7/(data.NbDisp+2)) 0.02 0.02]);

                        % ADD RESIDUAL AND CORRELATION BETWEEN MEAN TRACE AND
                        % EACH TRACE
                        residual = data.tpick(ic)-data.TimeDelay(i)-data.Correction(i)-TimeWindowBegin-data.ResMeanE;
                        RESIDU = num2str(residual,'%4.3f');
                        text(Tmin-0.5,ii-data.NminE+1.85,RESIDU,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

                        Coef = data.CoefCorE(i);
                        COEF = num2str(Coef,'%4.3f');
                        text(Tmin-5.25,ii-data.NminE+2,COEF,...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');
                        text(Tmin-5.75,1,'R^2',...
                            'FontSize',10,'HorizontalAlignment','right','VerticalAlignment','middle');

                        % PLOT THEORETICAL ARRIVAL TIME
                        plot([data.SigFlE(i).HdrData.A-data.SigFlE(i).HdrData.B data.SigFlE(i).HdrData.A-data.SigFlE(i).HdrData.B]-TimeShift,[ii-data.NminE+1.5, ii-data.NminE+2.5],'g');

                    else  % ANNEALING NOT RUNNED
                        % add station Name
                        text(Tmin-3.5,ii-data.NminE+1.5,StaName,...
                            'FontSize',13,'HorizontalAlignment','left','VerticalAlignment','middle');

                    end

                end

            end

            % ADD MEAN TRACE
            if (data.AnnealingRun(ic)==1) ; % annealing runned
                % PLOT MEAN TRACE FOR CLUSTER
                AddTrace(-data.MeanTraceE,0,data.SigFlE(i).HdrData.DELTA,1);
                % TIME PICK
                plot([data.tpick(ic) data.tpick(ic)],[0.7, 1.3],'k','LineWidth',1);
            end
        end
        
        xlabel('Time (s)');
        title(['E : ',num2str(data.NminE),'-',num2str(data.NmaxE),'/',num2str(length(data.CurrentClassE))]);
        xlim([Tmin-5-0.1,Tmax+3.5+0.1]);
        set(axesET,'yticklabel',[]);
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton7
% --- Display 10 First Traces For E / T
    function pushbutton7_Callback(hObject, eventdata)
        %         display first 10 traces in cluster
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassT = data.Class(ic).IndT;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminT = 1;
            data.NmaxT = min(data.NbDisp,length(data.CurrentClassT));
        else
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassE = data.Class(ic).IndE;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminE = 1;
            data.NmaxE = min(data.NbDisp,length(data.CurrentClassE));
        end

        % CHOOSE AXEST
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayETComponent;

        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton8
% --- Display 10 Next Traces For E / T
    function pushbutton8_Callback(hObject, eventdata)
        %     display next traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassT = data.Class(ic).IndT;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NmaxT >= length(data.CurrentClassT)) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned            
                for ii = data.NminT:data.NmaxT
                    set(data.rbT(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1T = min(data.NmaxT+1,length(data.CurrentClassT));

            % LAST TRACE TO DISPLAY
            n2T = min(data.NmaxT+data.NbDisp,length(data.CurrentClassT));

            % STORE IN GLOBAL VARIABLE
            data.NminT = n1T;
            data.NmaxT = n2T;
        else
             % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassE = data.Class(ic).IndE;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NmaxE >= length(data.CurrentClassE)) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned            
                for ii = data.NminE:data.NmaxE
                    set(data.rbE(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1E = min(data.NmaxE+1,length(data.CurrentClassE));

            % LAST TRACE TO DISPLAY
            n2E = min(data.NmaxE+data.NbDisp,length(data.CurrentClassE));

            % STORE IN GLOBAL VARIABLE
            data.NminE = n1E;
            data.NmaxE = n2E;

        end
               
        % CHOOSE AXEST
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton9
% --- Display 10 Previous Real Traces For E / T
    function pushbutton9_Callback(hObject, eventdata)
        %     display previous traces
        
        data = guidata(Comp_fig);
        
        % INDEX OF CLUSTER TO DISPLAY
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassT = data.Class(ic).IndT;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NminT <= 1) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminT:data.NmaxT
                    set(data.rbT(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1T = max(data.NminT-data.NbDisp,1);

            % LAST TRACE TO DISPLAY
            n2T = max(data.NminT-1,1);

            % STORE IN GLOBAL VARIABLE
            data.NminT = n1T;
            data.NmaxT = n2T;
        else
            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassE = data.Class(ic).IndE;

            % RETURN IF NO TRACE TO DISPLAY
            if (data.NminE <= 1) ; return; end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminE:data.NmaxE
                    set(data.rbE(ii),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % FIRST TRACE TO DISPLAY
            n1E = max(data.NminE-data.NbDisp,1);

            % LAST TRACE TO DISPLAY
            n2E = max(data.NminE-1,1);

            % STORE IN GLOBAL VARIABLE
            data.NminE = n1E;
            data.NmaxE = n2E;

        end
                
        % CHOOSE AXEST
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        % DISPLAY 10 TRACES
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% --- Executes on button press in pushbutton12
% --- Update Display of E /T Component According to Parameters
    function pushbutton12_Callback(object,event)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        Tmin = str2double(get(edit11,'String'));
        Tmax = str2double(get(edit12,'String'));
        FrqMin = str2double(get(edit13,'String'));
        FrqMax = str2double(get(edit14,'String'));
        % ReSamp = str2double(get(edit5,'String'));
        
        Window = get(radiobutton7,'Value');
        Filter = get(radiobutton8,'Value');
        % Resampling = get(radiobutton3,'Value');
        
        Phases = get(popupmenu1,'String');
        ii = get(popupmenu1,'Value');
        data.Phase = Phases{ii};
        
        if data.ZRT(ic) == 1
            %  ----
            h = waitbar(0,'Filtering T Component');
            data.SigT = [];

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % REFRESH RADIO BUTTONS
            sum(data.AnnealingRun);
            if sum(data.AnnealingRun) > 0
                for itrace = 1:length(data.rbT)
                    set(data.rbT(itrace),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % NUMBER OF SAMPLES IN TIME WINDOW
            if Window == 1
                NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInT(1).HdrData.DELTA);
            else
                NsamplesTot = length(data.SigInT(1).SeisData);
            end

            % INITIALIZE TRACE COUNTER
            ii = 0;

            for itrace = 1:data.Ntraces

                waitbar(itrace/data.Ntraces);

                % COPY DATA
                data.SigFlT(itrace).HdrData = data.SigInT(itrace).HdrData;

                % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
                deltat = data.SigInT(itrace).HdrData.DELTA;
                Time = 0:deltat:(length(data.SigInT(itrace).SeisData)-1)*data.SigInT(itrace).HdrData.DELTA;
                Time = Time+data.SigInT(itrace).HdrData.B-data.SigInT(itrace).HdrData.O;

                %   if Resampling == 1;
                %     % reecrire : handles.SigIn(itrace).SeisData,
                %     % handles.SigIn(itrace).DELTA
                %     % handles.SigIn(itrace).DELTA.NPTS
                %   end

                if Window == 1;

                    % COMPUTE THEORETICAL TRAVEL TIMES
                    tt = tauptime('mod','ak135','dep',data.SigInT(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInT(itrace).HdrData.GCARC);

                    if isempty(tt) == 0 % the phase exists

                        ii = ii+1;
                        Ptheo = tt(1).time;
                        data.SigFlT(itrace).HdrData.A = Ptheo;
                        data.SigInT(itrace).HdrData.A = Ptheo;

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

                        [itrace ndeb nfin];
                        [i0 i1 data.SigInT(itrace).HdrData.NPTS NsamplesTot];
                        data.SigInT(itrace).HdrData.KSTNM;

                        SigWinT = zeros(NsamplesTot,1);
                        data.SigFlT(ii).HdrData.B = Tdeb;

                        if Filter == 1; % use band pass filter
                            Fdata0T = filtbuth_hp(FrqMin,2,deltat,data.SigInT(itrace).SeisData');
                            Fdata1T = filtbuth_lp(FrqMax,2,deltat,Fdata0T);
                            SigWinT(ndeb:nfin) = Fdata1T(i0:i1);
                            data.SigFlT(ii).SeisData = SigWinT';
                        else % wwssn filter
                            Fdata0T = data.SigInT(itrace).SeisData-mean(data.SigInT(itrace).SeisData(i0:i1));
                            Fdata1T = wwssn_sp(Fdata0T');
                            SigWinT(ndeb:nfin) = Fdata1T(i0:i1);
                            data.SigFlT(itrace).SeisData = SigWinT';
                        end

                        if length(data.SigFlT(itrace).SeisData) == 0;
                            data.SigFlT(itrace).SeisData = zeros(1,size(data.SigT,1));
                        end
                        data.SigT = [data.SigT,data.SigFlT(itrace).SeisData'];

                    else

                        % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                        data.SigT = [data.SigT, zeros(NsamplesTot,1)];

                    end


                else % dont compute theorical travel time
                    ii = ii+1;
                    data.SigFlT(itrace).SeisData = data.SigInT(itrace).SeisData;
                    i0 = 1;
                    i1 = length(data.SigInT(itrace).SeisData);
                end

            end

            guidata(Comp_fig,data)
            close(h)

            axes(axesET); cla; hold off;
            set(listbox1,'String','1','Value',1);

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminT = 1;
            data.NmaxT = min(data.NbDisp,data.Ntraces);

            % STORE INDICES OF TRACES
            data.CurrentClassT = data.Class(1).IndT;
        
        else
                        %  ----
            h = waitbar(0,'Filtering E Component');
            data.SigE = [];

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % REFRESH RADIO BUTTONS
            sum(data.AnnealingRun);
            if sum(data.AnnealingRun) > 0
                for itrace = 1:length(data.rbE)
                    set(data.rbE(itrace),'Visible','off');
                end
            end

            guidata(Comp_fig,data)

            % NUMBER OF SAMPLES IN TIME WINDOW
            if Window == 1
                NsamplesTot = 2+floor((Tmax+Tmin)/data.SigInE(1).HdrData.DELTA);
            else
                NsamplesTot = length(data.SigInE(1).SeisData);
            end

            % INITIALIZE TRACE COUNTER
            ii = 0;

            for itrace = 1:data.Ntraces

                waitbar(itrace/data.Ntraces);

                % COPY DATA
                data.SigFlE(itrace).HdrData = data.SigInE(itrace).HdrData;

                % ABSOLUTE TIME WITH RESPECT TO ORIGIN READ IN SAC FILE
                deltat = data.SigInE(itrace).HdrData.DELTA;
                Time = 0:deltat:(length(data.SigInE(itrace).SeisData)-1)*data.SigInE(itrace).HdrData.DELTA;
                Time = Time+data.SigInE(itrace).HdrData.B-data.SigInE(itrace).HdrData.O;

                %   if Resampling == 1;
                %     % reecrire : handles.SigIn(itrace).SeisData,
                %     % handles.SigIn(itrace).DELTA
                %     % handles.SigIn(itrace).DELTA.NPTS
                %   end

                if Window == 1;

                    % COMPUTE THEORETICAL TRAVEL TIMES
                    tt = tauptime('mod','ak135','dep',data.SigInE(itrace).HdrData.EVDP,'ph',data.Phase,'deg',data.SigInE(itrace).HdrData.GCARC);

                    if isempty(tt) == 0 % the phase exists

                        ii = ii+1;
                        Ptheo = tt(1).time;
                        data.SigFlE(itrace).HdrData.A = Ptheo;
                        data.SigInE(itrace).HdrData.A = Ptheo;

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

                        [itrace ndeb nfin];
                        [i0 i1 data.SigInE(itrace).HdrData.NPTS NsamplesTot];
                        data.SigInE(itrace).HdrData.KSTNM;

                        SigWinE = zeros(NsamplesTot,1);
                        data.SigFlE(ii).HdrData.B = Tdeb;

                        if Filter == 1; % use band pass filter
                            Fdata0E = filtbuth_hp(FrqMin,2,deltat,data.SigInE(itrace).SeisData');
                            Fdata1E = filtbuth_lp(FrqMax,2,deltat,Fdata0E);
                            SigWinE(ndeb:nfin) = Fdata1E(i0:i1);
                            data.SigFlE(ii).SeisData = SigWinE';
                        else % wwssn filter
                            Fdata0E = data.SigInE(itrace).SeisData-mean(data.SigInE(itrace).SeisData(i0:i1));
                            Fdata1E = wwssn_sp(Fdata0E');
                            SigWinE(ndeb:nfin) = Fdata1E(i0:i1);
                            data.SigFlE(itrace).SeisData = SigWinE';
                        end

                        if length(data.SigFlE(itrace).SeisData) == 0;
                            data.SigFlE(itrace).SeisData = zeros(1,size(data.SigE,1));
                        end
                        data.SigE = [data.SigE,data.SigFlE(itrace).SeisData'];

                    else

                        % [NsamplesTot,data.SigIn(itrace).HdrData.DELTA, Tmin, Tmax]
                        data.SigE = [data.SigE, zeros(NsamplesTot,1)];

                    end


                else % dont compute theorical travel time
                    ii = ii+1;
                    data.SigFlE(itrace).SeisData = data.SigInE(itrace).SeisData;
                    i0 = 1;
                    i1 = length(data.SigInE(itrace).SeisData);
                end

            end

            guidata(Comp_fig,data)
            close(h)

            axes(axesET); cla; hold off;
            set(listbox1,'String','1','Value',1);

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminE = 1;
            data.NmaxE = min(data.NbDisp,data.Ntraces);

            % STORE INDICES OF TRACES
            data.CurrentClassE = data.Class(1).IndE;

        end
        
        % CHOOSE AXES1
        axes(axesET);cla;hold on
        
        guidata(Comp_fig,data)
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function clusteringZ_Callback(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % PLOT ALL STATIONS IN AXES2
        for i = 1:data.Ntraces
            STLO(i) = data.SigFlZ(i).HdrData.STLO;
            STLA(i) = data.SigFlZ(i).HdrData.STLA;
        end
        latmin = 5.*(floor(min(STLA)/5.));
        latmax = 5.*(floor(max(STLA)/5.)+1);
        lonmin = 5.*(floor(min(STLO)/5.));
        lonmax = 5.*(floor(max(STLO)/5.)+1);
        
        fst = figure('numbertitle','off', ...
            'menubar','none', ...
            'toolbar','figure', ...
            'name','Clustering Z');
        axst = axes('Parent',fst, ...
            'Xtick', [lonmin lonmax], ...
            'Ytick', [latmin latmax]);
        
        axes(axst);cla;hold on
        m_proj('lambert','lon',[lonmin lonmax],'lat',[latmin latmax]);
        m_grid('linestyle','none','tickdir','out','linewidth',1);
        % Coarse coastline
        m_coast('color','k');
        load faults.dat;
        m_line(faults(:,2),faults(:,1),'color','k')
        
        for i = 1:data.Ntraces
            m_plot(STLO(i),STLA(i),'^k');
        end
        
        % MINIMUM NUMBER OF TRACES TO DEFINE A NEW CLUSTER
        NbMinC = 3;
        
        dt = data.SigFlZ(i).HdrData.DELTA;
        dtmax = 3;
        maxlag = floor(dtmax/dt)+1;
        
        % MINIMUM VALUE OF CORRELATION TO DEFINE A CLUSTER
        Cormin = str2double(get(edit5,'string'));
        
        % CORRELATION MATRIX
        A = data.SigZ;
        Cor = maxcorr_norm(A,maxlag);
        clear A
        
        Eq = zeros(size(Cor));     % initialization of working matrix
        Eq(find(Cor>Cormin)) = 1;  % create working matrix
        
        % CLUSTERING
        nf = ChercheClust(Eq);
        
        % FIND CLUSTERS WITH AT LEAST NBMINC TRACES
        Eclasses = 1:max(nf);
        [Histo,Iout] = hist(nf,Eclasses);
        IndicesClassesZ = Eclasses(find(Histo > NbMinC));
        Nclusters = length(IndicesClassesZ);
        
        % CREATE COLOR SCALE TO DISPLAY CLUSTERS
        couleur = jet(Nclusters);
        
        % NUMBER AND SIZE OF CLUSTERS
        cluster = [];
        
        % LOOP OVER CLUSTERS
        for ic = 1:Nclusters
            
            % GET INDICES OF TRACES IN CLUSTER
            data.Class(ic).IndZ = find(nf == IndicesClassesZ(ic));
            Ntraces = length(data.Class(ic).IndZ);
            
            % STORE NUMBER AND SIZE OF CLUSTERS
            cluster = [cluster; ic Ntraces];
            
            % INITIALLY SELECT ALL THE TRACES IN THE CLUSTER
            data.Class(ic).SelectionZ(1:Ntraces) = 1;
            
            % LOOP OVER TRACES IN CURRENT CLUSTER
            
            for j = 1:Ntraces
                
                % CHOOSE AXES TO PLOT THE STATION POSITION
                axes(axst);
                indice = data.Class(ic).IndZ(j);
                m_plot(data.SigInZ(indice).HdrData.STLO,data.SigInZ(indice).HdrData.STLA,'^','MarkerFaceColor',couleur(ic,:));
                
            end
            
        end
        
        % DEFAULT SETTING FOR LISTBOX1
        set(listbox1,'Value',1);
        
        % SET CLUSTER LIST IN LISTBOX1
        set(listbox1,'String',num2str(cluster));
        
        % CHOOSE AXESZ
        axes(axesZ);cla;hold on
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        % INDICES OF TRACES IN THIS CLUSTER
        data.CurrentClassZ = data.Class(ic).IndZ;
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,length(data.CurrentClassZ));
        
        guidata(Comp_fig,data)
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function clusteringNR_Callback(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            
            % PLOT ALL STATIONS IN AXES2
            for i = 1:data.Ntraces
                STLO(i) = data.SigFlR(i).HdrData.STLO;
                STLA(i) = data.SigFlR(i).HdrData.STLA;
            end
            latmin = 5.*(floor(min(STLA)/5.));
            latmax = 5.*(floor(max(STLA)/5.)+1);
            lonmin = 5.*(floor(min(STLO)/5.));
            lonmax = 5.*(floor(max(STLO)/5.)+1);

            fst = figure('numbertitle','off', ...
                'menubar','none', ...
                'toolbar','figure', ...
                'name','Clustering R');
            axstR = axes('Parent',fst, ...
                'Xtick', [lonmin lonmax], ...
                'Ytick', [latmin latmax]);

            axes(axstR);cla;hold on
            m_proj('lambert','lon',[lonmin lonmax],'lat',[latmin latmax]);
            m_grid('linestyle','none','tickdir','out','linewidth',1);
            % Coarse coastline
            m_coast('color','k');
            load faults.dat;
            m_line(faults(:,2),faults(:,1),'color','k')

            for i = 1:data.Ntraces
                m_plot(STLO(i),STLA(i),'^k');
            end

            % MINIMUM NUMBER OF TRACES TO DEFINE A NEW CLUSTER
            NbMinC = 3;

            dt = data.SigFlR(i).HdrData.DELTA;
            dtmax = 3;
            maxlag = floor(dtmax/dt)+1;

            % MINIMUM VALUE OF CORRELATION TO DEFINE A CLUSTER
            Cormin = str2double(get(edit10,'string'));

            % CORRELATION MATRIX
            A = data.SigR;
            Cor = maxcorr_norm(A,maxlag);
            clear A

            Eq = zeros(size(Cor));     % initialization of working matrix
            Eq(find(Cor>Cormin)) = 1;  % create working matrix

            % CLUSTERING
            nf = ChercheClust(Eq);

            % FIND CLUSTERS WITH AT LEAST NBMINC TRACES
            Eclasses = 1:max(nf);
            [Histo,Iout] = hist(nf,Eclasses);
            IndicesClassesR = Eclasses(find(Histo > NbMinC));
            Nclusters = length(IndicesClassesR);

            % CREATE COLOR SCALE TO DISPLAY CLUSTERS
            couleur = jet(Nclusters);

            % NUMBER AND SIZE OF CLUSTERS
            cluster = [];

            % LOOP OVER CLUSTERS
            for ic = 1:Nclusters

                % GET INDICES OF TRACES IN CLUSTER
                data.Class(ic).IndR = find(nf == IndicesClassesR(ic));
                Ntraces = length(data.Class(ic).IndR);

                % STORE NUMBER AND SIZE OF CLUSTERS
                cluster = [cluster; ic Ntraces];

                % INITIALLY SELECT ALL THE TRACES IN THE CLUSTER
                data.Class(ic).SelectionR(1:Ntraces) = 1;

                % LOOP OVER TRACES IN CURRENT CLUSTER

                for j = 1:Ntraces

                    % CHOOSE AXES TO PLOT THE STATION POSITION
                    axes(axstR);
                    indice = data.Class(ic).IndR(j);
                    m_plot(data.SigInR(indice).HdrData.STLO,data.SigInR(indice).HdrData.STLA,'^','MarkerFaceColor',couleur(ic,:));

                end

            end

            % DEFAULT SETTING FOR LISTBOX1
            set(listbox1,'Value',1);

            % SET CLUSTER LIST IN LISTBOX1
            set(listbox1,'String',num2str(cluster));

            % CHOOSE AXESZ
            axes(axesNR);cla;hold on

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassR = data.Class(ic).IndR;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminR = 1;
            data.NmaxR = min(data.NbDisp,length(data.CurrentClassR));
            
        else
            
            % PLOT ALL STATIONS IN AXES2
            for i = 1:data.Ntraces
                STLO(i) = data.SigFlN(i).HdrData.STLO;
                STLA(i) = data.SigFlN(i).HdrData.STLA;
            end
            latmin = 5.*(floor(min(STLA)/5.));
            latmax = 5.*(floor(max(STLA)/5.)+1);
            lonmin = 5.*(floor(min(STLO)/5.));
            lonmax = 5.*(floor(max(STLO)/5.)+1);

            fst = figure('numbertitle','off', ...
                'menubar','none', ...
                'toolbar','figure', ...
                'name','Clustering N');
            axstN = axes('Parent',fst, ...
                'Xtick', [lonmin lonmax], ...
                'Ytick', [latmin latmax]);

            axes(axstN);cla;hold on
            m_proj('lambert','lon',[lonmin lonmax],'lat',[latmin latmax]);
            m_grid('linestyle','none','tickdir','out','linewidth',1);
            % Coarse coastline
            m_coast('color','k');
            load faults.dat;
            m_line(faults(:,2),faults(:,1),'color','k')

            for i = 1:data.Ntraces
                m_plot(STLO(i),STLA(i),'^k');
            end

            % MINIMUM NUMBER OF TRACES TO DEFINE A NEW CLUSTER
            NbMinC = 3;

            dt = data.SigFlN(i).HdrData.DELTA;
            dtmax = 3;
            maxlag = floor(dtmax/dt)+1;

            % MINIMUM VALUE OF CORRELATION TO DEFINE A CLUSTER
            Cormin = str2double(get(edit10,'string'));

            % CORRELATION MATRIX
            A = data.SigN;
            Cor = maxcorr_norm(A,maxlag);
            clear A

            Eq = zeros(size(Cor));     % initialization of working matrix
            Eq(find(Cor>Cormin)) = 1;  % create working matrix

            % CLUSTERING
            nf = ChercheClust(Eq);

            % FIND CLUSTERS WITH AT LEAST NBMINC TRACES
            Eclasses = 1:max(nf);
            [Histo,Iout] = hist(nf,Eclasses);
            IndicesClassesN = Eclasses(find(Histo > NbMinC));
            Nclusters = length(IndicesClassesN);

            % CREATE COLOR SCALE TO DISPLAY CLUSTERS
            couleur = jet(Nclusters);

            % NUMBER AND SIZE OF CLUSTERS
            cluster = [];

            % LOOP OVER CLUSTERS
            for ic = 1:Nclusters

                % GET INDICES OF TRACES IN CLUSTER
                data.Class(ic).IndN = find(nf == IndicesClassesN(ic));
                Ntraces = length(data.Class(ic).IndN);

                % STORE NUMBER AND SIZE OF CLUSTERS
                cluster = [cluster; ic Ntraces];

                % INITIALLY SELECT ALL THE TRACES IN THE CLUSTER
                data.Class(ic).SelectionN(1:Ntraces) = 1;

                % LOOP OVER TRACES IN CURRENT CLUSTER

                for j = 1:Ntraces

                    % CHOOSE AXES TO PLOT THE STATION POSITION
                    axes(axstN);
                    indice = data.Class(ic).IndN(j);
                    m_plot(data.SigInN(indice).HdrData.STLO,data.SigInN(indice).HdrData.STLA,'^','MarkerFaceColor',couleur(ic,:));

                end

            end

            % DEFAULT SETTING FOR LISTBOX1
            set(listbox1,'Value',1);

            % SET CLUSTER LIST IN LISTBOX1
            set(listbox1,'String',num2str(cluster));

            % CHOOSE AXESZ
            axes(axesNR);cla;hold on

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassN = data.Class(ic).IndN;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminN = 1;
            data.NmaxN = min(data.NbDisp,length(data.CurrentClassN));
            
        end
        
        guidata(Comp_fig,data)
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function clusteringET_Callback(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER NUMBER
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
        
            % PLOT ALL STATIONS IN AXES2
            for i = 1:data.Ntraces
                STLO(i) = data.SigFlT(i).HdrData.STLO;
                STLA(i) = data.SigFlT(i).HdrData.STLA;
            end
            latmin = 5.*(floor(min(STLA)/5.));
            latmax = 5.*(floor(max(STLA)/5.)+1);
            lonmin = 5.*(floor(min(STLO)/5.));
            lonmax = 5.*(floor(max(STLO)/5.)+1);

            fst = figure('numbertitle','off', ...
                'menubar','none', ...
                'toolbar','figure', ...
                'name','Clustering T');
            axstT= axes('Parent',fst, ...
                'Xtick', [lonmin lonmax], ...
                'Ytick', [latmin latmax]);

            axes(axstT);cla;hold on
            m_proj('lambert','lon',[lonmin lonmax],'lat',[latmin latmax]);
            m_grid('linestyle','none','tickdir','out','linewidth',1);
            % Coarse coastline
            m_coast('color','k');
            load faults.dat;
            m_line(faults(:,2),faults(:,1),'color','k')

            for i = 1:data.Ntraces
                m_plot(STLO(i),STLA(i),'^k');
            end

            % MINIMUM NUMBER OF TRACES TO DEFINE A NEW CLUSTER
            NbMinC = 3;

            dt = data.SigFlT(i).HdrData.DELTA;
            dtmax = 3;
            maxlag = floor(dtmax/dt)+1;

            % MINIMUM VALUE OF CORRELATION TO DEFINE A CLUSTER
            Cormin = str2double(get(edit15,'string'));

            % CORRELATION MATRIX
            A = data.SigT;
            Cor = maxcorr_norm(A,maxlag);
            clear A

            Eq = zeros(size(Cor));     % initialization of working matrix
            Eq(find(Cor>Cormin)) = 1;  % create working matrix

            % CLUSTERING
            nf = ChercheClust(Eq);

            % FIND CLUSTERS WITH AT LEAST NBMINC TRACES
            Eclasses = 1:max(nf);
            [Histo,Iout] = hist(nf,Eclasses);
            IndicesClassesT = Eclasses(find(Histo > NbMinC));
            Nclusters = length(IndicesClassesT);

            % CREATE COLOR SCALE TO DISPLAY CLUSTERS
            couleur = jet(Nclusters);

            % NUMBER AND SIZE OF CLUSTERS
            cluster = [];

            % LOOP OVER CLUSTERS
            for ic = 1:Nclusters

                % GET INDICES OF TRACES IN CLUSTER
                data.Class(ic).IndT = find(nf == IndicesClassesT(ic));
                Ntraces = length(data.Class(ic).IndT);

                % STORE NUMBER AND SIZE OF CLUSTERS
                cluster = [cluster; ic Ntraces];

                % INITIALLY SELECT ALL THE TRACES IN THE CLUSTER
                data.Class(ic).SelectionT(1:Ntraces) = 1;

                % LOOP OVER TRACES IN CURRENT CLUSTER

                for j = 1:Ntraces

                    % CHOOSE AXES TO PLOT THE STATION POSITION
                    axes(axstT);
                    indice = data.Class(ic).IndT(j);
                    m_plot(data.SigInT(indice).HdrData.STLO,data.SigInT(indice).HdrData.STLA,'^','MarkerFaceColor',couleur(ic,:));

                end

            end

            % DEFAULT SETTING FOR LISTBOX1
            set(listbox1,'Value',1);

            % SET CLUSTER LIST IN LISTBOX1
            set(listbox1,'String',num2str(cluster));

            % CHOOSE AXESZ
            axes(axesET);cla;hold on

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassT = data.Class(ic).IndT;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminT = 1;
            data.NmaxT = min(data.NbDisp,length(data.CurrentClassT));
            
        else
           
            % PLOT ALL STATIONS IN AXES2
            for i = 1:data.Ntraces
                STLO(i) = data.SigFlE(i).HdrData.STLO;
                STLA(i) = data.SigFlE(i).HdrData.STLA;
            end
            latmin = 5.*(floor(min(STLA)/5.));
            latmax = 5.*(floor(max(STLA)/5.)+1);
            lonmin = 5.*(floor(min(STLO)/5.));
            lonmax = 5.*(floor(max(STLO)/5.)+1);

            fst = figure('numbertitle','off', ...
                'menubar','none', ...
                'toolbar','figure', ...
                'name','Clustering E');
            axstE = axes('Parent',fst, ...
                'Xtick', [lonmin lonmax], ...
                'Ytick', [latmin latmax]);

            axes(axstE);cla;hold on
            m_proj('lambert','lon',[lonmin lonmax],'lat',[latmin latmax]);
            m_grid('linestyle','none','tickdir','out','linewidth',1);
            % Coarse coastline
            m_coast('color','k');
            load faults.dat;
            m_line(faults(:,2),faults(:,1),'color','k')

            for i = 1:data.Ntraces
                m_plot(STLO(i),STLA(i),'^k');
            end

            % MINIMUM NUMBER OF TRACES TO DEFINE A NEW CLUSTER
            NbMinC = 3;

            dt = data.SigFlE(i).HdrData.DELTA;
            dtmax = 3;
            maxlag = floor(dtmax/dt)+1;

            % MINIMUM VALUE OF CORRELATION TO DEFINE A CLUSTER
            Cormin = str2double(get(edit15,'string'));

            % CORRELATION MATRIX
            A = data.SigE;
            Cor = maxcorr_norm(A,maxlag);
            clear A

            Eq = zeros(size(Cor));     % initialization of working matrix
            Eq(find(Cor>Cormin)) = 1;  % create working matrix

            % CLUSTERING
            nf = ChercheClust(Eq);

            % FIND CLUSTERS WITH AT LEAST NBMINC TRACES
            Eclasses = 1:max(nf);
            [Histo,Iout] = hist(nf,Eclasses);
            IndicesClassesE = Eclasses(find(Histo > NbMinC));
            Nclusters = length(IndicesClassesE);

            % CREATE COLOR SCALE TO DISPLAY CLUSTERS
            couleur = jet(Nclusters);

            % NUMBER AND SIZE OF CLUSTERS
            cluster = [];

            % LOOP OVER CLUSTERS
            for ic = 1:Nclusters

                % GET INDICES OF TRACES IN CLUSTER
                data.Class(ic).IndE = find(nf == IndicesClassesE(ic));
                Ntraces = length(data.Class(ic).IndE);

                % STORE NUMBER AND SIZE OF CLUSTERS
                cluster = [cluster; ic Ntraces];

                % INITIALLY SELECT ALL THE TRACES IN THE CLUSTER
                data.Class(ic).SelectionE(1:Ntraces) = 1;

                % LOOP OVER TRACES IN CURRENT CLUSTER

                for j = 1:Ntraces

                    % CHOOSE AXES TO PLOT THE STATION POSITION
                    axes(axstE);
                    indice = data.Class(ic).IndE(j);
                    m_plot(data.SigInE(indice).HdrData.STLO,data.SigInE(indice).HdrData.STLA,'^','MarkerFaceColor',couleur(ic,:));

                end

            end

            % DEFAULT SETTING FOR LISTBOX1
            set(listbox1,'Value',1);

            % SET CLUSTER LIST IN LISTBOX1
            set(listbox1,'String',num2str(cluster));

            % CHOOSE AXESZ
            axes(axesET);cla;hold on

            % GET CLUSTER NUMBER
            ic = (get(listbox1,'value'));

            % INDICES OF TRACES IN THIS CLUSTER
            data.CurrentClassE = data.Class(ic).IndE;

            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminE = 1;
            data.NmaxE = min(data.NbDisp,length(data.CurrentClassE));
            
        end
        
        guidata(Comp_fig,data)
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
% --- Align ZNE / ZRT Component According to Time Window
    function annealing_Callback(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = get(listbox1,'Value');
        
        % GET Z PARAMETERS
        Ntraces = length(data.Class(ic).IndZ);
        dt = data.SigFlZ(1).HdrData.DELTA;
        
        % SELECTION OF Z TRACES IN CLUSTER
        Selection = data.Class(ic).SelectionZ;
        NbSelected = length(find(Selection));
        IndexSelected = find(Selection);
                    
        % GET Z TIME BEFORE THEORETICAL P ARRIVAL
        Tmin = str2double(get(edit1,'String'));
        Tmax = str2double(get(edit2,'String'));
        
        % DELAY BETWEEN SIGNALS AND FIRST MEAN TRACE
        S = []; PtheoMean = 0;
        for i = 1:NbSelected
            S(i,:) = data.SigFlZ(IndexSelected(i)).SeisData(:);
            PtheoMean = PtheoMean + data.SigFlZ(IndexSelected(i)).HdrData.A-data.SigFlZ(IndexSelected(i)).HdrData.B;
        end
        data.PtheoMean = PtheoMean/NbSelected;
        
        [Zsig_align,TimeDelay] = aligne_trace_cc(S,dt,Tmin,Tmax);       

        N = size(Zsig_align);
        StackZ = zeros(1,N(2));
        
        for i = 2:NbSelected
            data.SigFlZ(IndexSelected(i)).SeisDataAlign = Zsig_align(i,:);
            StackZ = StackZ + data.SigFlZ(IndexSelected(i)).SeisData;
        end
        
        S = [StackZ ; data.SigFlZ(IndexSelected(1)).SeisData];
        [sig,d1] = aligne_trace_cc(S,dt,Tmin,Tmax);
        delay(1) = d1(2);
        data.SigFlZ(IndexSelected(1)).SeisDataAlign = sig(2,:);
        Zsig_align(1,:) = sig(2,:);
        StackZ = StackZ + data.SigFlZ(IndexSelected(1)).SeisData;

        StackAllZ = zeros(1,length(data.SigInZ(1).SeisData(:)));
        
        for i = 1:NbSelected
            data.SigInZ(i).SeisDataAlign(:) = phaseshift(data.SigInZ(i).SeisData(:)',length(StackAllZ),dt,TimeDelay(i));
            StackAllZ = StackAllZ + data.SigInZ(i).SeisDataAlign;
        end
        
        data.TimeDelay = TimeDelay;
        data.StackZ = StackZ;
        data.MeanTraceZ = data.StackZ/NbSelected;
        data.MeanTraceAllZ = StackAllZ/NbSelected;
        TimeMean = (0:dt:(length(data.MeanTraceZ)-1)*dt);

        % DISPLAY MEAN TRACE ON AXES1
        axes(axesZ);cla;
        set(gca,'YlimMode','auto')
        plot(TimeMean,-data.MeanTraceZ,'r');
        hold on
        plot([data.PtheoMean data.PtheoMean],[-max(data.MeanTraceZ)*0.1,max(data.MeanTraceZ)*0.1],'b','LineWidth',1);
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

        set(axesZ,'Xlim',[axes_lim(1) axes_lim(2)]);

        % PICK ARRIVAL TIME ON MEAN TRACE
        set(gcf,'pointer','crosshair');
        waitforbuttonpress; % wait
        pt = get(axesZ, 'CurrentPoint');
        x = pt(1);
        xmin = x-str2double(get(edit1,'String'));
        xmax = x+str2double(get(edit2,'String'));
        ipick = find(TimeMean<=x,1,'last');     % find index
        data.WavePickZ(ic) = ipick; % and store it.
        data.tpick(ic) = TimeMean(ipick);
        
        Cor = [];
        for i = 1:Ntraces
            if Selection(i) ~= 0
                Cor = [Cor data.Correction(i)];
            end
        end
  
        for i = 1:NbSelected
            % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
            if data.Correction(IndexSelected(i)) < 0
                res(IndexSelected(i)) = data.tpick(ic)-data.TimeDelay(IndexSelected(i))-Tmin-Cor(i);
            else
                res(IndexSelected(i)) = data.tpick(ic)-data.TimeDelay(IndexSelected(i))-Tmin+Cor(i);
            end
        end
        
        data.ResMean = mean(res);
            
        for i = 1:NbSelected
            data.residu(IndexSelected(i)) = res(IndexSelected(i))-mean(res);
        end

        for i = 1:NbSelected
            num = sum(data.MeanTraceZ.*Zsig_align(IndexSelected(i),:));
            denom = sqrt(sum(abs(Zsig_align(IndexSelected(i),:)).^2))*sqrt(sum(abs(data.MeanTraceZ).^2));
            data.CoefCorZ(IndexSelected(i)) = num/denom;
        end
            
        if data.ZRT(ic) == 1
            % GET R PARAMETERS
            NtracesR = length(data.Class(ic).IndR);
            dtR = data.SigFlR(1).HdrData.DELTA;
            
            % GET T PARAMETERS
            NtracesT = length(data.Class(ic).IndT);
            dtT = data.SigFlR(1).HdrData.DELTA;

            % SELECTION OF R TRACES IN CLUSTER
            SelectionR = data.Class(ic).SelectionR;
            NbSelectedR = length(find(SelectionR));
            IndexSelectedR = find(SelectionR);
            
            % SELECTION OF T TRACES IN CLUSTER
            SelectionT = data.Class(ic).SelectionT;
            NbSelectedT = length(find(SelectionT));
            IndexSelectedT = find(SelectionT);
            
            % GET R TIME BEFORE THEORETICAL P ARRIVAL
            TminR = str2double(get(edit6,'String'));
            TmaxR = str2double(get(edit7,'String'));
            
            % GET T TIME BEFORE THEORETICAL P ARRIVAL
            TminT = str2double(get(edit11,'String'));
            TmaxT = str2double(get(edit12,'String'));

            % DELAY BETWEEN R SIGNALS AND CALCULATE MEAN TRACE
            data.StackR(:,1) = zeros(1,length(data.SigFlR(IndexSelectedR(1)).SeisData));
            
            for j = 1:NbSelectedR
                data.SigFlR(IndexSelectedR(j)).SeisDataAlign = phaseshift(data.SigFlR(IndexSelectedR(j)).SeisData(:),length(data.SigFlR(IndexSelectedR(1)).SeisData(:)),dtR,-TimeDelay(IndexSelectedR(j)));
                data.SigInR(IndexSelectedR(j)).SeisDataAlign = phaseshift(data.SigInR(IndexSelectedR(j)).SeisData(:),length(data.SigInR(IndexSelectedR(1)).SeisData(:)),dtR,-TimeDelay(IndexSelectedR(j)));
                data.StackR(:,1) = data.StackR(:,1) + data.SigFlR(IndexSelectedR(j)).SeisDataAlign(:);
            end
            
            data.MeanTraceR = data.StackR(:,1)/NbSelectedR;           
           
            % DELAY BETWEEN T SIGNALS AND CALCULATE MEAN TRACE
            data.StackT(:,1) = zeros(1,length(data.SigFlT(IndexSelectedT(1)).SeisData));
            
            for j = 1:NbSelectedT
                data.SigFlT(IndexSelectedT(j)).SeisDataAlign = phaseshift(data.SigFlT(IndexSelectedT(j)).SeisData(:),length(data.SigFlT(IndexSelectedT(j)).SeisData(:)),dtT,-TimeDelay(IndexSelectedT(j)));
                data.SigInT(IndexSelectedT(j)).SeisDataAlign = phaseshift(data.SigInT(IndexSelectedT(j)).SeisData(:),length(data.SigInT(IndexSelectedT(j)).SeisData(:)),dtT,-TimeDelay(IndexSelectedT(j)));
                data.StackT(:,1) = data.StackT(:,1) + data.SigFlT(IndexSelectedT(j)).SeisDataAlign(:);
            end
            
            data.MeanTraceT = data.StackT(:,1)/NbSelectedT;

            for i = 2:NbSelectedR
                % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
                res(IndexSelectedR(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedR(i))-TminR;%-data.Correction(IndexSelectedR(i));
            end
            
                data.ResMeanR = mean(res);
                
            for i = 2:NbSelectedR
                data.residuR(IndexSelectedR(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedR(i))-TminR-mean(res);%-data.Correction(IndexSelectedR(i));
                
                Rsig_align(IndexSelected(i),:) = data.SigFlR(IndexSelectedR(i)).SeisDataAlign;
            end
                       
            for i = 1:NbSelectedR
                num = sum(data.MeanTraceR'.*Rsig_align(IndexSelected(i),:));
                denom = sqrt(sum(abs(Rsig_align(IndexSelected(i),:)).^2))*sqrt(sum(abs(data.MeanTraceR').^2));
                data.CoefCorR(IndexSelectedR(i)) = num/denom;
            end
            
            for i = 2:NbSelectedT
                % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
                res(IndexSelectedT(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedT(i))-TminT;%-data.Correction(IndexSelectedT(i));
            end
            
                data.ResMeanT = mean(res);
                
           for i = 2:NbSelectedT
                data.residuT(IndexSelectedT(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedT(i))-TminT-mean(res);%-data.Correction(IndexSelectedT(i));
                
                Tsig_align(IndexSelected(i),:) = data.SigFlT(IndexSelectedR(i)).SeisDataAlign;
            end
            
            for i = 1:NbSelectedT
                num = sum(data.MeanTraceT'.*Tsig_align(IndexSelected(i),:));
                denom = sqrt(sum(abs(Tsig_align(IndexSelected(i),:)).^2))*sqrt(sum(abs(data.MeanTraceR').^2));
                data.CoefCorT(IndexSelectedT(i)) = num/denom;
            end
            
        else
            
            % GET N PARAMETERS
            NtracesN = length(data.Class(ic).IndN);
            dtN = data.SigFlN(1).HdrData.DELTA;
            
            % GET T PARAMETERS
            NtracesE = length(data.Class(ic).IndE);
            dtE = data.SigFlE(1).HdrData.DELTA;

            % SELECTION OF N TRACES IN CLUSTER
            SelectionN = data.Class(ic).SelectionN;
            NbSelectedN = length(find(SelectionN));
            IndexSelectedN = find(SelectionN);
            
            % SELECTION OF E TRACES IN CLUSTER
            SelectionE = data.Class(ic).SelectionE;
            NbSelectedE = length(find(SelectionE));
            IndexSelectedE = find(SelectionE);
            
            % GET N TIME BEFORE THEORETICAL P ARRIVAL
            TminN = str2double(get(edit6,'String'));
            TmaxN = str2double(get(edit7,'String'));
            
            % GET E TIME BEFORE THEORETICAL P ARRIVAL
            TminE = str2double(get(edit11,'String'));
            TmaxE = str2double(get(edit12,'String'));

            % DELAY BETWEEN N SIGNALS AND CALCULATE MEAN TRACE
            data.StackN(:,1) = zeros(1,length(data.SigFlN(IndexSelectedN(1)).SeisData));
            
            for j = 1:NbSelectedN
                data.SigFlN(IndexSelectedN(j)).SeisDataAlign = phaseshift(data.SigFlN(IndexSelectedN(j)).SeisData(:)',length(data.SigFlN(IndexSelectedN(1)).SeisData(:)),dtN,-TimeDelay(IndexSelectedN(j)));
                data.SigInN(IndexSelectedN(j)).SeisDataAlign = phaseshift(data.SigInN(IndexSelectedN(j)).SeisData(:)',length(data.SigInN(IndexSelectedN(1)).SeisData(:)),dtN,-TimeDelay(IndexSelectedN(j)));
                data.StackN(:,1) = data.StackN(:,1) + data.SigFlN(IndexSelectedN(j)).SeisDataAlign(:);
            end
            
            data.MeanTraceN = data.StackN(:,1)/NbSelectedN;
            
            % DELAY BETWEEN E SIGNALS AND CALCULATE MEAN TRACE
            data.StackE(:,1) = zeros(1,length(data.SigFlE(IndexSelectedE(1)).SeisData));
            
            for j = 1:NbSelectedE
                data.SigFlE(IndexSelectedE(j)).SeisDataAlign = phaseshift(data.SigFlE(IndexSelectedE(j)).SeisData(:)',length(data.SigFlE(IndexSelectedE(j)).SeisData(:)),dtE,-TimeDelay(IndexSelectedE(j)));
                data.SigInE(IndexSelectedE(j)).SeisDataAlign = phaseshift(data.SigInE(IndexSelectedE(j)).SeisData(:)',length(data.SigInE(IndexSelectedE(j)).SeisData(:)),dtE,-TimeDelay(IndexSelectedE(j)));
                data.StackE(:,1) = data.StackE(:,1) + data.SigFlE(IndexSelectedE(j)).SeisDataAlign(:);
            end
            
            data.MeanTraceE = data.StackE(:,1)/NbSelectedE;

            for i = 2:NbSelectedN
                % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
                res(IndexSelectedN(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedN(i))-TminN;%-data.Correction(IndexSelectedR(i));
            end
            
                data.ResMeanN = mean(res);
                
            for i = 2:NbSelectedN
                data.residuN(IndexSelectedN(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedN(i))-TminN-mean(res);%-data.Correction(IndexSelectedR(i));
                
                Nsig_align(IndexSelectedN(i),:) = data.SigFlN(IndexSelectedN(i)).SeisDataAlign;
            end
                       
            for i = 1:NbSelectedN
                num = sum(data.MeanTraceN'.*Nsig_align(IndexSelectedN(i),:));
                denom = sqrt(sum(abs(Nsig_align(IndexSelectedN(i),:)).^2))*sqrt(sum(abs(data.MeanTraceN').^2));
                data.CoefCorN(IndexSelectedN(i)) = num/denom;
            end
            
            for i = 2:NbSelectedE
                % COMPUTE RESIDUAL BETWEEN THEORETICAL AND OBSERVED TRAVEL TIMES
                res(IndexSelectedE(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedE(i))-TminE;%-data.Correction(IndexSelectedT(i));
            end
            
                data.ResMeanE = mean(res);
                
           for i = 2:NbSelectedE
                data.residuE(IndexSelectedE(i)) = data.tpick(ic)-data.TimeDelay(IndexSelectedE(i))-TminE-mean(res);%-data.Correction(IndexSelectedT(i));
                
                Esig_align(IndexSelectedE(i),:) = data.SigFlE(IndexSelectedE(i)).SeisDataAlign;
            end
            
            for i = 1:NbSelectedE
                num = sum(data.MeanTraceE'.*Esig_align(IndexSelectedE(i),:));
                denom = sqrt(sum(abs(Esig_align(IndexSelectedE(i),:)).^2))*sqrt(sum(abs(data.MeanTraceE').^2));
                data.CoefCorE(IndexSelectedE(i)) = num/denom;
            end
            
        end
                    
        % RESET THE BUTTON DOWN FUNCTION
        set(gcf,'pointer','default');
        
        guidata(Comp_fig,data)
        axes(axesZ);cla;hold on;
        set(gca,'YlimMode','manual');
        set(gca,'Ylim',[0 data.NbDisp+2]);
        set(gca,'Ydir', 'reverse');
        
        % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
        data.NminZ = 1;
        data.NmaxZ = min(data.NbDisp,Ntraces);
        
        data.AnnealingRun(ic) = 1;
        
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesZ);cla;hold on
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
        if data.ZRT(ic) == 1
            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminR = 1;
            data.NmaxR = min(data.NbDisp,NtracesR);
        else
            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminN = 1;
            data.NmaxN = min(data.NbDisp,NtracesN);
        end
        
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesNR);cla;hold on
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
        if data.ZRT(ic) == 1
            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminT = 1;
            data.NmaxT = min(data.NbDisp,NtracesT);
        else
            % STORE BEGIN AND END TRACE INDICES FOR DISPLAY IN GLOBAL VARIABLE
            data.NminE = 1;
            data.NmaxE = min(data.NbDisp,NtracesE);
        end
        
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesET);cla;hold on
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
% --- Deconvolution Z/R
    function deconvolution_Callback(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = get(listbox1,'Value');
        
        if data.ZRT(ic) == 1
            % GET Z PARAMETERS
            Ntraces = length(data.Class(ic).IndZ);

            % SELECTION OF Z TRACES IN CLUSTER
            Selection = data.Class(ic).SelectionZ;
            NbSelected = length(find(Selection));
            IndexSelected = find(Selection);

            % SELECTION OF T TRACES IN CLUSTER
            SelectionR = data.Class(ic).SelectionR;
            NbSelectedR = length(find(SelectionR));
            IndexSelectedR = find(SelectionR);

            npts = length(data.AlignSigZ(1).SeisData);
            nfft = 2^nextpow2(npts);

            for i = 1:NbSelected
                for j = 1:NbSelectedR
                    if IndexSelected(i) == IndexSelected(j)
                        SigZ = fft(data.AlignSigZ(IndexSelected(i)).SeisData(:),nfft);
                        SigR = fft(data.AlignSigR(IndexSelected(j)).SeisData(:),nfft);

                        DeconvSig = SigR ./ SigZ;
                        data.DeconvSig(:,IndexSelected(i)) = real(ifft(DeconvSig,nfft));
                    end
                end
            end
        end
        data.deconvolution(ic) = 1;

        % UPDATE DISPLAY
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesNR);cla;hold on
        
        DisplayNRComponent;
               
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
% OLD FUNCTION
    function SaveResults_Callback(hObject, eventdata)
        % Write outputs of simulated annealing in file
        
        data = guidata(Comp_fig);
        
        % TIME BEFORE AND AFTER THEORETICAL ARRIVAL TIME
        TminZ = str2double(get(edit1,'String'));
        TmaxZ = str2double(get(edit2,'String'));
        TminR = str2double(get(edit6,'String'));
        TmaxR = str2double(get(edit7,'String'));
        TminT = str2double(get(edit11,'String'));
        TmaxT = str2double(get(edit12,'String'));
        
        % FILTERING PARAMETERS
        FilterZ = get(radiobutton2,'Value');
        FrqMinZ = str2double(get(edit3,'String'));
        FrqMaxZ = str2double(get(edit4,'String'));
        FilterR = get(radiobutton5,'Value');
        FrqMinR = str2double(get(edit8,'String'));
        FrqMaxR = str2double(get(edit9,'String'));
        FilterT = get(radiobutton8,'Value');
        FrqMinT = str2double(get(edit13,'String'));
        FrqMaxT = str2double(get(edit14,'String'));
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % INDICES OF TRACES INSIDE CLUSTER
        ClasseCourranteZ = data.Class(ic).IndZ;
        ClasseCourranteR = data.Class(ic).IndR;
        ClasseCourranteT = data.Class(ic).IndT;
        
        % SELECTION OF TRACES IN CLUSTER
        SelectionZ = data.Class(ic).SelectionZ;
        SelectionR = data.Class(ic).SelectionR;
        SelectionT = data.Class(ic).SelectionT;
        
        % NUMBER OF TRACES
        Ntraces = length(ClasseCourranteZ);
        
        % ANNEALING NOT RUN YET
        if (data.AnnealingRun(ic)==0); return; end
        
        mkdir(data.DirSac,'OutputFiles');
        D = datestr(now,'yyyymmddTHHMMSS');
        
        fid = fopen([data.DirSac,'/OutputFiles/',D,'_Data',data.Phase,num2str(ic),'_Zcomponent','.txt'],'w'); 
        
        % LOOP OVER TRACES IN CLUSTER
        for ii = 1:Ntraces

                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                SelectZ = data.Class(ic).SelectionZ(i)
                
                % TIME SHIFTS FROM ANNEALING
                TimeShift = data.TimeDelay(i);
                
                % STATION NAME
                StaName = data.SigFlZ(i).HdrData.KSTNM;
                
                % CORRELATION COEFFICIENT
                coherencyZ = data.CoefCorZ(i);
                
                % TIME RESIDUAL
                residualZ = data.residu(i);
                
                % STATION COORDINATES
                STLA = data.SigFlZ(i).HdrData.STLA;
                STLO = data.SigFlZ(i).HdrData.STLO;
                STEL = data.SigFlZ(i).HdrData.STEL;
                
                % EVENT COORDINATES
                EVLA = data.SigFlZ(i).HdrData.EVLA;
                EVLO = data.SigFlZ(i).HdrData.EVLO;
                EVDP = data.SigFlZ(i).HdrData.EVDP;
                
                % THEORETICAL TRAVEL TIME
                theo = data.SigInZ(i).HdrData.A;
                
                % DISTANCE
                dist = data.SigInZ(i).HdrData.GCARC;
                
                % AZIMUTH
                azi = data.SigInZ(i).HdrData.BAZ;
                
                % WRITE INTO TXT FILE
                if FilterZ == 0
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f   %-6s %3.0f %3.0f %3.0f	%-6s  %15.5f %10.5f %10.5f',...
                        SelectZ,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminZ,TmaxZ,'WWSSN_SP',TimeShift,residualZ,coherencyZ);
                    fprintf(fid,'%s\n',LINE);
                else
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f	%-6s %3.0f %3.0f %3.0f  %5.3f %5.3f  %15.5f %10.5f %10.5f',...
                        SelectZ,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminZ,TmaxZ,FrqMinZ,FrqMaxZ,TimeShift,residualZ,coherencyZ);
                    fprintf(fid,'%s\n',LINE);   
                end
                
        end
        
        fclose(fid);

        fid = fopen([data.DirSac,'/OutputFiles/',D,'_Data',data.Phase,num2str(ic),'_Rcomponent','.txt'],'w'); 
        
        % LOOP OVER TRACES IN CLUSTER
        for ii = 1:Ntraces

                % TRACE INDEX
                i = ClasseCourranteR(ii);
                
                SelectR = data.Class(ic).SelectionR(i);
                
                % TIME SHIFTS FROM ANNEALING
                TimeShift = data.TimeDelay(i);
                
                % STATION NAME
                StaName = data.SigFlR(i).HdrData.KSTNM;
                
                % CORRELATION COEFFICIENT
                coherencyR = data.CoefCorR(i);
                
                % TIME RESIDUAL
                residualR = data.residuR(i);
                
                % STATION COORDINATES
                STLA = data.SigFlR(i).HdrData.STLA;
                STLO = data.SigFlR(i).HdrData.STLO;
                STEL = data.SigFlR(i).HdrData.STEL;
                
                % EVENT COORDINATES
                EVLA = data.SigFlR(i).HdrData.EVLA;
                EVLO = data.SigFlR(i).HdrData.EVLO;
                EVDP = data.SigFlR(i).HdrData.EVDP;
                
                % THEORETICAL TRAVEL TIME
                theo = data.SigInR(i).HdrData.A;
                
                % DISTANCE
                dist = data.SigInR(i).HdrData.GCARC;
                
                % AZIMUTH
                azi = data.SigInR(i).HdrData.BAZ;
                
                % WRITE INTO TXT FILE
                if FilterR == 0
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f   %-6s %3.0f %3.0f %3.0f	%-6s  %15.5f %10.5f %10.5f',...
                        SelectR,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminR,TmaxR,'WWSSN_SP',TimeShift,residualR,coherencyR);
                    fprintf(fid,'%s\n',LINE);
                else
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f	%-6s %3.0f %3.0f %3.0f  %5.3f %5.3f  %15.5f %10.5f %10.5f',...
                        SelectR,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminR,TmaxR,FrqMinR,FrqMaxR,TimeShift,residualR,coherencyR);
                    fprintf(fid,'%s\n',LINE);   
                end
                
        end
        
        fclose(fid);
        
        fid = fopen([data.DirSac,'/OutputFiles/',D,'_Data',data.Phase,num2str(ic),'_Tcomponent','.txt'],'w'); 
        
        % LOOP OVER TRACES IN CLUSTER
        for ii = 1:Ntraces

                % TRACE INDEX
                i = ClasseCourranteT(ii);
                
                SelectT = data.Class(ic).SelectionT(i);
                
                % TIME SHIFTS FROM ANNEALING
                TimeShift = data.TimeDelay(i);
                
                % STATION NAME
                StaName = data.SigFlT(i).HdrData.KSTNM;
                
                % CORRELATION COEFFICIENT
                coherencyT = data.CoefCorT(i);
                
                % TIME RESIDUAL
                residualT = data.residuT(i);
                
                % STATION COORDINATES
                STLA = data.SigFlT(i).HdrData.STLA;
                STLO = data.SigFlT(i).HdrData.STLO;
                STEL = data.SigFlT(i).HdrData.STEL;
                
                % EVENT COORDINATES
                EVLA = data.SigFlT(i).HdrData.EVLA;
                EVLO = data.SigFlT(i).HdrData.EVLO;
                EVDP = data.SigFlT(i).HdrData.EVDP;
                
                % THEORETICAL TRAVEL TIME
                theo = data.SigInT(i).HdrData.A;
                
                % DISTANCE
                dist = data.SigInT(i).HdrData.GCARC;
                
                % AZIMUTH
                azi = data.SigInT(i).HdrData.BAZ;
                
                % WRITE INTO TXT FILE
                if FilterT == 0
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f   %-6s %3.0f %3.0f %3.0f	%-6s  %15.5f %10.5f %10.5f',...
                        SelectT,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminT,TmaxT,'WWSSN_SP',TimeShift,residualT,coherencyT);
                    fprintf(fid,'%s\n',LINE);
                else
                    LINE = sprintf('%g %-6s %7.3f %7.3f %10.1f     %7.3f %7.3f %6.1f %7.3f %6.1f	%-6s %3.0f %3.0f %3.0f  %5.3f %5.3f  %15.5f %10.5f %10.5f',...
                        SelectT,StaName,STLA,STLO,STEL,EVLA,EVLO,EVDP,dist,azi,data.Phase,theo,TminT,TmaxT,FrqMinT,FrqMaxT,TimeShift,residualR,coherencyT);
                    fprintf(fid,'%s\n',LINE);   
                end
                
        end
        
        fclose(fid);
        
        guidata(Comp_fig,data)
        
    end

%--------------------------------------------------------------------------
    function UpdateZDisplay(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        Ntraces = length(data.Class(ic).IndZ);
        
        itrace = find(gco == data.rbZ);
        
        % UPDATE SELECTION
        iselect = get(gco,'Value');
        if iselect == 0
            data.Class(ic).SelectionZ(itrace) = 0;
        elseif iselect == 1
            data.Class(ic).SelectionZ(itrace) = 1;
        end
        
        if data.AnnealingRun(ic) == 1; % annealing runned
            for ii = data.NminZ:data.NmaxZ
                set(data.rbZ(ii),'Visible','off');
                set(data.rbZ(ii),'Enable','off');
                set(data.rbZ(ii),'Interruptible','off');
            end
        end
 
        % UPDATE DISPLAY
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesZ);cla;hold on
        
        DisplayZComponent;
        
        guidata(Comp_fig,data)
        
    end

%--------------------------------------------------------------------------
    function UpdateNRDisplay(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            Ntraces = length(data.Class(ic).IndR);

            itrace = find(gco == data.rbR);

            % UPDATE SELECTION
            iselect = get(gco,'Value');
            if iselect == 0
                data.Class(ic).SelectionR(itrace) = 0;
            elseif iselect == 1
                data.Class(ic).SelectionR(itrace) = 1;
            end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminR:data.NmaxR
                    set(data.rbR(ii),'Visible','off');
                    set(data.rbR(ii),'Enable','off');
                    set(data.rbR(ii),'Interruptible','off');
                end
            end
        
        else
            Ntraces = length(data.Class(ic).IndN);

            itrace = find(gco == data.rbN);

            % UPDATE SELECTION
            iselect = get(gco,'Value');
            if iselect == 0
                data.Class(ic).SelectionN(itrace) = 0;
            elseif iselect == 1
                data.Class(ic).SelectionN(itrace) = 1;
            end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminN:data.NmaxN
                    set(data.rbN(ii),'Visible','off');
                    set(data.rbN(ii),'Enable','off');
                    set(data.rbN(ii),'Interruptible','off');
                end
            end

        end
 
        % UPDATE DISPLAY
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesNR);cla;hold on
        
        DisplayNRComponent;
        
        guidata(Comp_fig,data)
        
    end

%--------------------------------------------------------------------------
    function UpdateETDisplay(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        if data.ZRT(ic) == 1
            Ntraces = length(data.Class(ic).IndT);

            itrace = find(gco == data.rbT);

            % UPDATE SELECTION
            iselect = get(gco,'Value');
            if iselect == 0
                data.Class(ic).SelectionT(itrace) = 0;
            elseif iselect == 1
                data.Class(ic).SelectionT(itrace) = 1;
            end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminT:data.NmaxT
                    set(data.rbT(ii),'Visible','off');
                    set(data.rbT(ii),'Enable','off');
                    set(data.rbT(ii),'Interruptible','off');
                end
            end
        
        else
            Ntraces = length(data.Class(ic).IndE);

            itrace = find(gco == data.rbE);

            % UPDATE SELECTION
            iselect = get(gco,'Value');
            if iselect == 0
                data.Class(ic).SelectionE(itrace) = 0;
            elseif iselect == 1
                data.Class(ic).SelectionE(itrace) = 1;
            end

            if data.AnnealingRun(ic) == 1; % annealing runned
                for ii = data.NminE:data.NmaxE
                    set(data.rbE(ii),'Visible','off');
                    set(data.rbE(ii),'Enable','off');
                    set(data.rbE(ii),'Interruptible','off');
                end
            end

        end
 
        % UPDATE DISPLAY
        guidata(Comp_fig,data)
        
        % CHOOSE AXES1
        axes(axesET);cla;hold on
        
        DisplayETComponent;
        
        guidata(Comp_fig,data)
        
    end


% --------------------------------------------------------------------
    function UpdateStations_Callback(hObject, eventdata)
        % Write STATIONS File from TmpSTATIONS File
        % TO DO: CHECK IF TmpSTATIONS IS IN THE SAME ORDER AS StaName
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        [StationFile,Path] = uigetfile(...
            {'*.*','All Files'}, ...
            'Select Your Temporary STATIONS File');

        % CHECK FOR DATA_COMPONENTS PARAMETER
        fid = fopen([Path StationFile]);
        TmpSTA = textscan(fid,'%s	%s	%f	%f	%f	%f	%f');
        
        station = TmpSTA{1};
        net = TmpSTA{2};
        lat = TmpSTA{3};
        lon = TmpSTA{4};
        elev = TmpSTA{5};
        time = TmpSTA{6};
                       
        fclose(fid);

        fid = fopen([Path,'/','STATIONS'],'w');
            
        if data.ZRT(ic) == 1
            DataType = 'zrt';
            
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteZ = data.Class(ic).IndZ;
            ClasseCourranteR = data.Class(ic).IndR;
            ClasseCourranteT = data.Class(ic).IndT;
            
            % SELECTION OF TRACES IN CLUSTER
            SelectionZ = data.Class(ic).SelectionZ;
            SelectionR = data.Class(ic).SelectionR;
            SelectionT = data.Class(ic).SelectionT;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteZ);
            dt = data.SigFlZ(1).HdrData.DELTA;
            NbSamp = length(data.SigInZ(1).SeisData);
            
            % WRITE HEADER
            WriteHeader(fid,data.t,Ntraces,dt,NbSamp,5,5,DataType)
            
            LINE = sprintf('%s', ...
                'STARTLIST');
            fprintf(fidsta,'%s\n',LINE);

            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                % STATION NAME AND NETWORK
                StaName = data.SigFlZ(i).HdrData.KSTNM;
                Z = SelectionZ(i);
                X = SelectionR(i);
                Y = SelectionT(i);
                
                STA = station{i};
                NetWork = net{i};
                STLA = lat(i);
                STLO = lon(i);
                STEL = elev(i);
                TP = time(i);
                
                LINE = sprintf('%s	%s	%f	%f	%f	%f	%f	%f	%f', ...
                    StaName,NetWork,STLA,STLO,STEL,TP,Z,X,Y);
                fprintf(fid,'%s\n',LINE);
            end
            
        else
            DataType = 'zne';

            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteZ = data.Class(ic).IndZ;
            ClasseCourranteN = data.Class(ic).IndN;
            ClasseCourranteE = data.Class(ic).IndE;
            
            % SELECTION OF TRACES IN CLUSTER
            SelectionZ = data.Class(ic).SelectionZ;
            SelectionN = data.Class(ic).SelectionN;
            SelectionE = data.Class(ic).SelectionE;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteZ);
            dt = data.SigFlZ(1).HdrData.DELTA;
            NbSamp = length(data.SigInZ(1).SeisData);
            
            % WRITE HEADER
            WriteHeader(fid,data.t,Ntraces,dt,NbSamp,5,5,DataType)
            
            LINE = sprintf('%s', ...
                'STARTLIST');
            fprintf(fid,'%s\n',LINE);
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                % STATION NAME AND NETWORK
                StaName = data.SigFlZ(i).HdrData.KSTNM;
                Z = SelectionZ(i);
                X = SelectionN(i);
                Y = SelectionE(i);
                
                STA = station{i};
                NetWork = net{i};
                STLA = lat(i);
                STLO = lon(i);
                STEL = elev(i);
                TP = time(i);
                
                LINE = sprintf('%s	%s	%f	%f	%f	%f	%f	%f	%f', ...
                    StaName,NetWork,STLA,STLO,STEL,TP,Z,X,Y);
                fprintf(fid,'%s\n',LINE);
            end
            
        end
        
        LINE = sprintf('%s', ...
            'ENDLIST');
        fprintf(fid,'%s\n',LINE);
        
        fclose(fid)
        
        mess = msgbox('STATIONS File Saved');
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function SaveGatherBin_Callback(hObject, eventdata)
        % Write all outputs (concatenated) in binary file
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % ANNEALING NOT RUN YET
        if (data.AnnealingRun(ic)==0);
            mess = msgbox('Annealing Not Done Yet');
            return;
        end
        
        if isfield(data,'OutputDir') == 0
            data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
        end

        E = exist([data.OutputDir,'/','Gather.bin'],'file');
        
        if E == 2        
            
            choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                'DATA File already exists', ...
                'Yes','No','Yes');
            
            switch choice
                case 'Yes'
                    fid = fopen([data.OutputDir,'/','Gather.bin'],'w');
                    
                case 'No'
                    OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                    fid = fopen([OutputDir2,'/','Gather.bin'],'w');
            end
            
        else 
            fid = fopen([data.OutputDir,'/','Gather.bin'],'w');
            
        end
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteZ = data.Class(ic).IndZ;
            ClasseCourranteR = data.Class(ic).IndR;
            ClasseCourranteT = data.Class(ic).IndT;

            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteZ);
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                % SELECTION OF TRACES IN CLUSTER
                SelectionZ = data.Class(ic).SelectionZ;
                DataZ = data.SigInZ(i).SeisDataAlign(:)*SelectionZ;
                fwrite(fid,DataZ,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)

            fid = fopen([data.OutputDir,'/','Gather.bin'],'a+');
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteR(ii);
                
                % SELECTION OF TRACES IN CLUSTER
                SelectionR = data.Class(ic).SelectionR;
                DataR = data.SigInR(i).SeisDataAlign(:)*SelectionR;
                fwrite(fid,DataR,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)
            
            fid = fopen([data.OutputDir,'/','Gather.bin'],'a+');
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteT(ii);
                
                % SELECTION OF TRACES IN CLUSTER
                SelectionT = data.Class(ic).SelectionT;
                DataT = data.SigInT(i).SeisDataAlign(:)*SelectionT;
                fwrite(fid,DataT,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)
            
        else
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteZ = data.Class(ic).IndZ;
            ClasseCourranteN = data.Class(ic).IndN;
            ClasseCourranteE = data.Class(ic).IndE;

            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteZ);
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                
                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                % SELECTION OF TRACES IN CLUSTER
                SelectionZ = data.Class(ic).SelectionZ(i);
                DataZ = data.SigInZ(i).SeisDataAlign(:)*SelectionZ;
                fwrite(fid,DataZ,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)
            
            fid = fopen([data.OutputDir,'/','Gather.bin'],'a+');
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteN(ii);
                
                % SELECTION OF TRACES IN CLUSTER
                SelectionN = data.Class(ic).SelectionN(i);
                DataN = data.SigInN(i).SeisDataAlign(:)*SelectionN;
                fwrite(fid,DataN,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)
            
            fid = fopen([data.OutputDir,'/','Gather.bin'],'a+');
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteE(ii);
                                
                % SELECTION OF TRACES IN CLUSTER
                SelectionE = data.Class(ic).SelectionE(i);
                DataE = data.SigInE(i).SeisDataAlign(:)*SelectionE;
                fwrite(fid,DataE,'float32'); % if it doesn't work; try with transposed Data
            end
            fclose(fid)
            
        end
       
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function SaveZGatherBin_Callback(hObject, eventdata)
        % Write Z outputs in binary file
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % ANNEALING NOT RUN YET
        if (data.AnnealingRun(ic)==0);
            mess = msgbox('Annealing Not Done Yet');
            return;
        end
        
        % INDICES OF TRACES INSIDE CLUSTER
        ClasseCourranteZ = data.Class(ic).IndZ;
        
        % NUMBER OF TRACES
        Ntraces = length(ClasseCourranteZ);
        
        if isfield(data,'OutputDir') == 0
            data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
        end

        E = exist([data.OutputDir,'/','GatherZ.bin'],'file');
        
        if E == 2        
            
            choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                'DATA File already exists', ...
                'Yes','No','Yes');
            
            switch choice
                case 'Yes'
                    fid = fopen([data.OutputDir,'/','GatherZ.bin'],'w');
                    
                case 'No'
                    OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                    fid = fopen([OutputDir2,'/','GatherZ.bin'],'w');
            end
            
        else 
            fid = fopen([data.OutputDir,'/','GatherZ.bin'],'w');
            
        end
        
        % LOOP OVER TRACES IN CLUSTER
        for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteZ(ii);
                
                Select = data.Class(ic).SelectionZ(i);
                Data = data.SigInZ(i).SeisDataAlign(:)*Select;
                fwrite(fid,Data,'float32'); % if it doesn't work; try with transposed Data  
        end
        
        fclose(fid)
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function SaveGatherNRBin_Callback(hObject, eventdata)
        % Write N / R outputs in binary file
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % ANNEALING NOT RUN YET
        if (data.AnnealingRun(ic)==0);
            mess = msgbox('Annealing Not Done Yet');
            return;
        end
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteR = data.Class(ic).IndR;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteR);
            
            if isfield(data,'OutputDir') == 0
                data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
            end
            
            E = exist([data.OutputDir,'/','GatherR.bin'],'file');
            
            if E == 2
                
                choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                    'DATA File already exists', ...
                    'Yes','No','Yes');
                
                switch choice
                    case 'Yes'
                        fid = fopen([data.OutputDir,'/','GatherR.bin'],'w');
                        
                    case 'No'
                        OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                        fid = fopen([OutputDir2,'/','GatherR.bin'],'w');
                end
                
            else
                fid = fopen([data.OutputDir,'/','GatherR.bin'],'w');
                
            end
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteR(ii);
                
                Select = data.Class(ic).SelectionR(i);
                Data = data.SigInR(i).SeisDataAlign(:)*Select;
                fwrite(fid,Data,'float32'); % if it doesn't work; try with transposed Data
            end
            
            fclose(fid)
        
        else
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteN = data.Class(ic).IndN;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteN);
            
            if isfield(data,'OutputDir') == 0
                data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
            end
            
            E = exist([data.OutputDir,'/','GatherN.bin'],'file');
            
            if E == 2
                
                choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                    'DATA File already exists', ...
                    'Yes','No','Yes');
                
                switch choice
                    case 'Yes'
                        fid = fopen([data.OutputDir,'/','GatherN.bin'],'w');
                        
                    case 'No'
                        OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                        fid = fopen([OutputDir2,'/','GatherN.bin'],'w');
                end
                
            else
                fid = fopen([data.OutputDir,'/','GatherN.bin'],'w');
                
            end
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteN(ii);
                
                Select = data.Class(ic).SelectionN(i);
                Data = data.SigInN(i).SeisDataAlign(:)*Select;
                fwrite(fid,Data,'float32'); % if it doesn't work; try with transposed Data
            end
            
            fclose(fid)
        end
        
        guidata(Comp_fig,data)
        
    end

% --------------------------------------------------------------------
    function SaveGatherETBin_Callback(hObject, eventdata)
        % Write E / T outputs in binary file
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % ANNEALING NOT RUN YET
        if (data.AnnealingRun(ic)==0);
            mess = msgbox('Annealing Not Done Yet');
            return;
        end
        
        if data.ZRT(ic) == 1
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteT = data.Class(ic).IndT;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteT);
            
            if isfield(data,'OutputDir') == 0
                data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
            end
            
            E = exist([data.OutputDir,'/','GatherT.bin'],'file');
            
            if E == 2
                
                choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                    'DATA File already exists', ...
                    'Yes','No','Yes');
                
                switch choice
                    case 'Yes'
                        fid = fopen([data.OutputDir,'/','GatherT.bin'],'w');
                        
                    case 'No'
                        OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                        fid = fopen([OutputDir2,'/','GatherT.bin'],'w');
                end
                
            else
                fid = fopen([data.OutputDir,'/','GatherT.bin'],'w');
                
            end
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteT(ii);
                
                Select = data.Class(ic).SelectionT(i);
                Data = data.SigInT(i).SeisDataAlign(:)*Select;
                fwrite(fid,Data,'float32'); % if it doesn't work; try with transposed Data
            end
            
            fclose(fid)
        
        else
            % INDICES OF TRACES INSIDE CLUSTER
            ClasseCourranteE = data.Class(ic).IndE;
            
            % NUMBER OF TRACES
            Ntraces = length(ClasseCourranteE);
            
            if isfield(data,'OutputDir') == 0
                data.OutputDir = uigetdir(data.Data_Dir,'Create An Output Directory');
            end
            
            E = exist([data.OutputDir,'/','GatherE.bin'],'file');
            
            if E == 2
                
                choice = questdlg('DATA File already exists, do you want to replace it ?', ...
                    'DATA File already exists', ...
                    'Yes','No','Yes');
                
                switch choice
                    case 'Yes'
                        fid = fopen([data.OutputDir,'/','GatherE.bin'],'w');
                        
                    case 'No'
                        OutputDir2 = uigetdir(data.Data_Dir,'Create Another Output Directory');
                        fid = fopen([OutputDir2,'/','GatherE.bin'],'w');
                end
                
            else
                fid = fopen([data.OutputDir,'/','GatherE.bin'],'w');
                
            end
            
            % LOOP OVER TRACES IN CLUSTER
            for ii = 1:Ntraces
                % TRACE INDEX
                i = ClasseCourranteE(ii);
                
                Select = data.Class(ic).SelectionE(i);
                Data = data.SigInE(i).SeisDataAlign(:)*Select;
                fwrite(fid,Data,'float32'); % if it doesn't work; try with transposed Data
            end
            
            fclose(fid)
        end
        
        guidata(Comp_fig,data)
        
    end

%--------------------------------------------------------------------------
    function StackRT_CoefCor(hObject, eventdata)
        
        data = guidata(Comp_fig);
        
        % GET CLUSTER INDEX
        ic = (get(listbox1,'value'));
        
        % GET R PARAMETERS
        NtracesR = length(data.Class(ic).IndR);
        dtR = data.SigFlR(1).HdrData.DELTA;
        
        % GET T PARAMETERS
        NtracesT = length(data.Class(ic).IndT);
        dtT = data.SigFlR(1).HdrData.DELTA;
        
        % SELECTION OF R TRACES IN CLUSTER
        SelectionR = data.Class(ic).SelectionR;
        NbSelectedR = length(find(SelectionR));
        IndexSelectedR = find(SelectionR);
        
        % SELECTION OF T TRACES IN CLUSTER
        SelectionT = data.Class(ic).SelectionT;
        NbSelectedT = length(find(SelectionT));
        IndexSelectedT = find(SelectionT);
        
        % GET R TIME BEFORE THEORETICAL P ARRIVAL
        TminR = str2double(get(edit6,'String'));
        TmaxR = str2double(get(edit7,'String'));
        
        % GET T TIME BEFORE THEORETICAL P ARRIVAL
        TminT = str2double(get(edit11,'String'));
        TmaxT = str2double(get(edit12,'String'));
        
        guidata(Comp_fig,data)
        
    end

end
