function e_nan = sst2nan(e_sst,w)
%
%EVENT_SST2NAN: Convert events from SST form to NAN form.
%      WFA - WaveForm Array form, events separated in 1xn waveform array
%          - (or) into 1xm cell array, each cell containing a 1xn waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xm waveform) for m station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xm cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%
%USAGE: e_nan = sst2nan(w, e_sst)
%
%INPUTS: w       - Waveform object that contains events
%        times   - Events times (nx2 double)
%
%OUTPUTS: e_nan - Event in NaN form

if iscell(e_sst)
   if numel(e_sst) == numel(w)
      for m = 1:numel(e_sst)
         e_nan(m) = SST2NAN(e_sst{m},w(m));
      end
   else
      error(['sst2nan:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''e_sst'' must match']);
   end
else
   e_nan = SST2NAN(e_sst,w);
end

function e_nan = SST2NAN(e_sst,w)
for n=1:size(e_sst,1)
   e_wfa(n) = extract(w,'time',e_sst(n,1),e_sst(n,2));
end
if isempty(e_sst)
   e_nan = w*NaN;
else   
e_nan = combine(e_wfa);
ts1 = get(w, 'start');
ts2 = get(e_nan, 'start');
te1 = get(e_nan, 'end');
te2 = get(w, 'end');
pad_s = extract(w, 'time',ts1,ts2);
pad_e = extract(w, 'time',te1,te2);
e_nan = [NaN*pad_s e_nan NaN*pad_e];
e_nan = combine(e_nan);
end