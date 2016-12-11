function e_nan = wfa2nan(e_wfa, varargin)
%
%EVENT_WFA2NAN: Convert events from WFA form to NAN form.
%      WFA - WaveForm Array form, events separated in nx1 waveform array
%          - (or) into 1xl cell array, each cell containing a nx1 waveform 
%          - array of events from a separate station/channel.
%      NAN - NaN form, (1xl waveform) for l station/channels with events in 
%            one time series w/ non-events = NaN. 
%      SST - Start/Stop Times form, nx2 array of matlab start/stop times
%            (or) 1xl cell array, each cell containing nx2 start/stop
%            times from a separate station/channel.
%
%USAGE: e_nan = wfa2nan(e_wfa)
%        ...Output e_nan waveforms extend from the first to the last
%        ...events in e_wfa, separated by NaN values.
%       e_nan = wfa2nan(e_wfa,w)
%        ...Output e_nan waveforms extend from the beginning to the end
%        ...of w
%       
%INPUTS: e_wfa - Waveform event array (1xl cell of nx1 event waveforms)
%        w     - Reference waveform, e_nan timevector will match w
%
%OUTPUTS: e_nan - Event/NaN waveforms (1xl waveforms)

if nargin == 1
   w = waveform();
elseif nargin == 2
   w = varargin{1};
end

if iscell(e_wfa)
   if numel(e_wfa) == numel(w)
      for l = 1:numel(e_wfa)
         e_nan(l) = WFA2NAN(e_wfa{l},w(l));
      end
   else
      error(['wfa2nan:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''e_wfa'' must match']);
   end
else
   e_nan = WFA2NAN(e_sst,w);
end

function e_nan = WFA2NAN(e_wfa,w)

for n=1:length(e_wfa)
   if isempty(e_wfa(n))
      e_wfa(n)=[];
   end
end
e_nan = combine(e_wfa);  

if ~isempty(w)
   ts1 = get(w, 'start');
   ts2 = get(e_nan, 'start');
   te1 = get(e_nan, 'end');
   te2 = get(w, 'end');
   
   if ts1 < ts2
      pad_s = extract(w, 'time',ts1,ts2);
   else
      pad_s = [];
   end
   
   if te2 > te1
      pad_e = extract(w, 'time',te1,te2);
   else
      pad_e = [];
   end
   
   e_nan = [NaN*pad_s e_nan NaN*pad_e];
   e_nan = combine(e_nan);
end

%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Resulting Overlay %%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% plot(w)
% hold on
% plot(e_nan,'color',[1 0 0])
