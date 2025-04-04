%% Sort Synthetic Traces by distance using the sorting order of existing real data
function [StrcOut,Stations,NbCommon]=CompareSacSem(SacStrct,SemList,StrcIn)

for i = 1:length(SacStrct)
    SacList(i).name = cellstr(SacStrct(i).HdrData.KSTNM);
end

if length(SacList) > length(SemList)
    for i = 1:length(SacList)
        for j = 1:length(SemList)
            if (strcmp(SacList(i).name,SemList(j)) == 1)
                StrcOut(i) = StrcIn(j);
                Stations(i) = SemList(j);
            end
        end
    end
else
    for i = 1:length(SemList)
        for j = 1:length(SacList)
            if (strcmp(SacList(j).name,SemList(i)) == 1)
                StrcOut(j) = StrcIn(i);
                Stations(j) = SemList(i);
            end
        end
    end
end

NbCommon = length(Stations);

