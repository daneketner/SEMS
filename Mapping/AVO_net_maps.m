
%% Make AVO Network Maps

kpi = 20;

for n = 1:numel(M.volc)
    
    lat = M.lat{n};
    lon = M.lon{n};
    dlat = lldistkm(lat(1),lon(1),lat(2),lon(1));
    dlon = lldistkm(lat(1),lon(1),lat(1),lon(2));
    fh = figure;
    set(fh,'Position',[10,10,round(kpi*dlon),round(kpi*dlat)])
    set(fh,'Color',[1 1 1])
    plot_dem(lat,lon,cmap)
    s = substruct(S, S.lon>lon(1) & S.lon<lon(2) & S.lat>lat(1) & S.lat<lat(2), 1);
    scatter(s.lon, s.lat,'^','MarkerEdgeColor','k','MarkerFaceColor','r')
    for m = 1:numel(s.name)
        text(s.lon(m), s.lat(m)-.01, upper(s.name{m}),...
            'FontSize',14,'FontWeight','bold','HorizontalAlignment','center','Color','k');
        text(s.lon(m)+.0007, s.lat(m)-.01+.0007, upper(s.name{m}),...
            'FontSize',14,'FontWeight','bold','HorizontalAlignment','center','Color','w');
    end
    xlim(lon)
    ylim(lat)

    export_fig(M.volc{n},'-pdf')
    close all
end

%%
figure
hold on
set(gcf,'Color',[1 1 1])
for n=1:numel(AK_coast)
    plot(AK_coast(n).lon,AK_coast(n).lat,'k')
end
grid on
for n = 1:numel(M.volc)
    x = M.lon{n};
    y = M.lat{n};
    x(x>0) = x(x>0)-360;
    rectangle('EdgeColor','r','Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
end

%%

M.volc{1} = 'Spurr';
M.lat{1} = [61.12 61.43];
M.lon{1} = [-152.73 -151.95];

M.volc{2} = 'Redoubt';
M.lat{2} = [60.378389 60.634970 ];
M.lon{2} = [-153.030006 -152.545065];

M.volc{3} = 'Iliamna';
M.lat{3} = [59.920868 60.099048];
M.lon{3} = [-153.244244 -152.894689];

M.volc{4} = 'Augustine';
M.lat{4} = [59.30 59.43];
M.lon{4} = [-153.60 -153.32];

M.volc{5} = 'Fourpeaked';
M.lat{5} = [58.7 58.95];
M.lon{5} = [-153.85 -153.35];

M.volc{6} = 'Katmai';
M.lat{6} = [57.962648 58.584450];
M.lon{6} = [-155.647016 -154.455481];

M.volc{7} = 'Peulik';
M.lat{7} = [57.563982 58.086408];
M.lon{7} = [-156.95 -156.13];

M.volc{8} = 'Aniakchak';
M.lat{8} = [56.75 57.00];
M.lon{8} = [-158.37 -157.97];

M.volc{9} = 'Veni';
M.lat{9} = [55.95 56.40];
M.lon{9} = [-159.65 -159.10];

M.volc{10} = 'Pavof';
M.lat{10} = [55.25 55.52];
M.lon{10} = [-162.10 -161.70];

M.volc{11} = 'Shishaldin';
M.lat{11} = [54.60 54.90];
M.lon{11} = [-164.17 -163.65];

M.volc{12} = 'Westdahl';
M.lat{12} = [54.38 54.65];
M.lon{12} = [-164.9 -164.45];

M.volc{13} = 'Akutan';
M.lat{13} = [54 54.25]; 
M.lon{13} = [-166.15 -165.65];

M.volc{14} = 'Makushin';
M.lat{14} = [53.73 54.02];
M.lon{14} = [-167.12 -166.60];

M.volc{15} = 'Okmok';
M.lat{15} = [53.214299 53.57];
M.lon{15} = [-168.35 -167.9];

M.volc{16} = 'Korovin';
M.lat{16} = [52.22 52.42]; 
M.lon{16} = [-174.30 -174.00];

M.volc{17} = 'GreatSitkin';
M.lat{17} = [51.96 52.13];
M.lon{17} = [-176.22 -176];

M.volc{18} = 'Kanaga';
M.lat{18} = [51.73 51.96];
M.lon{18} = [-177.28 -177.04];

M.volc{19} = 'Tanaga';
M.lat{19} = [51.639776 52.00];
M.lon{19} = [-178.114244 -177.870530];

M.volc{20} = 'Gareloi';
M.lat{20} = [51.74 51.85];
M.lon{20} = [-178.91 -178.70];

M.volc{21} = 'Semi';
M.lat{21} = [51.802361 52.101632]; 
M.lon{21} = [179.497862 179.732294]-360;

M.volc{22} = 'LittleSitkin';
M.lat{22} = [51.852547 52.033302];
M.lon{22} = [178.468789 178.559991]-360;