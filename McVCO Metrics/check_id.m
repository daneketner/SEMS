function M = check_id(M)

if (isa(M,'waveform') && ~isempty(M))
    keep = [];
    id = get(M(1),'id');
    real_id = get(M(1),'real_id');
    for k = 1:numel(real_id)
        keep = [keep; find(id == real_id(k))];
    end
    keep = sort(keep);
    M = M(keep);
    if ~isempty(M)
        bvl = get(M(1),'bvl');   bvl = bvl(keep);   M = set(M,'bvl',bvl);
        id = get(M(1),'id');     id = id(keep);     M = set(M,'id',id);
        gain = get(M(1),'gain'); gain = gain(keep); M = set(M,'gain',gain);
    end
elseif isstruct(M)
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
                if ~isempty(X.start)
                    keep = [];
                    for k = 1:numel(X.real_id)
                        keep = [keep; find(X.id == X.real_id(k))];
                    end
                    keep = sort(keep);
                    X.bvl = X.bvl(keep);
                    X.id = X.id(keep);
                    X.gain = X.gain(keep);
                    X.start = X.start(keep);
                    M.(SU).(ST).(CH) = X;
                end
            end
        end
    end
end
