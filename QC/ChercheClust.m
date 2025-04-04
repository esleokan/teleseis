function [nf]=ChercheClust(Eq)
% Determines the cluster index of each trace
% See Numerical algorithms page 338
%   [n] = ChercheClust(E) where E(i,j) is a matrix containing
%   the value .true. if its elements i and j are connected
%   and .false. if not
%   n is a vector containing the cluster index of each element

n=size(Eq,1);

nf(1)=1;
for i=2:1:n
    nf(i)=i;
    for j=1:1:i-1
        nf(j)=nf(nf(j));
        if Eq(i,j) == 1; nf(nf(nf(j)))=i; end
    end;
end;
for i=1:1:n
    nf(i)=nf(nf(i));
end;
