function M = rollback_mcvco_struct(M,time)

subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.(SU).(ST).(CH);
            cut = find(X.start > datenum(time));
            X.bvl(cut) = [];
            X.id(cut) = [];
            X.gain(cut) = [];
            X.start(cut) = [];
            X.lastcheck = datenum(time);
            M.(SU).(ST).(CH) = X;
        end
    end
end