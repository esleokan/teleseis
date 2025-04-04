function [s_out,tsh_out] = aligne_trace_cc_int(s,dt,Tmin,Tmax,tshmax)
%function [s_out,tsh] = aligne_trace_cc(s,dt,Tmin,Tmax)
% aligne signals in array s on the average aligned trace 
% computed in time windows between Tmin and Tmax
% alignment determined by cc with the average aligned trace
% input  s       : array containing signals
%        dt      : Time step
%        Tmin    : Start time window
%        Tmax    : End time window
% output s_out   : aligned traces
%        tsh_out : time shifts
%
% S. Chevrot April 2016

A = size(s);
Ntraces = A(1);
Npoints = A(2);
ndeb = floor(Tmin/dt)+1;
nfin = floor(Tmax/dt)+1;
npts = nfin-ndeb+1;
s1 = s(1,ndeb:nfin);
s_out(1,:) = s(1,:);
tsh_out(1) = 0;
tsh(1) = 0;

% Compute average trace
for k = 1:Ntraces
  s2 = s(k,ndeb:nfin);
  [Cor,Cor_max,tshift] = correl_max_int(s1,s2,npts,dt,tshmax);
  tshift = -tshift;
%  s3(k,:) = phaseshift(s(k,:),Npoints,dt,tshift);
  s3(k,:) = phaseshift(s2,npts,dt,tshift);
  tsh(k) = tshift;
end

tsh_mean = mean(tsh);
s_ave = sum(s3);
%s_ave = phaseshift(s_ave,Npoints,dt,tsh_mean);

% Align on the average trace
for k = 1:Ntraces
  s2 = s(k,ndeb:nfin);
%  [Cor,Cor_max,tshift] = correl_max(s_ave,s2,npts,dt);
  [Cor,Cor_max,tshift] = correl_max_int(s1,s2,npts,dt,tshmax);
%  [smax,tshift] = find_max(Cor,dt);
%  tshift = -round(tshift/dt)*dt;
  tshift = -tshift;
  s_out(k,:) = phaseshift(s(k,:),Npoints,dt,tshift);
  [k tshift];
  tsh_out(k) = tshift;
end
