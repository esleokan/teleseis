%function [StrcOut,distmin,distmax,bazmin,bazmax,dist,tmin,tmax,smean,I,CellSacName] = ReadAllSacFile(Repertoire,SacTag)
%function [StrcOut,distmin,distmax,bazmin,bazmax,dist,tmin,tmax,smean,I,CellSacName2] = ReadAllSacFile(Repertoire,SacTag)
function [StrcOut,distmin,distmax,bazmin,bazmax,gcarc,tmin,tmax,I,CellSacName2] = ReadAllSacFile(Repertoire,SacTag)

SacTag = ['*',SacTag];
SacLi = dir(fullfile(Repertoire,SacTag));

% liste des fichiers sac ayant pour extension SacTag dans le repertoire
% Repertoire
CellSacName = cell(length(SacLi),1);
for i = 1:length(SacLi)
    CellSacName(i) = cellstr(SacLi(i).name);
end

% liste SAC dans l'ordre alphab
SacList = sort(CellSacName);  
NbSacFile = length(SacList);

h = waitbar(0,'Sac file reading');

distmin = 180;
distmax = 0;

bazmin = 360;
bazmax = 0;

tmin = 1e6;
tmax = 0;

slowness=0;
isac = 0;
gcarc = [];
for ii = 1:NbSacFile
    waitbar(isac/NbSacFile);
    
%  lecture du fichier sac    
    Fich = fullfile(Repertoire,SacList{ii});
    HdrData = readsac(Fich);

    SeisData = HdrData.DATA1;
    smin = min(SeisData);
    smax = max(SeisData);
%    [isac 1e9*smin 1e9*smax] 

    %if (abs(smax) > 1e-9) 

      isac = isac + 1;

      distmin = min(HdrData.GCARC,distmin);
      distmax = max(HdrData.GCARC,distmax);

      bazmin = min(HdrData.BAZ,bazmin);
      bazmax = max(HdrData.BAZ,bazmax);
    
      slowness = slowness + HdrData.USER0;

      tmin = min(tmin,HdrData.B-HdrData.O);
      tmax = max(tmax,HdrData.B-HdrData.O+(HdrData.NPTS-1)*HdrData.DELTA);

      gcarc(isac) = HdrData.GCARC;
    
      StrcOut1(isac).HdrData = HdrData;
      StrcOut1(isac).SeisData = HdrData.DATA1;

    %end
end

isac=length(gcarc);
NbSacFile = isac;

%smean = slowness / NbSacFile

[Y,I] = sort(gcarc);

for isac = 1:NbSacFile
  StrcOut(isac).HdrData = StrcOut1(I(isac)).HdrData;
  StrcOut(isac).SeisData = StrcOut1(I(isac)).SeisData;
%  StrcOut(isac).HdrData.GCARC;
  CellSacName2(isac) = CellSacName(I(isac));
end

close(h)
