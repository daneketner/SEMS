function events = sta_lta_skip(wave,edp,type)
%
%STA_LTA_SKIP: Short-Time-Average/Long-Time-Average event detector.
%
%USAGE: events = sta_lta(wave,edp,type)
%
%DIAGRAM:
%                       /\      /\/\        /\
%              /\  /\/\/  \/\  /    \/\    /  \/\
%                \/          \/        \/\/      \                   
%                                           |-STA-| -->
%         --> |-----------------LTA---------------| -->
%
%INPUTS: wave - a waveform object containing events (maybe)
%        edp - Event Detection Parameters (1x6 double)
%        type - return type:
%                  'sst' - return event start/stop times (nx2)
%                  'wfa' - return event waveform array (nx1)
%                  'ssd' - return event start/stop datapoints (nx2)
%
%OUTPUTS: events - waveform object array of detected events

for l = 1:numel(wave) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wave(l) = bp_filt(wave(l));    % Band Pass filter (1Hz to 10Hz)
%Data to be skipped by algorithm - nx2 array of start/stop data points
%skp_ssd = skipper(wave,'jump','gap','cal','ssd');
skp_ssd = [];  
skp_n = sign(length(skp_ssd)); % 1 if skips present, else 0

v = get(wave(l),'data');          % Waveform data
Fs = get(wave(l),'freq');         % Sampling frequency
l_v = get(wave(l),'data_length'); % Length of time series
tv = get(wave(l), 'timevector');  % Time vector of waveform
abs_v = abs(v);                   % Absolute value of time series
mabs_v = mean(abs_v);

l_sta = edp(l,1)*Fs;   % STA window size
l_lta = edp(l,2)*Fs;   % LTA window size
th_on = edp(l,3);      % Trigger on when sta_to_lta exceeds this theshold
th_off = edp(l,4);     % Trigger off when sta_to_lta drops below threshold 
                       % for off_dur data points
skip_int = edp(l,5)*Fs;% Skip ahead after end of event (seconds)
min_dur = edp(l,6)*Fs; % Any triggers longer than min_dur become events
sta_to_lta = 1;        % Initialize STA/LTA ratio

% Initialize flags and other variables

trig_flag = 0;
lta_calc_flag = 0;
ntrig = 0;
trig_array = zeros(1,2);

% Loops over data, updating sta & lta for each sample
i = l_lta+1; % Current data point reference (right of STA/LTA window)
while i <= l_v
   if (skp_n>0)&&(skp_n<length(skp_ssd)/2)
      if i > skp_ssd(2*skp_n-1)      % LTA window contain skip?
         i = skp_ssd(2*skp_n)+l_lta; % Jump LTA window to end of skip
         skp_n = skp_n+1;            % Move Skip Counter
      end
   end
   if sta_to_lta < th_on
      if trig_flag == 1
         trig_flag = 0;
      end
   end
   if (lta_calc_flag == 0) % Do full LTA & STA calcs
      lta_sum = 0;
      sta_sum = 0;
      for j = i-l_lta:i-1              % Loop to compute LTA & STA
         lta_sum = lta_sum + abs_v(j); % Sum LTA window
         if (i - j) <= l_sta           % Sum STA window (right side of LTA)
            sta_sum = sta_sum + abs_v(j);
         end
      end
      lta_calc_flag = 1;
   else	% Subtract previous first value & replace with current last value 
      lta_sum = lta_sum - abs_v(i-l_lta-1) + abs_v(i-1);
      sta_sum = sta_sum - abs_v(i-l_sta-1) + abs_v(i-1);
   end

   lta = lta_sum/l_lta;
   sta = sta_sum/l_sta;
   sta_to_lta = sta/lta;

   if sta_to_lta > th_on && trig_flag == 0
      if lta < mabs_v/4      % Likely in a gap (skip ahead)
         i = i + l_lta;      % Jump one LTA window length
         lta_calc_flag = 0;  % Reset LTA calc flag to force new computation
      else
         % First, compute duration of event by fixing lta and tracking sta
         % until sta/lta falls below sta_lta_tresh
         j = i;
         sta_sum_tmp = sta_sum;
         amp_sum = 0;
         off_cnt = 0; % does STA/LTA rise back above thesh_off quickly?
         while (sta_to_lta > th_off)||(off_cnt < 2*l_sta)
            j = j+1;
            if j < l_v
               sta_sum_tmp = sta_sum_tmp - abs_v(j-l_sta-1) + abs_v(j-1);
               sta = sta_sum_tmp/l_sta;
               sta_to_lta = sta/lta;
               amp_sum = amp_sum + abs_v(j-1);
            else
               sta_to_lta = 0;
            end
            if sta_to_lta < th_off
               off_cnt = off_cnt+1;
            else
               off_cnt = 0;
            end
         end
         j = j-off_cnt;
         duration = (j-i);
         if duration > min_dur % If duration < min_dur then skip it
            trig_t = i-l_sta;  % Beginning of STA window during trigger on
            end_t  = j;        % End of STA window during trigger off
            ntrig = ntrig + 1; % Event counter
            trig_array(ntrig,:) = [trig_t, end_t];
         end
         i = i + l_sta + duration; % Skip ahead
         lta_calc_flag = 0;  % Reset LTA calc flag to force new computation
      end
   end
   i = i + 1;
end

% Return events as an array of waveform objects
if (trig_array(1,1)==0)&&(trig_array(1,2)==0)
   disp('No events detected')
   return
end

switch lower(type)
   case {'ssd'}
      events{l} = trig_array;
   case {'sst'}
      events{l} = tv(trig_array);
   case {'wfa'}
      for n=1:size(trig_array,1)
         %fix = [2 5]; Fix event length to 2 seconds before trig on, 5 seconds
         %after trig on (All event are 7 seconds long), Change 'fix' as needed
         %events=[events;extract(wave,'INDEX',trig_array(n,1)-Fs*fix(1),...
         %                                    trig_array(n,1)+Fs)*fix(2)];
         events{l}=[events{l}; extract(wave,'INDEX',trig_array(n,1),trig_array(n,2))];
      end
   otherwise
      events = trig_array;
end
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if numel(events) == 1
   events = events{1};
end



      
   