function [Ic,rr] = CalculeCouleur(r,c)

nres = length(r);
nn = 0;
rmin = 1000;
rmax = -1000;
mean_res = 0;
for i = 1:nres
  if r(i) < 900
    nn = nn+1;
    mean_res = mean_res+r(i);
    if r(i) < rmin
      rmin = r(i);
    end
    if r(i) > rmax
      rmax = r(i);
    end
  end
end
mean_res = mean_res/nn;
rmin = rmin-mean_res;
rmax = rmax-mean_res;

%for i = 1:nres
%  if r(i) < 900
%  end
%end

%rmin = min(r);
%rmax = max(r);
rmax = max(abs(rmin),abs(rmax));
rmin = -rmax;
n = length(c);

for i = 1:nres
  if r(i) < 900
    Ic(i) = floor(((n-1)/(rmax-rmin)).*(r(i)-mean_res-rmin)+1);
  else
    Ic(i) = floor(((n-1)/(rmax-rmin)).*(-rmin)+1);
  end
end

rr(1,1) = rmax;
rr(2,1) = rmax/2;
rr(3,1) = 0;
rr(4,1) = -rmax/2;
rr(5,1) = -rmax;


for i = 1:5
  rr(i,2) = floor(((n-1)/(rmax-rmin)).*(rr(i,1)-rmin)+1);
end
