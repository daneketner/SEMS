function arc_summary_plot(EM, volc_loc, AK_coast)

%%
vn = volc_loc.name;
vlat = volc_loc.lat;
vlon = volc_loc.lon;
min_pf = 0;
max_pf = 10;
fh = figure;

%% Optional - Remove Large Magnitude Events
%  subEM = substruct(EM,find(EM.mag<=3.5),1);

%% Extract subset of events from volcanic center that are located at a
%  maximum distance 'd' from the volcanic center
% d = 25;
% lat_deg = d/110.54;
% lon_deg = d/(111.320*cosd(vlat));
% sub_lat = [vlat-lat_deg vlat+lat_deg];
% sub_lon = [vlon-lon_deg vlon+lon_deg];
% subIND = find(EM.lat > sub_lat(1) & ...
%     EM.lat < sub_lat(2) & ...
%     EM.lon > sub_lon(1) & ...
%     EM.lon < sub_lon(2));
% subEM = substruct(EM,subIND,1);
% subPF = subEM.pfmed;
% subPF(subPF>max_pf) = max_pf;
% subPF(subPF<min_pf) = min_pf;
% dem = getdem(sub_lat, sub_lon);
% x = linspace(sub_lon(1),sub_lon(2),size(dem,2));
% y = linspace(sub_lat(1),sub_lat(2),size(dem,1));

%% AX1 - Contour Map View [Northing vs. Easting] (Top Left)
ax1 = axes('Position',[.08 .66 .41 .28]);
hold on
for n=1:numel(AK_coast)
    plot(AK_coast(n).lon,AK_coast(n).lat,'k')
end
colorscat(EM.lon, EM.lat, 4.^(EM.mag+.5), EM.pfmed, 'cbar', 0)
grid on
set(ax1,'XAxisLocation','top')
%xlim(sub_lon);
xlabel('Easting (Degrees)')
%ylim(sub_lat)
ylabel('Northing (Degrees)')

%% AX2 - Depth Profile View [Depth vs. Northing] (Top Right)
ax2 = axes('Position',[.51 .66 .41 .28]);
hold on
colorscat(-EM.depth, EM.lat, 4.^(EM.mag+.5), EM.pfmed, 'cbar', 0)
grid on
set(ax2,'XAxisLocation','top')
xlim([-50 10])
xlabel('Depth (km)')
set(ax2,'XDir','Reverse')
set(ax2,'YAxisLocation','right')
%ylim(sub_lat)
ylabel('Northing (Degrees)')
linkaxes([ax1, ax2],'y')

%% AX3 - Depth Profile View [Depth vs. Easting] (Middle Left)
ax3 = axes('Position',[.08 .36 .41 .28 ]);
hold on
colorscat(EM.lon, -EM.depth, 4.^(EM.mag+.5), EM.pfmed, 'cbar', 0)
grid on
%xlim(sub_lon);
xlabel('Easting (Degrees)')
ylim([-50 10])
ylabel('Depth (km)')
linkaxes([ax1, ax3],'x')

%% AX4.A - Depth vs. Frequency Histogram
ax4a = axes('Position',[.54 .36 .33 .12]);
x1 = min(EM.depth);
x2 = max(EM.depth);
Nx = 30;
dx = (x2-x1)/Nx;
colorhist(EM.depth,EM.pfmed,Nx,64)
tick = x1+dx:2*dx:x2;
for n = 1:numel(tick), ticklb{n} = sprintf('%0.0f',tick(n)); end
set(ax4a,'XTick',tick);
set(ax4a,'XTickLab',ticklb);
xlabel('Depth (km)')
xlim([x1, x2])
grid on

%% AX4.B - Magnitude vs. Frequency Histogram
ax4b = axes('Position',[.54 .52 .33 .12]);
x1 = min(EM.mag);
x2 = max(EM.mag);
dx = (x2-x1)/Nx;
colorhist(EM.mag,EM.pfmed,Nx,64)
tick = x1+dx:4*dx:x2;
for n = 1:numel(tick), ticklb{n} = sprintf('%0.1f',tick(n)); end
set(ax4b,'XTick',tick);
set(ax4b,'XTickLab',ticklb);
xlabel('Magnitude')
xlim([x1, x2])
grid on

%% AX4.C - Magnitude Marker Scale
ax4c = axes('Position',[.54 .65 .33 .035]);
scatter(tick,zeros(size(tick)),4.^(tick+.5),...
    'markerEdgeColor','k','markerFaceColor','k')
set(ax4c,'Visible','off')
ylim([0, 1])
xlim([x1, x2])

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
colorscat(EM.datenum, -EM.depth, 4.^(EM.mag+.5), EM.pfmed, 'cbar', 0)
grid on
dynamicDateTicks
xlabel('Time (years)')
ylim([-50 0])
ylabel('Depth (km)')

%% AX6 - Title
ax5 = axes('Position',[.38 .97 .45 .035],'Visible','off');
text(0,0,'AVO Networks','FontSize',18)

%% Print the mother
warning off
set(fh,'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
print(fh,'-dpdf','-r300','AVO Networks_Summary.pdf')
pause(.1)
close all
pause(.1)
