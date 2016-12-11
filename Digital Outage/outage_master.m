function outage_master
%% UPDATE McVCO METRIC PLOTS

fid = fopen('outage_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])
M = update_outage_struct(M);
save([dr,'\Master.mat'],'M')

%%
t = ceil(now*24)/24;

t_range = [t-7 t];
tag = 'Week';
plot_outage(M,t_range,tag,dr)

t_range = [t-30 t];
tag = 'Month';
plot_outage(M,t_range,tag,dr)

t_range = [t-90 t];
tag = '3Month';
plot_outage(M,t_range,tag,dr)

t_range = [t-365 t];
tag = 'Year';
plot_outage(M,t_range,tag,dr)

t_range = [datenum([2012 8 1 0 0 0]) t];
tag = 'All';
plot_outage(M,t_range,tag,dr)
