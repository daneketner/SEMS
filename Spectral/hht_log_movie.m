% Generates a movie of sliding hht windows
% Will possibly become a function someday
% Can be a time consuming program (size of m)

station = 'REF';
channel = 'EHZ';
network = 'AV';
scnl = scnlobject(station,channel,network);
mkdir(['hht_movie\',station,'\',channel])

host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

for m = 1:20
t_start = [2009 03 23 02 n m*2];
t_end   = [2009 03 23 02 n+1 m*2];

t_start_ser = datenum(t_start); 
t_end_ser = datenum(t_end);
t1 = datestr(t_start);
t2 = datestr(t_end);
w = waveform(ds,scnl,t1,t2);
v_0 = demean(w);
figure('Name','Log HHT','NumberTitle','off',...
        'Position',[200,200,560,420]);
plot_hht_log(v_0,[.000001 .4])
M(m) = getframe(gcf);
end

mpath = ['hht_movie\',station,'\',channel,'\M',num2str(n)];
save(mpath,'M')
close all
movie(M)

