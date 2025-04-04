function AddTrace(SeisData,Tb,Dt,i)

if length(SeisData) == 0; return; end
Time = (0:Dt:(length(SeisData)-1)*Dt)';
ax = Tb+Time;
plot(ax,i-SeisData/(2*max(abs(SeisData))),'r','linewidth',2);
