
%% Declare Source
f = fullfile('C:','Work','Little_Sitkin','Manual_Detection','LSSA');
cd(f);
scnl = scnlobject('LSSA','SHZ','AV');
host = 'pubavo1.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

%% Declare Time Range
t_start = datenum([2012 8 31 17 0 0]);
t_end = datenum([2012 9 1 0 0 0]);

%% Initialize

%load sst
%sst = [];

for t = t_start:1/24:t_end
    w = get_w(ds,scnl,t,t+1/24,'bp',[1 10]);
    temp = event_pick(w); temp = temp{:};
    sst = [sst;temp];
    save('sst.mat','sst')
end

%%

E.start = get(wfa,'start');
E.rms = rms(wfa);
E.pa = peak_amp(wfa,'val');
E.p2p = peak2peak_amp(wfa,'val');
E.pf = peak_freq(wfa,'val');
E.fi = freq_index(wfa,[1 2],[10 20],'val');
E.mf = middle_freq(wfa,'val');

%%

E_max_512.start = get(wfa_max,'start');
E_max_512.rms = rms(wfa_max);
E_max_512.pa = peak_amp(wfa_max,'val');
E_max_512.p2p = peak2peak_amp(wfa_max,'val');
E_max_512.pf = peak_freq(wfa_max,'val');
E_max_512.fi = freq_index(wfa_max,[1 2],[10 20],'val');
E_max_512.mf = middle_freq(wfa_max,'val');

%%
trig = get(c,'trig');
F = [];
for m = 1:68
for n = 1:numel(stat.index{m})
    k = stat.index{m}(n);
    F.wfa{m}(n) = get_w(ds,scnl,trig(k)-5/24/60/60,trig(k)+10/24/60/60);
end
end

%%
for n = 1:68
    t = get(seed(n),'start');
    seed(n) = get_w(ds,scnl,t-5/24/60/60,t+10/24/60/60);
    seed(n) = filt(seed(n),'bp',[1 15]);
    seed(n) = extract(seed(n),'time',t,t+5.12/24/60/60);
end

%%
for fam = 66;
plotm2(F.wfa{fam},'scale',.4)
end

%%
ev = 2;
temp = event_pick(F.wfa{fam}(ev));
temp = temp{:};
seed(fam) = sst2wfa(temp,F.wfa{fam}(ev));

%%
figure 
scatter(E.start, E.pa,'marker','.','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
hold on
for n=1:49
    k = stat.index{n}
    scatter(E.start(k), E.pa(k),'marker','.','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0])
end

%%
for n=1:49
    tt(n)=min(get(F.wave{n},'start')); 
end

[V R] = sort(tt);

%%
for n=1:66
    [tt{n} cc{n}] = seed_corr(seed(n),ds);
    save('seed_tt.mat','tt')
    save('seed_cc.mat','cc')
end



