tt = tauppath('Model','prem','Evdp',40,'Degrees',30,'Phases','P');
takeoff_z = tt(1).path.depth(2) - tt(1).path.depth(1);
takeoff_x = deg2km(tt(1).path.distance(2) - tt(1).path.distance(1));
tan_theta = atand(takeoff_x/takeoff_z)

