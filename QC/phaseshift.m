function [x_out] = phaseshift(x_in,npt,dt,tshift)

%
%  Add a shift to the data

nfft = 2^(nextpow2(npt)+2);
% into the freq domain
Xf = fft(x_in,nfft);

% phase shift in radians
Fn = 1./(2*dt);
df = 1./(nfft*dt);
f = [0:nfft/2 -(nfft/2)+1:-1].*df;

% apply shift
Xf = Xf.*exp(-i*2*pi*f*tshift);

% back into time
x = real( ifft(Xf, nfft) );

x_out(1:npt) = x(1:npt);

return

