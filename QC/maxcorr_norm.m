function [maxcorr] = maxcorr_norm(A,maxlags);

npts = size(A,1);
ntraces = size(A,2);
maxcorr = zeros(ntraces,ntraces);

Af = fft(A);

% Computes cross-correlation (numerator)
for i = 1:ntraces
  for j = i:ntraces
    Cf = Af(:,i).*conj(Af(:,j));
    C = real(ifft(Cf));
    C2 = real(ifft(Cf))./(norm(A(:,i))*norm(A(:,j)));
    cm = max(C2);
    maxcorr(i,j) = cm;
    maxcorr(j,i) = cm;
  end
end
