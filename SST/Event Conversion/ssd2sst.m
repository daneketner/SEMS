function e_sst = ssd2sst(e_ssd,w)
%
%E_SSD2SST: Convert events from SSD form to SST form.
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
%USAGE: e_sst = ssd2sst(e_ssd,w)
%
%INPUTS: w     - Waveform object that contains events
%        e_ssd - Start/Stop Data Points (references w) 
%
%OUTPUTS: e_sst - Start/Stop Times (references w time vector)

tv = get(w,'timevector');
if iscell(e_ssd)
   if numel(e_ssd) == numel(w)
      for l=1:numel(e_ssd)
         for n=1:size(e_ssd{l},1)
            e_sst{l}(n,:) = tv(e_ssd{l}(n,:));
         end
      end
   else
      error(['ssd2sst:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''e_ssd'' must match']);
   end
else
   for n=1:size(e_ssd,1)
      e_sst(n,:) = tv(e_ssd(n,:));
   end
end


   

