%% SCATTER PLOT OF MEDIAN VS. STACKED FREQUENCY
%  RANDOM VARIATION ADDED FOR BETTER VIEW OF MARKER DENSITY
F1 = EM.pfmed;
F2 = EM.pfstk;
r1 = .02*rand(size(F1))-.01;
r2 = .02*rand(size(F2))-.01;
figure
scatter(F1+r1, F2+r2)
ylabel('Stacked Peak Frequency')
xlabel('Median Peak Frequency')

%% SORT ALL EVENT WAVEFORMS INTO A STATION STRUCTURE 'S'
%  ONLY VERTICAL COMPONENT CHANNELS WITH P-ARRIVALS ARE CONSIDERED
warning off
cd('C:\AVO\Deep LP\DLP_wfa')
N = numel(EM.evid);
S = [];
for n = 1:N %numel(EM.evid)
    load([num2str(EM.evid(n)),'.mat'])
    disp(num2str(n))
    W = W(isvertical(W));
    W = W(find(get_picks(W,'p')));
    for m = 1:numel(W)
        sta = strtrim(lower(get(W(m),'station')));
        if ~isfield(S,sta), S.(sta) = []; end
        S.(sta) = [S.(sta) W(m)];
    end
end

%%  LOAD ALL WAVEFORMS FROM THE LARGEST FAMILY FOUND AT STATION 'n'
%   PLOT THE WAVEFORMS & PICKS, AS WELL AS MAP SCATTER PLOT
%   EM - Event Master Structure
%   FM - Family Master Structure
f = fieldnames(FM);
n = 40;
load([f{n},'.mat'])
ind = FM.(f{n}).index{1};
ID = get(W(ind),'evid');
[A B] = intersect(EM.evid,ID);
plot_picks(W(ind),'ylab','time','scale',.25)
title(upper(f{n}))
figure, hold on,
for n=1:numel(AK_coast), plot(AK_coast(n).lon,AK_coast(n).lat,'k'), end
colorscat(EM.lon(B), EM.lat(B), 5.^(EM.mag(B)+.5), EM.pfmed(B))

%%  REMOVE EVENTS FROM EM WHICH ARE OVER 25km FROM A VOLCANIC CENTER
%   EM       - Event Master Structure
%   volc_loc - Volcanic Center Location Structure
for n = 1:length(volc_loc.lat)
    vlat = volc_loc.lat(n).*ones(size(EM.lat));
    vlon = volc_loc.lon(n).*ones(size(EM.lon));
    dist(n,:) = lldistkm(LAT,LON,vlat,vlon);
end
[EM.km2volc, volcnumber] = min(dist);
EM.volc = volc_loc.name(volcnumber);
R = find(mindist <= 25);
EM = substruct(EM,R, 1);
clear vlat vlon dist mindist R

%% 3-DIMENSIONAL SCATTER PLOT OF EVENTS BELOW ALASKA COASTLINE
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot3(AK_coast(n).lon,AK_coast(n).lat,zeros(size(AK_coast(n).lat)),'k')
end
scatter3(volc_loc.lon,volc_loc.lat,zeros(37,1),...
    '^','markerFaceColor','r','markerEdgeColor','k')
for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end
XX = substruct(EM,EM.mag<=3.5,1);
X = XX.pfmed;
X(X>10) = 10;
colorscat3(XX.lon, XX.lat, -XX.depth, 4.^(XX.mag+.5), X)
xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)
ax2 = axes('Position',[.9 .5 .08 .4]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')

%%
cd('C:\AVO\Deep LP\DLP_corr')
load('_Master.mat')
f = fieldnames(FM);
for n = 1:numel(f)
    load([f{n},'.mat'])
    [A B] = intersect(get(W,'evid'),EM.evid);
    W = W(B);
    [A B] = sort(get(W,'start')*24*60*60);
    W = W(B);
    x = A(2:end) - A(1:end-1);
    x1 = find(x<=2);
    x2 = x1+1;
    cut = [];
    for m = 1:numel(x1)
        if get(W(x1(m)),'evid') < get(W(x2(m)),'evid')
            cut = [cut x1(m)];
        else
            cut = [cut x2(m)];
        end
    end
    W(cut) = [];
    disp(f{n})
    P = get_picks(W,'p');
    clear w
    for m = 1:numel(W)
        w(m) = extract(W(m),'TIME',P(m),P(m)+10.24/24/60/60);
    end
    C = correlation(w);
    C = taper(C);
    C = butter(C,[1 10]);
    C = xcorr(C);
    C = sort(C);
    C = adjusttrig(C,'MIN');
    C = linkage(C);
    C = cluster(C,.75);
    stat = getclusterstat(C);
    FM.(f{n}) = stat;
    save(f{n},'W','C','stat')
    close all
    pause(.1)
    plot(C,'corr')
    title(f{n})
    pause(1)
    clear A B C P stat w x x1 x2 cut
end

%%
cd('C:\AVO\Deep LP\DLP_corr')
load('Family_Master.mat')
f = fieldnames(FM);
% Number of station structures
for n = 1:numel(f)
    load([f{n},'.mat'])
    x = find(stat.numel > 1);
    stat = substruct(stat, x, 1);
    % Number of families (>2 events) per station
    FF = waveform;
    for m = 1:numel(stat.index)
        ind = stat.index{m};
        stat.evid{m} = get(W(ind),'evid');
        % Number of events per family
        trg = stat.trig{m};
        for k = 1:numel(trg)
            FW{m}(k) = extract(W(ind(k)),'time',...
                trg(k)-2/24/60/60,trg(k)+23/24/60/60);
        end
        FF = [FF, FW{m}, waveform];
    end
    try
    plotm2(FF,'scale',.25)
    pause(.1)
    set(gcf,'PaperSize',[8.5 11],'PaperPosition',[.4 -.7 8.3 12.5])
    text(.5,.5,upper(f{n}),'FontSize',20)
    print(gcf,'-dpdf','-r600',[f{n},'_family_waveforms.pdf'])
    
    catch
    end
    close all
    clear C W trg stat m k ind FW FF
end

%%
cd('C:\AVO\Deep LP\DLP_wfa')
vlist = unique(EM.volc);
for n = 1:numel(vlist)
    ind = find(strcmp(vlist(n),EM.volc));
    for m = 1:numel(ind)
        M = ind(m);
        load([num2str(EM.evid(M)),'.mat'])
        plot_picks(W,'scale',.5)
        set(gcf,'PaperSize',[8.5 11],'PaperPosition',[0 -.7 8.5 12.0])
        print(gcf,'-dpdf','-r600',[vlist{n},num2str(M)])
        pause(.01)
        close all
    end
end

%%
cd('C:\AVO\Deep LP\DLP_corr')
load('Family_Master.mat')
cd('C:\AVO\Deep LP\DLP_corr\stations')
f = fieldnames(FM);
% Number of station structures
for n = 1:numel(f)
    load([f{n},'.mat'])
    x = find(stat.numel > 1);
    stat = substruct(stat, x, 1);
    FM.(f{n}) = stat;
end

%%
cd('C:\AVO\Deep LP\DLP_corr')
load('Family_Master.mat')
cd('C:\AVO\Deep LP\DLP_corr\stations')
f = fieldnames(FM);
% Number of station structures
EM.fam_connect = cell(size(EM.datenum));
EM.fam_nwave = cell(size(EM.datenum));
for n = 1:numel(f)          % Loop through all stations
    disp(n)
    pause(.01)
    load([f{n},'.mat'])
    F = FM.(f{n});
    for m = 1:numel(F.rank) % Loop through all families
        fn = ['00',num2str(m)];
        fn = fn(end-2:end);
        I = F.index{m};
        for p = 1:numel(I)  % Loop through all events
            id = get(W(I(p)),'evid');
            N = find(EM.evid == id);
            EM.fam_connect{N} = [EM.fam_connect{N} {[f{n},fn]}];
            %EM.fam_nwave{N} = [EM.fam_nwave(N) F.numel(p)];
        end
    end
end

%% SCATTER PLOT OF ALL DEEP MULTIPLET EVENTS
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot(AK_coast(n).lon,AK_coast(n).lat,'k')
end

xEM = substruct(EM,find(EM.mag>3.5),0);
scatter(xEM.lon, xEM.lat, 4.^(xEM.mag+.5),...
        'markerFaceColor',[1 1 1], 'markerEdgeColor',[0 0 0])
sEM = substruct(EM,find(EM.fam_ns>2),1);
scatter(sEM.lon, sEM.lat, 4.^(sEM.mag+.5),...
        'markerFaceColor',[0 1 0], 'markerEdgeColor',[0 0 0])
scatter(volc_loc.lon,volc_loc.lat,...
    '^','markerFaceColor','r','markerEdgeColor','k')
xlim([-185 -150])
ylim([50 63])

ax2 = axes('Position',[.9 .5 .08 .4]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')

%% 3D SCATTER PLOT OF DEEP MULTIPLET EVENTS
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot3(AK_coast(n).lon,AK_coast(n).lat,zeros(size(AK_coast(n).lat)),'k')
end

xEM = substruct(EM,find(EM.mag>2.9),1);
for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end
scatter3(xEM.lon, xEM.lat, -xEM.depth, 4.^(xEM.mag+.5),...
        'markerEdgeColor',[.6 .6 .6])
for n = 1:150
    sEM = substruct(EM,FAM.evid{n},1,'evid');
    scatter3(sEM.lon, sEM.lat, -sEM.depth, 4.^(sEM.mag+.5),...
        'markerFaceColor',[rand rand rand], 'markerEdgeColor',[0 0 0])
end
scatter3(volc_loc.lon,volc_loc.lat,zeros(size(volc_loc.lat)),...
    '^','markerFaceColor','r','markerEdgeColor','k')
xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)

% 
ax2 = axes('Position',[.9 .5 .08 .4]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')
clear a ax1 ax2 fh n xEM

%% 3D SCATTER PLOT OF DEEP MULTIPLET EVENTS (ANIMATION)
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot3(AK_coast(n).lon,AK_coast(n).lat,zeros(size(AK_coast(n).lat)),'k')
end

xEM = substruct(EM,find(EM.mag>3.5),0);
for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end
%scatter3(xEM.lon, xEM.lat, -xEM.depth, 4.^(xEM.mag+.5),...
%        'markerEdgeColor',[.6 .6 .6])
scatter3(volc_loc.lon,volc_loc.lat,zeros(size(volc_loc.lat)),...
    '^','markerFaceColor','r','markerEdgeColor','k')
xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)

for n = 1:150
    sEM = substruct(EM,FAM.evid{n},1,'evid');
    scatter3(sEM.lon, sEM.lat, -sEM.depth, 4.^(sEM.mag+.5),...
        'markerFaceColor',[rand rand rand], 'markerEdgeColor',[0 0 0])
    pause(.01)
end

ax2 = axes('Position',[.9 .3 .04 .2]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')
clear a ax1 ax2 fh n sEM xEM

%%
set(gcf,'PaperSize',[12 11],'PaperPosition',[ -.5 -.5 12 12])
print(gcf,'-dpdf','-r1200',['Family_Median_Mari_Numel.pdf'])

%%
[A B] = sort(EM.fam_nconnect);
A = flipud(A);
B = flipud(B);
n = 1;
FAM.evid ;
while B(n) > 0
  
end

%%
sta_fam = [];
%cd('C:\AVO\Deep LP\DLP_corr')
%load('Family_Master.mat')
cd('C:\AVO\Deep LP\DLP_corr\stations')
volclist = unique(sta_loc.volc);
f = fieldnames(FM);
for n = 1:numel(f)          % Loop through all stations
    try
    volc = sta_loc.volc(find(strcmpi(f{n},sta_loc.name)));
    volcn = find(strcmpi(volclist,volc));
    disp(n)
    pause(.01)
    load([f{n},'.mat'])
    F = FM.(f{n});
    for m = 1:numel(F.rank) % Loop through all families
        new_row = [n, F.rank(m), F.numel(m), volcn];
        sta_fam = [sta_fam; new_row];
    end
    catch
    end
end

[A B] = sort(sta_fam(:,3));
A = flipud(A);
B = flipud(B);
sta_fam = sta_fam(B,:);

%%
sta_num = sta_fam(1,1);
fam_num = sta_fam(1,2);
load([f{sta_num},'.mat'])
evid = get(W(stat.index{fam_num}),'evid');
FAM.all_evid = evid;
FAM.all_fid = ones(size(evid));
FAM.fid(1) = 1;
FAM.evid{1} = evid;
for n = 2:595%numel(sta_fam(:,1))

    sta_num = sta_fam(n,1);
    fam_num = sta_fam(n,2);
    load([f{sta_num},'.mat'])
    evid = get(W(stat.index{fam_num}),'evid');
    [ovr_evid, r1, r2] = intersect(FAM.all_evid, evid);
    trim_evid = evid;
    trim_evid(r2) = [];
    ovr_fid = (FAM.all_fid(r1));
    [val, cnt] = count_unique(ovr_fid);
    [maxcnt, maxval] = max(cnt);
    if isempty(maxcnt)
        maxcnt = 0;
    end
    
    if (maxcnt >= numel(evid/2))
        % MERGE FAMILY IF AT LEAST TWO EVENTS OVERLAP
        N = maxval;
        FAM.evid{N} = unique([FAM.evid{N}, trim_evid]);
        disp(['n = ',num2str(n),', Merging with family ',num2str(N),...
            ', ',num2str(maxcnt),' events overlap'])
        FAM.all_evid = [FAM.all_evid, trim_evid];
        FAM.all_fid = [FAM.all_fid, trim_evid./trim_evid*N];
    elseif numel(trim_evid) > 2
        % NEW FAMILY
        N = numel(FAM.fid)+1;
        FAM.fid(N) = N;
        FAM.evid{N} = trim_evid;
        disp(['Created Family Number ',num2str(N),', with ',...
            num2str(numel(trim_evid)),' Events'])
        FAM.all_evid = [FAM.all_evid, trim_evid];
        FAM.all_fid = [FAM.all_fid, trim_evid./trim_evid*N];
    end

clear sta_num fam_num evid ovr_evid r1 r2 ovr_fid val cnt maxcnt maxval N
end

%% SCATTER PLOT OF PRIMARY MULTIPLET EVENT
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot(AK_coast(n).lon,AK_coast(n).lat,'k')
end

xEM = substruct(EM,find(EM.mag>3.5),0);
scatter(xEM.lon, xEM.lat, 4.^(xEM.mag+.5),...
    'markerFaceColor',[1 1 1], 'markerEdgeColor',[.6 .6 .6])
for n = 1:150
    sEM = substruct(EM,FAM.evid{n},1,'evid');
    scatter(sEM.lon, sEM.lat, 4.^(sEM.mag+.5),...
        'markerFaceColor',[rand rand rand], 'markerEdgeColor',[0 0 0])
end
scatter(volc_loc.lon,volc_loc.lat,...
    '^','markerFaceColor','r','markerEdgeColor','k')
xlim([-185 -150])
ylim([50 63])

ax2 = axes('Position',[.9 .5 .08 .4]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')
clear a ax1 ax2 fh n sEM xEM

%% 3D SCATTER PLOT OF DEEP MULTIPLET EVENTS COLORED BY MED PF
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot3(AK_coast(n).lon,AK_coast(n).lat,zeros(size(AK_coast(n).lat)),'k')
end

for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end

sEM = substruct(EM,FAM.all_evid,1,'evid');

X = sEM.pfmed;
X(X>10) = 10;
colorscat3(sEM.lon, sEM.lat, -sEM.depth, 4.^(sEM.mag+.5),X,'range',0:10)

scatter3(volc_loc.lon,volc_loc.lat,zeros(size(volc_loc.lat)),...
    '^','markerFaceColor','r','markerEdgeColor','k')

min_pf = min(X);
max_pf = max(X);

ch = colorbar;
set(ch,'colormap','Jet')
tick = 0:10;
for n = 1:numel(tick)
    ticklab{n} = [num2str(tick(n)),' Hz'];
end
tick = (tick-min_pf)./max_pf;
set(ch,'Position',[.9 .51 .03 .3],...
    'YTickMode','manual','YTickLabelMode','manual',...
    'YTick',tick,'YTickLabel',ticklab)

xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)
ax2 = axes('Position',[.9 .15 .03 .3]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 4.^(.5+a),'k')
clear X a ax1 ax2 ch fh max_pf min_pf n sEM tick ticklab

%%
EM.fam_id = zeros(3201,1);
for n = 1:numel(FAM.evid)
    [Val r1 r2] = intersect(EM.evid, FAM.evid{n}, 'stable');
    EM.fam_id(r1) = n;
end

%% 3D SCATTER PLOT OF DEEP MEDIAN-MULTIPLET EVENTS COLORED BY MED PF
fh = figure;
ax1 = axes;
hold on
for n=1:numel(AK_coast)
    plot3(AK_coast(n).lon, AK_coast(n).lat, zeros(size(AK_coast(n).lat)),'k')
end

for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end

lon = [];
lat = [];
mag = [];
depth = [];
pf = [];
for n = 1:150
    subEM = substruct(EM, find(EM.fam_id == n), 1);
    lon(n) = median(subEM.lon);
    lat(n) = median(subEM.lat);
    mag(n) = median(subEM.mag);
    depth(n) = median(subEM.depth);
    pf(n) = median(subEM.pfmed); 
    num(n) = numel(subEM.evid);
end
pf(pf>10) = 10;
%colorscat3(lon, lat, -depth, 8.^(mag+.5),pf,'cbar',0)
colorscat3(lon, lat, -depth, 5*num,pf,'cbar',0)

scatter3(volc_loc.lon,volc_loc.lat,zeros(size(volc_loc.lat)),...
    '^','markerFaceColor','r','markerEdgeColor','k')

min_pf = min(pf);
max_pf = max(pf);

ch = colorbar;
set(ch,'colormap','Jet')
tick = 0:10;
for n = 1:numel(tick)
    ticklab{n} = [num2str(tick(n)),' Hz'];
end
tick = (tick-min_pf)./max_pf;
set(ch,'Position',[.9 .51 .03 .3],...
    'YTickMode','manual','YTickLabelMode','manual',...
    'YTick',tick,'YTickLabel',ticklab)

xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)
ax2 = axes('Position',[.9 .15 .03 .3]);
%a = .5:.5:3.5; 
a = .5:.5:2.5; 
s = [5, 10, 20, 50, 100];
%scatter(zeros(size(a)), a, 8.^(.5+a),'k')
scatter(zeros(size(a)), a, 5*s,'k')
set(gca,'xTickLabel',{})

clear a ax1 ax2 ch depth fh lat lon mag max_pf min_pf n num pf s subEM tick ticklab
