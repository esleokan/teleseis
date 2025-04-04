% all phases
phases='P';% s P S pP sS Pn Sn PcP ScS Pdiff Sdiff PKP SKS PKiKP SKiKS PKIKP SKIKS';

% phases for dist min
tt0=tauptime('mod','ak135','dep',handles.DataIn(1).HdrData.EVDP,'ph',phases,'deg',d0);

% phases for dist max
tt1=tauptime('mod','ak135','dep',handles.DataIn(1).HdrData.EVDP,'ph',phases,'deg',d1);

k=0;
for i=1:1:size(tt0,2)
    if tt0(i).time > t0 && tt0(i).time < t1
        k=k+1;
        PhasesForDistMin{k}=tt0(i).phase;
    end
end

k=0;
for i=1:1:size(tt1,2)
    if tt1(i).time > t0 && tt1(i).time < t1
        k=k+1;
        PhasesForDistMax{k}=tt1(i).phase;
    end
end

% intersection
k=0;
for i=1:1:size(PhasesForDistMin,2)
    for j=1:1:size(PhasesForDistMax,2)
        if strcmp(PhasesForDistMin{i},PhasesForDistMax{j})==1
            k=k+1;
            PhasesPot{k}=PhasesForDistMax{j};
        end
    end
end

% slect phase
[Selection,ok]=listdlg('PromptString','Choose Phase','ListString',PhasesPot);

% defaut phase if the first one
if ok ~= 1
    Selection=1;
end

% set selectables phases in menu
set(handles.popupmenu1,'String',PhasesPot);
set(handles.popupmenu1,'Value',Selection);



