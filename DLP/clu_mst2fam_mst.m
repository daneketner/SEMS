function FM = clu_mst2fam_mst(Clu_Mst)

FM(1).sta{1} = Clu_Mst(1).sta;
FM(1).numel{1} = Clu_Mst(1).size;
FM(1).evid{1} = Clu_Mst(1).evid;
FM(1).trig{1} = Clu_Mst(1).trig;
FM(1).dist{1} = Clu_Mst(1).ev_dist;
for n = 2:numel(Clu_Mst)
    connect = 0;
    for k = 1:numel(FM)
        if numel(intersect(Clu_Mst(n).evid, FM(k).evid{1})) > Clu_Mst(n).size/2
            connect = 1;
            FM(k).sta{end+1} = Clu_Mst(n).sta;
            FM(k).numel{end+1} = Clu_Mst(n).size;
            FM(k).evid{end+1} = Clu_Mst(n).evid;
            FM(k).trig{end+1} = Clu_Mst(n).trig;
            FM(k).dist{end+1} = Clu_Mst(n).ev_dist;
        end
    end
    if ~connect
        N = numel(FM);
        FM(N+1).sta{1} = Clu_Mst(n).sta;
        FM(N+1).numel{1} = Clu_Mst(n).size;
        FM(N+1).evid{1} = Clu_Mst(n).evid;
        FM(N+1).trig{1} = Clu_Mst(n).trig;
        FM(N+1).dist{1} = Clu_Mst(n).ev_dist;
    end
end
