function plotLightning(R,V,Range,dr,L)

%%
load([dr, '\COAST.mat'])
figure, hold on
set(gcf,'Color',[1 1 1])
Time = L.(R).(V).Strikes(:,1);
Latitude = L.(R).(V).Strikes(:,2);
Longitude = L.(R).(V).Strikes(:,3);
Azimuth = L.(R).(V).Strikes(:,4);
Distance = L.(R).(V).Strikes(:,5);
utcNow = local2UTC(now);

switch(Range)
    case 'All', ind = Time > 0;
    case 'Year', ind =  Time > utcNow-365;
    case 'Month', ind =  Time > utcNow-30;
    case 'Week', ind =  Time > utcNow-7;
    case 'Day', ind = Time > utcNow-1;
    otherwise
end
emptyPlot = isempty(Time(ind));  
STK = L.(R).(V).Strikes(ind,:);

if strcmp(Range,'Day')
    i1 = (Time >= utcNow-1)&(Time < utcNow-1/4);
    i2 = (Time >= utcNow-1/4)&(Time < utcNow-1/24);
    i3 = (Time >= utcNow-1/24);
    scatter(Longitude(i1), Latitude(i1), 75,'markerFaceColor','y','markerEdgeColor','k'),hold on
    scatter(Longitude(i2), Latitude(i2), 75,'markerFaceColor',[1 .68 .2],'markerEdgeColor','k')
    scatter(Longitude(i3), Latitude(i3), 75,'markerFaceColor','r','markerEdgeColor','k')
else
    colorscat(Longitude(ind), Latitude(ind),75, Time(ind), 'timeTickType', 'auto')
end

%% MAKE CSV FILE
lightningStrikes2CSV(STK,[dr,'\CSV\',V,'-',Range,'.csv']);

%% PLOT COAST LINES
for n=1:numel(COAST)
    plot(COAST(n).lon,COAST(n).lat,'k')
end

%% ADJUST AXES (200km by 200km)
grid on
lon = L.(R).(V).Longitude;
lon(lon>0) = lon(lon>0)-360; % in case west of dateline
lat = L.(R).(V).Latitude;
lat_deg = 100/110.54;
lon_deg = 100/(111.320*cosd(lat));
ylim([lat-lat_deg, lat+lat_deg])
xlim([lon-lon_deg, lon+lon_deg])

%% MAKE TITLE
line1 = [V,' Volcano: Last Check at ', datestr(utcNow), ' UTC'];
if emptyPlot
    line2 = ['No Lighting Strikes Detected in the Last ',Range];
else
    az_num = [0 45 90 135 180 225 270 315 360];
    az_str = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'};
    [v i] = min(abs(az_num-Azimuth(1)));
    line2 = ['Last Lightning Strike at ',datestr(Time(1)),' UTC , ',...
        num2str(Distance(1),'%0.1f'),' km ',az_str{i},' of Volcano'];
end
title({line1;line2})

%% FINISH
switch(lower(Range))
    case 'day'
        set(gcf,'Position',[1 1 711 700])
    otherwise
        set(gcf,'Position',[1 1 800 700])
end
if emptyPlot, set(gcf,'Position',[1 1 711 700]), end
export_fig([dr,'\Plots\',V,'-',Range],'-png')

