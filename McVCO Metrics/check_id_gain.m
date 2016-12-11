function M = check_id_gain(M)

if (isa(M,'waveform') && ~isempty(M))
    cut_id = find(get(M(1),'id') ~= get(M(1),'real_id'));
    cut_gain = find(get(M(1),'gain') ~= get(M(1),'real_gain'));
    cut = unique([cut_id; cut_gain]);
    M(cut) = [];
    if ~isempty(M)
        bvl = get(M(1),'bvl');     bvl(cut) = [];   M = set(M,'bvl',bvl);
        id = get(M(1),'id');       id(cut) = [];    M = set(M,'id',id);
        gain = get(M(1),'gain');   gain(cut) = [];  M = set(M,'gain',gain);
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
                    cut_id = find(X.id ~= X.real_id);
                    cut_gain = find(X.gain ~= X.real_gain);
                    cut = unique([cut_id; cut_gain]);
                    X.bvl(cut) = [];
                    X.id(cut) = [];
                    X.gain(cut) = [];
                    X.start(cut) = [];
                    M.(SU).(ST).(CH) = X;
                end
            end
        end
    end
end
