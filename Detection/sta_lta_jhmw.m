function e_sst = sta_lta_jhmw(w,type)
%
%STA_LTA_JHMW: Short-Time-Average/Long-Time-Average event detector.
%         As defined by 'Toward the Systematic Counting of Volcanic
%         Seismic Events' - Jessica Hawthorne & Michael West
%
%USAGE: e_sst = sta_lta_jhmw(w,edp,type)
%
%DIAGRAM:
%                       /\      /\/\        /\
%              /\  /\/\/  \/\  /    \/\    /  \/\
%                \/          \/        \/\/      \                   
%                                           |-STA-| -->
%         --> |-----------------LTA---------------| -->
%
%INPUTS: w - a waveform object containing events (maybe)
%        edp - Event Detection Parameters (1x6 double)
%        type - return type:
%                  'sst' - return event start/stop times (nx2)
%                  'wfa' - return event waveform array (nx1)
%                  'ssd' - return event start/stop datapoints (nx2)
%
%OUTPUTS: events - waveform object array of detected events

w = bp_filt(w);             % Bandpass filter
w_h = hilbert(w);            % Hilbert evelope data
Fs = get(w,'freq');         % Sampling frequency
tv = get(w, 'timevector');  % Time vector of waveform

l_sta = 0.8*Fs;     % STA window size (s)
l_lta = 7*Fs;       % LTA window size (s)
th_on = 2.0;     % Trigger on when sta_to_lta exceeds this theshold
th_off = 1.5;    % Trigger off when sta_to_lta drops below threshold  
min_dur = 1*Fs;  % Any triggers longer than min_dur become events

sta = win_op(w_h,l_sta,'meanabs','right');
lta = win_op(w_h,l_lta,'meanabs','right');
l1 = get(w,'data_length');
sta = extract(sta,'index',l_lta,l1);
lta = extract(lta,'index',l_lta,l1);
w2 = extract(w,'index',l_lta,l1);
l2 = get(w2,'data_length');

hh = hann(ceil(.45*Fs));

sta_hh = conv(hh,get(sta,'data'));
lta_hh = conv(hh,get(lta,'data'));
dif = length(sta_hh)-get(sta,'data_length');
left = ceil(dif/2);
sta_hh = sta_hh(left:left+l2-1);
lta_hh = lta_hh(left:left+l2-1);

sta = set(sta,'data',sta_hh);
lta = set(lta,'data',lta_hh);

ratio = sta./lta;

[p_times p_val] = findpeaks(ratio,2.5,l_sta);
[uptrig downtrig] = findlocval(ratio,p_times,'left','<',2.5,'right','<',1.5);
start_t = findloc(sta,uptrig,'left');
e_sst = [uptrig downtrig];

% Not completed As of Jan 20,2011

figure, 
subplot(3,1,1)
plot(get(w2,'timevector'),get(w2,'data'));
a1 = gca;
dynamicdateticks(a1)
subplot(3,1,2)
plot(get(sta,'timevector'),get(sta,'data'),'color',[1 0 0]);
hold on
plot(get(lta,'timevector'),get(lta,'data'));
a2 = gca;
dynamicdateticks(a2)
subplot(3,1,3)
plot(get(ratio,'timevector'),get(ratio,'data'));
a3 = gca;
dynamicdateticks(a3)
linkaxes([a1 a2 a3],'x')

