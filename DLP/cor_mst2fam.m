function EM = cor_mst2fam(EM, CM)
%function [EM, FM] = cor_mst2fam(EM, CM)

EM.fam_id = zeros(size(EM.evid));
evnum = 1:length(EM.evid);
dkm = lldistkm(EM.lat,EM.lon,EM.lat,EM.lon);

%% Define familiy criteria
CM75 = CM.cc075cnt.*(dkm<50);
%CM65 = CM.cc065cnt;
%CMmean = CM.ccmean;
%CMmax = CM.ccmax;

k = 1;
done = 0;
while ~done
    [V, ME_ind] = max(sum(CM75)); % ME_ind (Master Event index)
    sub = find(CM75(:,ME_ind)>0);
    if numel(sub) == 0
        done = 1;
    elseif numel(sub) < 3
        CM75(:, sub) = [];
        CM75(sub, :) = [];
        evnum(sub) = [];
    else
        CM75(:, sub) = [];
        CM75(sub, :) = [];
        EM.fam_id(evnum(sub)) = k;
        subEM = substruct(EM,evnum(sub),1);
        align_waves(subEM, k);
        evnum(sub) = [];
        k = k+1;
    end
end

function align_waves(subEM, k)
%%

Dir = make_dir_mstr;
ds = 1/24/60/60;
WW = [];
for kk = 1:numel(subEM.evid)
    load([Dir.Evt_Wav,'\',num2str(subEM.evid(kk)),'.mat'])
    WW = [WW, W];
end
WW = WW(isvertical(WW));
p = get_picks(W,'p');
WW(p == 0) = [];
WW = sta_sort_waves(WW);

for ss = 1:numel(WW)
    w = WW{ss};
    sta = get(w(1),'station');
    p = get_picks(w,'p');
    c = correlation(w);
    c = set(c,'trig',p);
    c = taper(c);
    c = butter(c,[1 10]);
    c = xcorr(c,[0 10.24]);
    c = adjusttrig(c,'MIN');
    t = get(c,'trig');
    [t ind] = sort(t);
    w = w(ind);
    c = sort(c);
    FC.(sta) = c;
    for n = 1:numel(p)
        FW.(sta)(n) = extract(w(n), 'TIME', t(n)-2*ds, t(n)+18*ds);
    end
    
    fh = figure('Position',[1,1,1200,600]);
    ax1 = axes('position',[.11 .01 .4 .98]);
    plot_picks(FW.(sta))
    ax2 = axes('position',[.51 .01 .48 .98]);
    imagesc(get(c,'corr'))
    
    name = [Dir.Fam_Wav,'Fam',sprintf('%03d',k),sta];
    export_fig(name,'-pdf')
    close all
end
save([Dir.Fam_Wav,'Fam',sprintf('%03d',k)],'FW')
save([Dir.Fam_Cor,'Fam',sprintf('%03d',k)],'FC')


function WW = sta_sort_waves(WW)
%%

sta = get(WW,'station');
[val, cnt] = count_unique(sta);
val(cnt < 3) = [];
cnt(cnt < 3) = [];
[x, ind] = sort(cnt,'descend');
sta_list = val(ind);
for n = 1:numel(sta_list)
    remain = get(WW,'station');
    sub = strcmp(sta_list{n},remain);
    W{n} = WW(sub);
    WW(sub) = [];
end
WW = W;


