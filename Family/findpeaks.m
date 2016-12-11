function [p_time p_val] = findpeaks(w,min,space)
%
%FINDPEAKS: Return array of peak times and peak values from a waveform 
%           object above theshhold 'min' which are at least 'space' seconds 
%           apart. If more than one peak exists in the span of 'space' 
%           seconds, then the largest of the peaks is returned
%
%USAGE: [p_time p_val] = findpeaks(w,min,space)
%
%DIAGRAM:                  
%          |-(space)-|                      /\  
%      /\              /\                /\/  \  ___ (min)                                   
%     /  \            /  \              /      \                                   
%/\/\/    \/\/\/\/\/\/    \/\/\/\/\/\/\/        \/\/\/\/\/\
%       |               |                    |
%       p_time(1)       p_time(2)            p_time(3)
%       p_val(1)        p_val(2)             p_val(3)
%
%INPUTS: w - a waveform object
%        min - minimum peak amplitude theshold
%        space (s) - if peaks are not at least this far apart, return
%                    largest, use space = 0 for no spacing constraint
%
%OUTPUTS: p_time - Matlab datenum values of peak times
%         p_val  - corresponding peak values

if isa(w,'waveform')
    dat = get(w,'data');
    dat_l = get(w,'data_length');
    Fs = get(w,'freq');
    tv = get(w,'timevector');
    space = space*Fs;
elseif isnumeric(w)
    dat = w;
    dat_l = length(w);
    tv = 1:dat_l;
end

dif_dat = diff(dat);     % Data slope
pos = (dif_dat > 0);     % Indices of positive slope
neg = (dif_dat < 0);     % Indices of negative slope
pos02 = pos(1:dat_l-2);  % pos (w/out last 2 data points)
neg11 = neg(2:dat_l-1);  % neg (w/out first and last data points)

peaks = find(pos02&neg11)+1;      % positive peaks (+ to -)
peaks = peaks.*(dat(peaks)>=min); % positive peaks above min
peaks = peaks(peaks~=0);          % remove zero indices
p_val = dat(peaks);               % correlation values

k = 1;                            % If 2 peaks are closer than space,
while k < numel(peaks)            % Remove the lesser of the 2     
   if peaks(k)>=peaks(k+1)-space
      [Y I] = max([dat(peaks(k)) dat(peaks(k+1))]);
      peaks(k+2-I) = [];
   else
      k = k+1;
   end
end
      
p_time = tv(peaks); % return as datenum values from timevector

% figure
% plot(tv,dat)
% hold on
% plot(tv(peaks),dat(peaks),'o')

% figure
% plot(c_val)

