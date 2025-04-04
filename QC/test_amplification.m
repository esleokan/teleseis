
% Vp/Vs ratio
r = 3.;
p = 6.5;

% Shear velocity
Vs = [1:0.1:3.5];
Vp = r.*Vs;
% Ray parameter
deg2rad = pi/180;
R0 = 6371;
deg2km = pi*R0/180;

e = asin(p/deg2km.*Vp)/deg2rad;
f = asin(p/deg2km.*Vs)/deg2rad;

N = 2*r^2.*cos(e*deg2rad);
D = sin(2.*e*deg2rad).*sin(2.*f*deg2rad)+r^2*cos(2.*f*deg2rad).^2;
Amp = N./D;

figure(1)
clf
hold on
plot(Vs,Amp,'r')
plot(Vs,cos(2.*f*deg2rad).*Amp)
