function M = readcmt_localfile(filename)
M=zeros(6,1);

fid = fopen(filename,'r');

for i=1:7
    lix = fgets(fid);
end
for i=8:13
    lix = fgets(fid);
    M(i-7) = str2double(lix(8:end));
end
