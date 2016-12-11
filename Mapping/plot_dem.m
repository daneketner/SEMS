function varargout = plot_dem(lat,lon,cmap)

DEM = getdem(lat, lon);
DEM(DEM<=0) = 0;
y = linspace(lat(1),lat(2),size(DEM,1));
x = linspace(lon(1),lon(2),size(DEM,2));
DMax = max(max(DEM));
DMin = min(min(DEM));
clow = floor(DMin/50);
chigh = floor(DMax/50);
lines = (clow:chigh)*50+.1;
csub = (clow:chigh)+1;
colormap(cmap(csub,:))
ax = gca;
hold on
contourf(x,y,DEM,lines(1:end))
set(ax,'Color',[.6 .75 1])
grid on
xlim(lon)
ylim(lat)
if nargout == 1
    varargout{1} = DEM;
elseif nargout == 3
     varargout{1} = DEM;
     varargout{2} = x;
     varargout{3} = y;
end
