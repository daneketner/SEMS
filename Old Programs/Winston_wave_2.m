clear all; clc

host='avovalve01.wr.usgs.gov'; % host='pubavo1.wr.usgs.gov'; 
port=16022;
ds = datasource('winston',host,port);

station='REF';             % Station
channel='EHZ';             % Channel
network='AV';              % Network    


t_start=[2009 03 20 00 00 00]; % Start time (YYYY MM DD HH MM SS)
t_end=  [2009 03 20 06 00 00]; % End time   (YYYY MM DD HH MM SS)
    
scnl = scnlobject(station,channel,network);
w = waveform(ds,scnl,datestr(t_start,0),datestr(t_end,0));
%w = resample(w,'mean',4);
v = get(w,'data');
Fs = get(w,'freq');                % Sampling Frequency (Hz)
dt = 1/Fs;                         % Sample Time
T = get(w,'timevector');           % Vector of Time Instances (Matlab Format)
xT = dt:dt:length(T)*dt;           % Vector of Time Instances (Seconds from t_start)

w=zero_gaps(w);  % Find and replace gaps in data
events = sta_lta(w);        % STA/LTA Event Locator

figure
fi_hht = freq_index_hht(events);
x=1:length(fi_hht);
scatter(x,fi_hht)

helicorder(w,events,10)

hht_vs_fft_wf(events(5),[0,.5]);
