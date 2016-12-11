function SM = sta_cor2sta_mst(EM)

Dir = make_dir_mstr;
SD = dir(Dir.Sta_Cor);
SD(1:2) = []; % Get rid of '.' and '..'

for n = 1:numel(SD)
    iM = [];
    W = waveform;
    stat = [];
    id = SD(n).name;
    clc, disp(id), pause(.01)
    load(fullfile(Dir.Sta_Wav,id));
    load(fullfile(Dir.Sta_Clu,id));
    [ID,iW,iM] = intersect(get(W,'evid'),EM.evid);
    SM(n).nevt = numel(iM);
    SM(n).name = get(W(1),'station'); 
    SM(n).lat = get(W(1),'sta_lat'); 
    SM(n).lon = get(W(1),'sta_lon'); 
    SM(n).elev = get(W(1),'sta_elev'); 
    SM(n).ev_datenum = EM.datenum(iM); 
    SM(n).ev_depth = EM.depth(iM); 
    SM(n).ev_id = EM.evid(iM); 
    SM(n).ev_lon = EM.lon(iM);
    SM(n).ev_lat = EM.lat(iM);
    SM(n).ev_dist = lldistkm(SM(n).lat,SM(n).lon,SM(n).ev_lat,SM(n).ev_lon);
    SM(n).ev_mag = EM.mag(iM);
    SM(n).ev_numw = EM.numw(iM);
    SM(n).ev_pfmed = EM.pfmed(iM);
    SM(n).ev_pfstk = EM.pfstk(iM);
    SM(n).ev_type = EM.type(iM);
    stat = substruct(stat,stat.numel>1,1);
    SM(n).clu_numel = stat.numel';
    SM(n).clu_trig = stat.trig';
    SM(n).clu_evid = stat.evid';
    SM(n).clu_index = stat.index';
end
save([Dir.Sta_Mst,'\','Station_Master'],'SM')