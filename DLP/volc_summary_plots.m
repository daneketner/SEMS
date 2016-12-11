function volc_summary_plots(EM, volc_loc)

for kk = 1:numel(volc_loc.name)
    vn = volc_loc.name{kk};
    vlat = volc_loc.lat(kk);
    vlon = volc_loc.lon(kk);
    min_pf = 0;
    max_pf = 10;
    fh = figure;
    
    %% Extract subset of events from volcanic center that are located at a
    %  maximum distance 'd' from the volcanic center
    d = 25;
    [sub_lat, sub_lon] = llboxkm(vlat, vlon, d);
    subIND = find(EM.lat > sub_lat(1) & ...
                  EM.lat < sub_lat(2) & ...
                  EM.lon > sub_lon(1) & ...
                  EM.lon < sub_lon(2) & ...
                  ~isnan(EM.pfmed));
    subEM = substruct(EM,subIND,1);
    subPF = subEM.pfmed;
    subPF(subPF>max_pf) = max_pf;
    subPF(subPF<min_pf) = min_pf;
    dem = getdem(sub_lat, sub_lon);
    x = linspace(sub_lon(1),sub_lon(2),size(dem,2));
    y = linspace(sub_lat(1),sub_lat(2),size(dem,1));
    
    %% AX1 - Contour Map View [Northing vs. Easting] (Top Left)
    ax1 = axes('Position',[.08 .66 .41 .28]);
    hold on
    cmap = repmat(linspace(1,.5,70)',1,3);
    [dem, x, y] = plot_dem(sub_lat,sub_lon,cmap);
    colorscat(subEM.lon, subEM.lat, 4.^(subEM.mag+.5), subPF, 'cbar', 0)
    grid on
    set(ax1,'XAxisLocation','top')
    xlim(sub_lon);
    xlabel('Easting (Degrees)')
    ylim(sub_lat)
    ylabel('Northing (Degrees)')  
    
    %% AX2 - Depth Profile View [Depth vs. Northing] (Top Right)
    ax2 = axes('Position',[.51 .66 .41 .28]);
    hold on
    plot(dem(:,ceil(size(dem,2)/2))/1000,y,'k')
    colorscat(-subEM.depth, subEM.lat, 4.^(subEM.mag+.5), subPF, 'cbar', 0)
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
    plot(x,dem(ceil(size(dem,1)/2),:)/1000,'k')
    colorscat(subEM.lon, -subEM.depth, 4.^(subEM.mag+.5), subPF, 'cbar', 0)
    grid on
    xlim(sub_lon);
    xlabel('Easting (Degrees)')
    ylim([-50 10])
    ylabel('Depth (km)')
    linkaxes([ax1, ax3],'x')
    
    %% AX4.A - Depth vs. Frequency Histogram
    ax4a = axes('Position',[.54 .36 .33 .12]);
    x1 = min(subEM.depth);
    x2 = max(subEM.depth);
    colorhist(subEM.depth,subEM.pfmed,'xbins',15:1:45,'cbins',0:.25:10)
    xlabel('Depth (km)')
    dx = x2-x1;
    xlim([x1-dx/25, x2+dx/25])
    grid on
    
    %% AX4.B - Magnitude vs. Frequency Histogram 
    ax4b = axes('Position',[.54 .52 .33 .12]);
    x1 = min(subEM.mag);
    x2 = max(subEM.mag);
    colorhist(subEM.mag,subEM.pfmed,'xbins',x1:.1:x2,'cbins',0:.25:10)
    xlabel('Magnitude')
    dx = x2-x1;
    xlim([x1-dx/25, x2+dx/25])
    grid on
    
    %% AX4.C - Magnitude Marker Scale
    ax4c = axes('Position',[.54 .65 .33 .035]);
    tick = -1:.5:4;
    scatter(tick,zeros(size(tick)),4.^(tick+.5),...
        'markerEdgeColor','k','markerFaceColor','k')
    set(ax4c,'Visible','off')
    ylim([0, 1])
    xlim(get(ax4b,'xlim'))
    
    %% Color Bar
    ch = colorbar;
    set(ch,'colormap','Jet')
    tick = min_pf:max_pf;
    for n = 1:numel(tick)
        ticklab{n} = [num2str(tick(n)),' Hz'];
    end
    tick = (tick-min_pf)./max_pf;
    set(ch,'Position',[.9 .36 .03 .28],...
        'YTickMode','manual','YTickLabelMode','manual',...
        'YTick',tick,'YTickLabel',ticklab)
    %% AX5 - [Depth vs. Time] (Lower Right)
    ax5 = axes('Position',[.08 .05 .84 .26]);
    colorscat(subEM.datenum, -subEM.depth, 4.^(subEM.mag+.5), subPF, 'cbar', 0)
    grid on
    dynamicDateTicks
    xlabel('Time (years)')
    ylim([-50 0])
    ylabel('Depth (km)')  
    
    %% AX6 - Title
    ax5 = axes('Position',[.38 .97 .45 .035],'Visible','off');
    text(0,0,upper(vn),'FontSize',18)
    
    %% Print the mother
    warning off
    set(fh,'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
    print(fh,'-dpdf','-r300',[vn,'_Summary.pdf'])
    pause(.1)
    close all
    pause(.1)
end

