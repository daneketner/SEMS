function sta_wav2sta_cor(EM,cc)

%% CROSS-CORRELATE ALL STATION WAVEFORMS

Dir = make_dir_mstr;
% 'SW' - Structure containing names of Station Waveforms
SW = dir(Dir.Sta_Wav);
SW(1:2) = []; % Get rid of '.' and '..'

SC = [];
for n = 1:numel(SW)
    clc
    name = SW(n).name;
    disp(name)
    warning off
    try
        load([Dir.Sta_Wav,'\',name])
        W = W(isvertical(W));
        P = get_picks(W,'p');
        W = W(find(P));
        P = P(find(P));
        evid = get(W,'evid');
        [V, ia, ib] = intersect(evid, EM.evid);
        W = W(ia);
        SC = substruct(EM,ib,1);
        clear w
        P = get(W,'P_DATENUM');
        for m = 1:numel(W)
            w(m) = extract(W(m),'TIME',P(m)-5/24/60/60,P(m)+15.24/24/60/60);
        end
        C = correlation(w);
        C = taper(C);
        C = butter(C,[1 10]);
        C = set(C,'TRIG',P);
        SC.C = xcorr(C,[0 10.24]);
        SC.C = linkage(SC.C);
        SC.C = cluster(SC.C,cc);
        stat = getclusterstat(c);
        save([Dir.Sta_Clu,'\',name],'stat')
        save([Dir.Sta_Cor,'\',name],'SC')
    catch
    end
    warning on
end

