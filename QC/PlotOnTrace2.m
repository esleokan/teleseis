function [t0,t1,h] = PlotOnTrace2(SeisData,Tb,Dt,i,color)

if length(SeisData) == 0; return; end
Time = (0:Dt:(length(SeisData)-1)*Dt)';
%h = plot(Tb+Time,i-SeisData/(2*max(abs(SeisData))),'k','LineWidth',2);
h = plot(Tb+Time,i-SeisData/(2*max(abs(SeisData))),'k','LineWidth',2,'Color',color);

t0 = min(Time);
t1 = max(Time);
