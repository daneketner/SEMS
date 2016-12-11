function fam_mst2fam_wav(FM)

Dir = make_dir_mstr;
dt = 1/24/60/60;

for n = 1:numel(FM)
    FW = {};
    for m = 1:numel(FM(n).sta)
        sta = FM(n).sta{m};
        evid = FM(n).evid{m};
        trig = FM(n).trig{m};
        load([Dir.Sta_Wav,'\',sta,'.mat'])
        [val iF iW] = intersect(evid, get(W,'evid'));
        C = correlation(W(iW))
        C = taper(C);
        C = butter(C,[1 10])
        C = set(C,'TRIG',trig);
        C = xcorr(C,[0 10.24]);
        C = adjusttrig(C);
        trig = get(C,'trig');
        for k = 1:numel(iF)
            ind = iW(k);
            FW{m}(k) = extract(W(ind),'TIME',trig(k)-5*dt,trig(k)+20*dt);
        end
    end
    save([Dir.Fam_Wav,'\Family',sprintf('%03d',n)],'FW')
end


