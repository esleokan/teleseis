function CMAP=RtoB(n)

Red=[1 0 0];
Blue=[0 0 1];
White=[1 1 1];
for i=1:1:n
    CMAP(i,:)=Red*(n-i)/(n-1)+White*(i-1)/(n-1);
end

k=n;
for i=2:1:n
    k=k+1;
    CMAP(k,:)=White*(n-i)/(n-1)+Blue*(i-1)/(n-1);
end