function w = remove_spike(w,fill)

%REMOVE_SPIKE: Manually select spikes (or other sections of interest) from
%   input waveform 'w' using the GUI 'event_pick'. These sections are
%   removed in the output waveform anf filled with method specified in 
%   'fill'. 
%
%USAGE: w = remove_spike(w,fill)
%
%INPUTS: w
%        
%OUTPUTS: w

s = get(w,'start');
d = get(w,'data');
sst = event_pick(w); sst = sst{:};
ssd = sst2ssd(sst,w);

for n=1:size(ssd,1)
    d1 = ssd(n,1); 
    d2 = ssd(n,2);
    if strcmpi(fill,'nan')
    d(d1:d2)=nan;
    elseif strcmpi(fill,'zero')
    d(d1:d2)=0;
    elseif strcmpi(fill,'line')
    d(d1:d2)=linspace(d(d1),d(d2),d2-d1+1);
    elseif strcmpi(fill,'median')
    d(d1:d2)=median(w);
    elseif strcmpi(fill,'mean')
    d(d1:d2)=mean(w);
    end
end
w = set(w,'data',d);
w = set(w,'start',s);