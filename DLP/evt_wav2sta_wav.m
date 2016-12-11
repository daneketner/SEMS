function evt_wav2sta_wav

Dir = make_dir_mstr;
EWD = dir(Dir.Evt_Wav);
EWD(1:2) = []; % Get rid of '.' and '..'
W_big = [];
for n = 1:numel(EWD)
    load([Dir.Evt_Wav,'\',EWD(n).name])
    W_big = [W_big W];
    if rem(n,100) == 0
        archive(W_big, Dir)
        W_big = [];
    end
end

function archive(W_big, Dir)
disp(['Archiving ',num2str(numel(W_big)),' events'])
sta_big = get(W_big, 'station');
sta_list = sort(unique(sta_big));
for m = 1:numel(sta_list)
    W_sta = W_big(strcmp(sta_big, sta_list{m}));
    wdir = [Dir.Sta_Wav,'\',sta_list{m},'.mat'];
    if ~exist(wdir)
        [t, ind] = sort(get(W_sta,'start'));
        W = W_sta(ind);
        save(wdir,'W')
    else
        load(wdir)
        W = [W W_sta];
        [t, ind] = sort(get(W,'start'));
        W = W(ind);
        save(wdir,'W')
    end
        
end