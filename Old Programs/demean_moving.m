function w = demean_moving(w,l,unit)

dat = get(w,'data');
dat_l = get(w,'data_length'); 
switch lower(unit)
   case 's'
      Fs = get(w,'freq');
      l = l*Fs;
   case 'd'
end

% l = 10
% dat_l = 100


% demean point based on averaged window to right of data point
r_dat = dat*0;
for n = 1:dat_l-l
   r_dat(n) = dat(n)-mean(dat(n:n+l-1));
end
r_dat(end-l+1:end) = dat(end-l+1:end)-mean(dat(end-l+1:end));

% demean point based on averaged window to right of data point
l_dat = dat*0;
for n = l:dat_l
   l_dat(n) = dat(n)-mean(dat(n-l+1:n));
end
l_dat(1:l-1) = dat(1:l-1)-mean(dat(1:l-1));

dat = (r_dat+l_dat)/2;

w = set(w,'data',dat);
   