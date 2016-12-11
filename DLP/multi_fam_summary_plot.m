function multi_fam_summary_plot(EM, FM, ind, lat, lon, cmap, difmap)

ind = fliplr(ind);
all_lat = [];
all_lon = [];
ni = numel(ind);
colors = difmap(ni:-1:1,:);
volc = [];
for k = 1:ni
    kk = ind(k);
    fevid{k} = FM(kk).evid{1};
    [val iEM{kk} iFM] = intersect(EM.evid,fevid{k});
    X{k} = substruct(EM, iEM{kk}, 1);
    all_lat = [all_lat; X{k}.lat];
    all_lon = [all_lon; X{k}.lon];
    if isempty(volc)
        volc = X{k}.volc{1};
    end
end

fh = figure;

%% Extract subset of events from volcanic center that are located at a
%  maximum distance 'd' from the volcanic center
d = 25;
lat_deg = d/110.54;
lon_deg = d/(111.320*cosd(median(all_lat)));
%sub_lat = [min(all_lat) max(all_lat)];
%sub_lon = [min(all_lon) max(all_lon)];
subIND = find(EM.lat > lat(1) & ...
              EM.lat < lat(2) & ...
              EM.lon > lon(1) & ...
              EM.lon < lon(2));
subEM = substruct(EM,subIND,1);

%% AX1 - Contour Map View [Northing vs. Easting] (Top Left)
ax1 = axes('Position',[.08 .66 .41 .28]);
set(ax1,'Color',[.8 .8 1])
hold on
[dem, x, y] = plot_dem(lat,lon,cmap);
scatter(subEM.lon, subEM.lat, 4.^(subEM.mag+.5),...
    'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
for k = 1:ni
    scatter(X{k}.lon, X{k}.lat, 4.^(X{k}.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',colors(k,:))
end
grid on
set(ax1,'XAxisLocation','top')
xlim(lon);
xlabel('Easting (Degrees)')
ylim(lat)
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
for k = 1:ni
    scatter(-X{k}.depth, X{k}.lat, 4.^(X{k}.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',colors(k,:))
end
grid on
set(ax2,'XAxisLocation','top')
xlim([-50 10])
xlabel('Depth (km)')
set(ax2,'XDir','Reverse')
set(ax2,'YAxisLocation','right')
ylim(lat)
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
for k = 1:ni
    scatter(X{k}.lon, -X{k}.depth, 4.^(X{k}.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',colors(k,:))
end
grid on
xlim(lon);
xlabel('Easting (Degrees)')
ylim([-50 10])
ylabel('Depth (km)')
linkaxes([ax1, ax3],'x')

%% AX4 - Master Station Waveform
ax4 = axes('Position',[.57 .36 .38 .28 ]);
plot_chrono2(FM,ind,colors)

%% AX5 - [Depth vs. Time] (Lower Right)
ax5 = axes('Position',[.08 .05 .84 .26]);
hold on
scatter(subEM.datenum, -subEM.depth, 4.^(subEM.mag+.5),...
    'markerEdgeColor',[.7 .7 .7],'markerFaceColor',[1 1 1])
for k = 1:ni
    scatter(X{k}.datenum, -X{k}.depth, 4.^(X{k}.mag+.5),...
        'markerEdgeColor',[0 0 0],'markerFaceColor',colors(k,:))
end
grid on
dynamicDateTicks
xlabel('Time (years)')
ylim([-50 0])
ylabel('Depth (km)')

%% AX6 - Title
ax5 = axes('Position',[.38 .97 .45 .035],'Visible','off');
text(0,0,upper([volc,' Families']),'FontSize',16)

%% Print the mother
warning off
set(fh,'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
print(fh,'-dpdf','-r300',[volc, '_Families.pdf'])
% pause(.1)
% close all
% pause(.1)