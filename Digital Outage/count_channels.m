function [N_working, N_total, tv] = count_channels(M,varagin)

% Add functionality with varargin for selecting subsets of all channels or 
% subsets of time, (i.e. 'Z', '2012', 'Spurr', 'REF:EHZ')

subnets = fieldnames(M.Outage);
tv = M.TimeVector;
N_working = tv*0;
N_total = tv*0;
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.Outage.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.Outage.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            N_working = N_working + M.Outage.(SU).(ST).(CH);
            n = find(tv >= M.Start.(SU).(ST));
            N_total(n) = N_total(n) + 1;
        end
    end
end