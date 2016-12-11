function e_ssd = sst2ssd(e_sst,w)
%
%E_SST2SSD: Convert events from SST form to SSD form.
%      WFA - WaveForm Array form, events separated in nx1 waveform array
%          - (or) into 1xl cell array, each cell containing a nx1 waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xl waveform) for l station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%      SSD - Start/Stop Data form, nx2 array of start/stop data points
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            data points from a separate station/channel.
%
%USAGE: e_ssd = sst2ssd(e_sst,w)
%
%INPUTS: w     - Waveform object that contains events
%        e_sst - Start/Stop Times (references w time vector)
%
%OUTPUTS: e_ssd - Start/Stop Data Points (references w) 

Fs = get(w,'freq');
tv = get(w,'timevector');
wig = 1/24/60/60/Fs/2;
if iscell(e_sst)
   if numel(e_sst) == numel(w)
      for l=1:numel(e_sst)
         for n=1:size(e_sst{l},1)
            e_ssd{l}(n,1) = find((tv >= e_sst{l}(n,1)-wig)&&(tv <= e_sst{l}(n,1)+wig));
            e_ssd{l}(n,2) = find((tv >= e_sst{l}(n,2)-wig)&&(tv <= e_sst{l}(n,2)+wig));
         end
      end
   else
      error(['ssd2sst:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''e_ssd'' must match']);
   end
else
   for n=1:size(e_sst,1)
      e_ssd(n,1) = find((tv >= e_sst(n,1)-wig)&(tv <= e_sst(n,1)+wig));
      e_ssd(n,2) = find((tv >= e_sst(n,2)-wig)&(tv <= e_sst(n,2)+wig));
   end
end

%