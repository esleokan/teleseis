function [Cor, Cor_max, tmax] = correl_max_int( R, W, npt, dt, tshift_max )
%

nfft = 2^nextpow2(npt);

nshift = floor(tshift_max/dt)+1;
n1 = nfft/2+1-nshift;
n2 = nfft/2+1+nshift;

% Do cross correlation with W in freq
x = real(ifft( fft(R,nfft).*conj(fft(W,nfft)), nfft));

Cor = fftshift(x);

[Cor_max,tmax] = find_max(Cor(n1:n2),dt);
tmax = tmax+(n1-1)*dt;

tmax = (nfft/2+1)*dt-tmax;
