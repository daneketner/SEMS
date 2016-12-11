function e_wfa = sst2wfa(e_sst,w)
%
%EVENT_SST2WFA: Convert events from SST form to WFA form.
%      WFA - WaveForm Array form, events separated in nx1 waveform array
%          - (or) into 1xl cell array, each cell containing a nx1 waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xl waveform) for l station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%
%USAGE: e_wfa = sst2wfa(e_sst)
%
%INPUTS: w     - Waveform object that contains events
%        e_sst - Events (WFA form)   
%
%OUTPUTS: e_wfa - Events (WFA form)

if iscell(e_sst)
   if numel(e_sst) == numel(w)
      for l=1:numel(e_sst)
         for n=1:size(e_sst{l},1)
            e_wfa{l}(n) = extract(w,'time',e_sst{l}(n,1),e_sst{l}(n,2));
         end
      end
   else
      error(['sst2nan:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''e_sst'' must match']);
   end
else
   for n=1:size(e_sst,1)
      e_wfa(n) = extract(w,'time',e_sst(n,1),e_sst(n,2));
   end
end


   

