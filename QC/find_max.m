function [xmax,tmax,n] = find_max(x,dt)

% Input
%   - x : vector containing function
%   - dt : time sampling
% Output 
%   - xmax : Maximum of function x determined by polynomial interpolation

[xx,n] = max(x);

if (n == length(x))
  tmax = (n+1)*dt;
  xmax = x(n); 
elseif (n > 1)
  p1 = x(n-1);
  p2 = x(n);
  p3 = x(n+1);
  x1 = (n-1)*dt;
  x2 = n*dt;
  x3 = (n+1)*dt;
  tmax = ((x2+x3)*p1-2.*(x1+x3)*p2+(x1+x2)*p3)/(2.*(p1-2.*p2+p3));
  xmax = ((tmax^2-(x2+x3)*tmax+x2*x3)*p1+(-tmax^2+(x1+x3)*tmax-x1*x3)*p2)/((x1-x3)*(x1-x2))...
  +((-tmax^2+(x1+x3)*tmax-x1*x3)*p2+(tmax^2-(x1+x2)*tmax+x1*x2)*p3)/((x1-x3)*(x2-x3));
elseif (n == 1)
  tmax = dt;
  xmax = x(1);
end
