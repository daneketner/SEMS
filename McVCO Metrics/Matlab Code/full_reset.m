%% FULL RESET/DETECTION ON EVERY CHANNEL, ARCHIVE WAVEFORMS

subnets = fieldnames(M);
fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])


for n = [1,9,12,13]%1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.(SU).(ST).(CH);
            [M, W] = reset_mcvco_chan(M,SU,ST,CH,X.real_id,X.real_gain);
            save([dr,'\Master.mat'],'M')
            save([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'],'W')
        end
    end
end