function Clu_Mst = sta_mst2clu_mst(SM)

Clu_Mst = [];
k = 1;
for n = 1:numel(SM)
    for m = 1:numel(SM(n).clu_evid)
        index = SM(n).clu_index{m};
        Clu_Mst(k).sta = SM(n).name;
        Clu_Mst(k).size = SM(n).clu_numel(m);
        Clu_Mst(k).trig = SM(n).clu_trig{m};
        Clu_Mst(k).evid = SM(n).clu_evid{m};
        Clu_Mst(k).ev_dist = SM(n).ev_dist(index);
        Clu_Mst(k).ev_depth = SM(n).ev_depth(index);
        Clu_Mst(k).ev_lat = SM(n).ev_lat(index);
        Clu_Mst(k).ev_lon = SM(n).ev_lon(index);
        Clu_Mst(k).ev_mag = SM(n).ev_mag(index);
        Clu_Mst(k).ev_pfmed = SM(n).ev_pfmed(index);
        Clu_Mst(k).ev_pfstk = SM(n).ev_pfstk(index);
        Clu_Mst(k).ev_type = SM(n).ev_type(index);
        k = k+1;
    end
end
[~,index] = sortrows([Clu_Mst.size].'); 
Clu_Mst = Clu_Mst(index(end:-1:1)); 



