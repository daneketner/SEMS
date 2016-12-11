function CM = sta_cor2cor_mst(EM)

Dir = make_dir_mstr;
SD = dir(Dir.Sta_Cor);
SD(1:2) = []; % Get rid of '.' and '..'

nid = numel(EM.evid);
CM.nsta = single(zeros(nid));
CM.cccum = single(zeros(nid));
CM.ccmax = single(zeros(nid));
CM.cc065cnt = single(zeros(nid));
CM.cc070cnt = single(zeros(nid));
CM.cc075cnt = single(zeros(nid));

for n = 1:numel(SD)
    id = SD(n).name;
    clc, disp(id), pause(.01)
    load(fullfile(Dir.Sta_Cor,id));
    [ID,iW,iM] = intersect(SC.evid,EM.evid);
    nM = numel(iM);
    nw = numel(W);
    lat = EM.lat(iM); 
    lon = EM.lon(iM);
    cc = get(C,'corr');
    for m = 1:nw-1
        M1 = iM(m);
        M2 = iM(m+1:nM);
        CC = cc(m,m+1:end);
        CM.nsta(M1,M2) = CM.nsta(M1,M2) + 1;
        CM.cccum(M1,M2) = CM.cccum(M1,M2) + CC;
         lt = CM.ccmax(M1,M2) < CC;
        CM.ccmax(M1,M2(lt)) = CC(lt);
        CM.cc065cnt(M1,M2) = CM.cc065cnt(M1,M2) + round(CC-.15);
        CM.cc070cnt(M1,M2) = CM.cc070cnt(M1,M2) + round(CC-.2);
        CM.cc075cnt(M1,M2) = CM.cc075cnt(M1,M2) + round(CC-.25);
    end
end
CM.nsta = CM.nsta + CM.nsta';
CM.cccum = CM.cccum + CM.cccum';
CM.ccmax =  CM.ccmax + CM.ccmax';
CM.cc065cnt = CM.cc065cnt + CM.cc065cnt';
CM.cc070cnt = CM.cc070cnt + CM.cc070cnt';
CM.cc075cnt = CM.cc075cnt + CM.cc075cnt';
CM.ccmean = CM.cccum./CM.nsta;
CM.ccmean(isnan(CM.ccmean)) = 0;

