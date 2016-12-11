function [t r] = bin_rms(w, bin)

tv = get(w,'timevector');
t1 = tv(1);
t2 = tv(end);
N = ceil((t2-t1)/bin);
for n = 1:N
   t(n) = t1+(n-1)*bin;
   r(n) = rms(extract(w,'TIME',t(n),t(n)+bin));
end

%%  CODE FOR ITERATIVELY BUILDING BIN RMS ARRAY
%t = [];
%r = [];
%for n = 10:-1:1
%   w = get_w(ds,scnl,now-n,now-n+1);
%   [tt rr] = bin_rms(w, 1/24/6);
%   t = [t tt];
%   r = [r rr];
%end
%figure, plot(t,r)