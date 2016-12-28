function plotLightning(R,V,Range)

%%
dir =  'C:\AVO\Github\SEMS\WWLLN';
cd(dir)
load 'master.mat'
load 'COAST.mat'
R = 'Aleutian_Is';
V = 'Bogoslof';
figure
hold on
set(gcf,'Color',[1 1 1])
STK = L.(R).(V).Strikes;
switch(lower(Range))
    case 'all' % Plot everything
        colorscat(STK.Longitude, STK.Latitude, ones(size(STK.Latitude))*75,... 
            STK.Time, 'timeTickType', 'auto')
    case 'year'
        ind =  STK.Time > now-365;
        colorscat(STK.Longitude(ind), STK.Latitude(ind),...
        ones(size(STK.Latitude(ind)))*75, STK.Time(ind), 'timeTickType', 'auto')
    case 'month'
        ind =  STK.Time > now-30;
        colorscat(STK.Longitude(ind), STK.Latitude(ind),...
        ones(size(STK.Latitude(ind)))*75, STK.Time(ind), 'timeTickType', 'auto')
    case 'week'
        ind =  STK.Time > now-7;
        colorscat(STK.Longitude(ind), STK.Latitude(ind),...
        ones(size(STK.Latitude(ind)))*75, STK.Time(ind), 'timeTickType', 'auto')
    case 'day'
        ind =  STK.Time > now-1;
        colorscat(STK.Longitude(ind), STK.Latitude(ind),...
        ones(size(STK.Latitude(ind)))*75, STK.Time(ind), 'timeTickType', 'auto')
    otherwise
end
for n=1:numel(COAST)
    plot(COAST(n).lon,COAST(n).lat,'k')
end
grid on

x = L.(R).(V).Longitude;
y = L.(R).(V).Latitude;
[y, x] = llboxkm(y, x, 100);
x(x>0) = x(x>0)-360;
title([V,': Last strike at ', datestr(max(STK.Time)-8/24),' AKDT'])
xlim(x)
ylim(y)



