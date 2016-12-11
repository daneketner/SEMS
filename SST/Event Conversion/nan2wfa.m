function e_wfa = nan2wfa(e_nan)
%
%EVENT_NAN2WFA: Convert events from NAN form to WFA form.
%      WFA - WaveForm Array form, events separated in nx1 waveform array
%          - (or) into 1xl cell array, each cell containing a nx1 waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xl waveform) for l station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%
%USAGE: events = nan2wfa(e_nan)
%
%INPUTS: e_nan - Waveform object of events (1x1) in NAN form
%
%OUTPUTS: e_wfa - Waveform object array of events (WFA form)

for l = 1:numel(e_nan)
   dat = get(e_nan(l),'data');
   l_d = length(dat);
   e_wfa{l} = [];

   if isnan(dat(1))
      inevent = 0;
   elseif ~isnan(dat(1))
      indx1 = 1;
      inevent = 1;
   end

   for n = 2:l_d-1
      if (inevent == 0) && ~(isnan(dat(n)))
         indx1 = n;
         inevent = 1;
      elseif (inevent == 1) && (isnan(dat(n)))
         indx2 = n-1;
         e_wfa{l}=[e_wfa{l}; extract(e_nan(l),'INDEX',indx1,indx2)];
         inevent = 0;
      end
   end

   if ~isnan(dat(l_d)) && (inevent == 1)
      indx2 = l_d;
      e_wfa{l}=[e_wfa{l}; extract(e_nan(1),'INDEX',indx1,indx2)];
   end
end

if numel(e_wfa) == 1
   e_wfa = e_wfa{1};
end