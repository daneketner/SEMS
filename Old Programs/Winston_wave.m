
clear all; clc

c1=[2009 03 21 23 59 50]; % Start time (YYYY MM DD HH MM SS)
c2=[2009 03 22 00 10 00]; % End time   (YYYY MM DD HH MM SS)

t1=cal2sec(c1);           % Start time (J2K)
t2=cal2sec(c2);           % End time   (J2K)

host='avovalve01.wr.usgs.gov';
%host='pubavo1.wr.usgs.gov'; 
port=16022;
W=javaObject('gov.usgs.winston.server.WWSClient',host,port);
W.connect;
r1='REF';r2='EHZ';r3='AV';            % Station, Channel, Network
tr=W.getWave(r1,r2,r3,'--',t1,t2,0);
tr.setStartTime(t1);                  % Remove start time 'padding'
Fs=tr.getSamplingRate;                % Sampling Frequency (Hz)

dt = 1/Fs;                            % Sample Time
T=t1:dt:t2;                           % Vector of Time Instances (J2K)
v=tr.buffer(1:length(T));             % The goods (data)
v=double(v);

%[v,Fs,T] = down_samp(v,Fs,T,2);      % Down sample (if desired)
xT = T-t1;                            % Vector of Time Instances (From 0 s)
%v=replace_gaps(v,Fs);  % Find and replace gaps in data

trig_array = sta_lta(v,Fs);           % STA/LTA Event Locator
n=1;                                  % Event number
p = 1*Fs;                             % Pad event window (seconds)
event = v(trig_array(n,1)-p:trig_array(n,2)+p);
event_T = T(trig_array(n,1)-p:trig_array(n,2)+p);
event_xT = xT(trig_array(n,1)-p:trig_array(n,2)+p);
%hht_vs_fft(event,Fs,event_T,event_xT,[0,.5],r1,r2,r3,c1,c2);

%%%%% Plot Seismic Wave %%%%

figure
h=plot(event_xT,event);
xlabel(['Time in seconds, start ',datestr(c1,'HH:MM:SS'),' (UTC)'])
ylabel('Counts')
title(['[',r1,' ',r2,' ',r3,'] ',datestr(c1,'dd-mmm-yyyy')])
xlim([min(event_xT) max(event_xT)])	

W.close



