function AddTraceK(SeisData,Tb,Dt,i)

if length(SeisData) == 0; return; end
Time = (0:Dt:(length(SeisData)-1)*Dt)';

plot(Tb+Time,i+SeisData/(2*max(abs(SeisData))),'Color','g','linewidth',1);
