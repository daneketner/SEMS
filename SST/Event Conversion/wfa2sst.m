function e_sst = wfa2sst(e_wfa)
%
%EVENT_WFA2SST: Convert events from WAR form to SST form.
%      WFA - WaveForm Array form, events separated in nx1 waveform array
%          - (or) into 1xl cell array, each cell containing a nx1 waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xl waveform) for l station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%
%USAGE: e_sst = wfa2sst(e_wfa)
%
%INPUTS: e_wfa - Events (WFA form)
%
%OUTPUTS: e_sst - Events (SST form)

if iscell(e_wfa)
   for l = 1:numel(e_wfa)
      if ~isa(e_wfa{l},'waveform')
         error('Input must be a waveform object array')
      end
      for n = 1:numel(e_wfa{l})
         e_sst{l}(n,1) = get(e_wfa{l}(n),'start');
         e_sst{l}(n,2) = get(e_wfa{l}(n),'end');
      end
   end
else
   for n = 1:numel(e_wfa)
      e_sst(n,1) = get(e_wfa(n),'start');
      e_sst(n,2) = get(e_wfa(n),'end');
   end
end
