station = 'RDWB';
channel = 'BHZ';
network = 'AV';
host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
t_start = [2009 03 23 02 02 90];
t_end   = [2009 03 23 02 07 90];
scnl = scnlobject(station,channel,network);
t_start_ser = datenum(t_start); 
t_end_ser = datenum(t_end);
t1 = datestr(t_start);
t2 = datestr(t_end);
w = waveform(ds,scnl,t1,t2);
v_0 = demean(w);
f_1 = filterobject('h',.33,4);
v_1 = filtfilt(f_1,v_0);
f_2 = filterobject('h',.83,4);
v_2 = filtfilt(f_2,v_0);
f_3 = filterobject('l',.125,4);
v_3 = filtfilt(f_3,v_0);
v_4 = integrate(v_3);
dur_s = get(w,'duration')*24*60*60;
figure

subplot(5,1,1)
plot(v_0)
xlim([0 dur_s])

subplot(5,1,2)
plot(v_1)
xlim([0 dur_s])

subplot(5,1,3)
plot(v_2)
xlim([0 dur_s])

subplot(5,1,4)
plot(v_3)
xlim([0 dur_s])

subplot(5,1,5)
plot(v_4)
xlim([0 dur_s])

plot_hht(v_0,[.000004 .4])
plot_hht_log(v_0,[.000001 .4])