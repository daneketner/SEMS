function fam_summary_plots_2(EM, FM, cmap)

Dir = make_dir_mstr;

for kk = 1:numel(FM)
    fevid = FM(kk).evid{1};
    [val iEM iFM] = intersect(EM.evid,fevid);
    X = substruct(EM, iEM, 1);
    vn = X.volc{1};
    vlat = median(X.lat);
    vlon = median(X.lon);
    min_pf = 0;
    max_pf = 10;
    fh = figure;
    
    %% Extract subset of events from volcanic center that are located at a
    %  maximum distance 'd' from the volcanic center
    d = 25;
    lat_deg = d/110.54;
    lon_deg = d/(111.320*cosd(vlat));
    sub_lat = [vlat-lat_deg vlat+lat_deg];
    sub_lon = [vlon-lon_deg vlon+lon_deg];
    subIND = find(EM.lat > sub_lat(1) & ...
                  EM.lat < sub_lat(2) & ...
                  EM.lon > sub_lon(1) & ...
                  EM.lon < sub_lon(2));
    subEM = substruct(EM,subIND,1);
    subPF = subEM.pfmed;
    subPF(subPF>max_pf) = max_pf;
    subPF(subPF<min_pf) = min_pf;
    
    %% AX1 - Contour Map View [Northing vs. Easting] (Top Left)
    ax1 = axes('Position',[.08 .66 .41 .28]);
    set(ax1,'Color',[.8 .8 1])
    hold on
    try
    [dem, x, y] = plot_dem(sub_lat,sub_lon,cmap);
    catch
    end
    scatter(subEM.lon, subEM.lat, 4.^(subEM.mag+.5),...
        'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
    scatter(X.lon, X.lat, 4.^(X.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',[1 0 0])
    grid on
    set(ax1,'XAxisLocation','top')
    xlim(sub_lon);
    xlabel('Easting (Degrees)')
    ylim(sub_lat)
    ylabel('Northing (Degrees)')  
    
    %% AX2 - Depth Profile View [Depth vs. Northing] (Top Right)
    ax2 = axes('Position',[.51 .66 .41 .28]);
    hold on
    try
    plot(dem(:,ceil(size(dem,2)/2))/1000,y,'k')
    catch
    end
    scatter(-subEM.depth, subEM.lat, 4.^(subEM.mag+.5),...
        'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
    scatter(-X.depth, X.lat, 4.^(X.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',[1 0 0])
    grid on
    set(ax2,'XAxisLocation','top')
    xlim([-50 10])
    xlabel('Depth (km)')
    set(ax2,'XDir','Reverse')
    set(ax2,'YAxisLocation','right')
    ylim(sub_lat)
    ylabel('Northing (Degrees)')
    linkaxes([ax1, ax2],'y')
    
    %% AX3 - Depth Profile View [Depth vs. Easting] (Middle Left)
    ax3 = axes('Position',[.08 .36 .41 .28 ]);
    hold on
    try
    plot(x,dem(ceil(size(dem,1)/2),:)/1000,'k')
    catch
    end
    scatter(subEM.lon, -subEM.depth, 4.^(subEM.mag+.5),...
        'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
    scatter(X.lon, -X.depth, 4.^(X.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',[1 0 0])
    grid on
    xlim(sub_lon);
    xlabel('Easting (Degrees)')
    ylim([-50 10])
    ylabel('Depth (km)')
    linkaxes([ax1, ax3],'x')
    
    %% AX4 - Master Station Waveform
    load([Dir.Fam_Wav,'\Family',sprintf('%03d',kk)])
    ax4 = axes('Position',[.7 .36 .25 .28 ]);
    plot_picks(FW{1},'scale',.5,'ylab','time')    
    xlim([3, 18])
    sta = get(FW{1}(1),'station');

    %% AX5 - [Depth vs. Time] (Lower Right)
    ax5 = axes('Position',[.08 .05 .84 .26]);
    hold on
    scatter(subEM.datenum, -subEM.depth, 4.^(subEM.mag+.5),...
        'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
    scatter(X.datenum, -X.depth, 4.^(X.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',[1 0 0])
    grid on
    dynamicDateTicks
    xlabel('Time (years)')
    ylim([-50 0])
    ylabel('Depth (km)')  
    
    %% AX6 - Title
    ax5 = axes('Position',[.38 .97 .45 .035],'Visible','off');
    text(0,0,upper([vn,' - ',sta]),'FontSize',16)
    
    %% Print the mother
    warning off
    set(fh,'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
    print(fh,'-dpdf','-r300',['Family',sprintf('%03d',kk),'_Summary.pdf'])
    pause(.1)
    close all
    pause(.1)
end