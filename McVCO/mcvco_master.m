function mcvco_master
%% UPDATE McVCO METRIC PLOTS

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])
M = update_mcvco_struct(M,dr);

%%
subnets = fieldnames(M);
t = ceil(now);
for n = 1:numel(subnets)
    SN = subnets{n};
    
    t_range = [t-7 t];
    tag = 'Week';
    mcplot(M,SN,t_range,tag,dr)
    
    t_range = [t-30 t];
    tag = 'Month';
    mcplot(M,SN,t_range,tag,dr)
    
    t_range = [t-90 t];
    tag = '3Month';
    mcplot(M,SN,t_range,tag,dr)
    
    t_range = [t-365 t];
    tag = 'Year';
    mcplot(M,SN,t_range,tag,dr)
    
    t_range = [datenum([2012 8 1 0 0 0]) t];
    tag = 'All';
    mcplot(M,SN,t_range,tag,dr)
end

function mcplot(M,SN,t_range,tag,dr)
%% PLOT McVCO METRICS FOR NETWORKS & CHANNELS

plot_mcvco_channel(M,'Voltages',SN,t_range,tag,dr)
plot_mcvco_network(M,'Voltages',SN,t_range,tag,dr)
dr2 = [dr,'\HTML\Network_Voltages_Plots\'];
export_fig([dr2,SN,'-',tag],'-png')
pause(.1)
close all

% plot_mcvco_channel(M,'Waveforms',SN,t_range,tag,dr)
% plot_mcvco_network(M,'Waveforms',SN,t_range,tag,dr)
% dr2 = [dr,'\HTML\Network_Waveforms_Plots\'];
% export_fig([dr2,SN,'-',tag],'-png')
% pause(.1)
% close all

