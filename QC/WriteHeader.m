function WriteHeader(fidsta,EVENT,NbSta,dt,NbSamp,Tmin,Tmax,DataType)

com = '########################################################################################################################';    

% Beginning of the Header
LINEsta = sprintf('%s', ...
    com);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                                                     STATION FILE                                                     #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    com);
fprintf(fidsta,'%s\n',LINEsta);

% Description of the content of the header
LINEsta = sprintf('%s', ...
    '#                                                  Source Description                                                  #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - source_components:    CMTSOLUTION file for moment                                                                  #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         fx fy fz lat lon elev YYYY MM DD HH MM SS.SSS for force                                      #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - modeling_tool:        Traction Directory for AXISEM                                                                #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         FK_Par_File for FK                                                                           #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         PW_Par_File for PW                                                                           #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - data_components:      V    ZNE                                                                                     #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         U = displacement V = Velocity A = Acceleration                                               #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         ZNE    geographic coordinates with Z toward up                                               #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         ZXY    local cartesian coordinates                                                           #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         ZRT    Vertical Radial Transverse                                                            #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '#                         LQT    Ray Based P, Sv, Sh                                                                   #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - cartloc_mesh_origin:  LAT LON of the center of the mesh AZI (angle from east to north)                             #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - time_window:          true    seconds_before_pick    seconds_after_pick                                            #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - station_coord_system:          cart or geo                                                                         #');
fprintf(fidsta,'%s\n',LINEsta);

LINEsta = sprintf('%s', ...
    com);
fprintf(fidsta,'%s\n',LINEsta);

% Event
LINEsta = sprintf('%s	%s', ...
    'event_name',EVENT);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s', ...
    'source_type','moment');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s', ...
    'source_components','CMTSOLUTION');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s%f', ...
    'modeling_tool','AxiSEM	boundary_sol/EVENT');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s	%s', ...
    'data_components','v',DataType);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s	%s	%s', ...
    'cartloc_mesh_origin','42.2','1.5','0');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s', ...
    'data_origin_time','0');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%.0f', ...
    'number_of_stations',NbSta);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%f', ...
    'data_time_step',dt);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%.0f', ...
    'data_number_of_sample',NbSamp);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s', ...
    'is_time_pick','true');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s	%f	%f', ...
    'time_window','true',Tmin,Tmax);
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s	%s', ...
    'station_coord_system','geo');
fprintf(fidsta,'%s\n',LINEsta);

% Last Part
LINEsta = sprintf('%s', ...
    com);
fprintf(fidsta,'%s\n',LINEsta);

LINEsta = sprintf('%s', ...
    '#                                                 Stations Description                                                 #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - Must beginwith STARTLIST and end with ENDLIST                                                                      #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - NAME NETWORK LAT LON ELEV PICK Z X Y                                                                               #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - ELEV (up positive)                                                                                                 #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - Z X Y  = 0 or 1                                                                                                    #');
fprintf(fidsta,'%s\n',LINEsta);
LINEsta = sprintf('%s', ...
    '# - Describe if trace is kept for inversion (Weight parameter to write .bin)                                           #');
fprintf(fidsta,'%s\n',LINEsta);

LINEsta = sprintf('%s', ...
    com);
fprintf(fidsta,'%s\n',LINEsta);
% End of Header