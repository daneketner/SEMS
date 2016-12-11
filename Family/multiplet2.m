function M = multiplet2(wfa,cc)
%
%MULTIPLET2 attempts to cross-correlate all waveforms

wfa = fix_data_length(wfa);
nw = numel(wfa);
L = get(wfa(1),'data_length');
M = cell(1,nw);
lag = (1/get(wfa(1),'freq'))*[-L+1:L-1]';     
tic;
for k = 1:nw-1;
   d1 = double(wfa(k));
   c1 = 1./sqrt(sum(d1.*d1));
   X1 = fft(d1,2^nextpow2(2*L-1));
   for kk = k+1:nw
      d2 = double(wfa(kk));
      c2 = 1./sqrt(sum(d2.*d2));
      Xc2 = conj(fft(d2,2^nextpow2(2*L-1)));
      CC = X1.*Xc2;
      corr = ifft(CC);
      corr = [corr(end-L+2:end,:);corr(1:L,:)];
      [maxval,index] = max(corr);
      maxval=maxval*c1*c2;
      if maxval>cc
         M{k} = [M{k}; kk, maxval, lag(index)];
      end
   end
end
toc

% N = ceil(numel(wfa)/2000);
% d = zeros(801,32788);
% for n = 1:N-1
%    d((n-1)*2000+1:n*2000) = double(wfa((n-1)*2000+1:n*2000))];
% end
% d = [d double(wfa((N-1)*2000+1:end))];
      