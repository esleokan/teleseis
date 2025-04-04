function AddAllTrace(SeisData,L,Tb,Dt,i)

if length(SeisData) == 0; return; end
Time = (0:Dt:(L-1)*Dt)';
plot(Tb+Time,i+SeisData/(2*max(abs(SeisData))),'b','linewidth',1.5);
