function txt = myupdatefcn(trash,event)
pos = get(event,'Position');
dts = get(event.Target,'Tag');
txt = {dts};