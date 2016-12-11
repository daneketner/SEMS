function out = max_energy(w,win_l,varargin)

%MAX_ENERGY: Extract the most energetic 'abs(demean(amplitude))' portion of
%   a waveform or waveform array
%
%USAGE: out = max_energy(w,win_l)
%
%INPUTS: w - waveform object
%        win_l - window length 
%
%OUTPUTS: out - maximum energy window start/stop times

%% Check varargin size
nv = numel(varargin);
if nv > 1
   error('max_ernergy: Too many arguments')
end

%% User-defined parameters (varargin)

nw = numel(w);
w = demean(w);
M =[];
I1 = [];
I2 = [];
for n = 1:nw
   dat = abs(get(w(n),'data'));
   dat_l = get(w(n),'data_length');
   Fs = get(w(n),'freq');
   t1 = 1;
   t2 = round(win_l*Fs);
   win_n = 1;

   if t2<dat_l
      while t2<dat_l
         sum_win(win_n) = sum(dat(t1:t2));
         t1 = t1+1;
         t2 = t2+1;
         win_n = win_n+1;
      end
      [M(n) I1(n)] = max(sum_win);
      I2(n) = I1(n)+floor(win_l*Fs)-1;
      max_w(n) = extract(w(n),'index',I1(n),I2(n));
      clear sum_win
   else
      max_w(n) = w(n);
   end
end

if nv == 1
v = varargin{1};
switch lower(v)
   case 'wave','waveform','w','wf','wfa'
 out = max_w;
   case {'start','start time','st','t1'}
      out = get(w,'start'); 
   case {'sst','start stop times'}
      out = wfa2sst;
   case {'si','index','start index'} 
      out = I1;
   case {'ssi','start stop index'}       
      out = [I1; I2]; % Test this
   otherwise

end
else
   out = max_w;
end


