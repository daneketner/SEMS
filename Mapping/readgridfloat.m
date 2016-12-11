function [M, lat, lon] = readgridfloat(dir,lat_top,lon_left)

olddir = cd;
if lat_top >= 0
    ff = ['n',num2str(lat_top)];
else
    ff = ['s',num2str(-lat_top)];
end
if lon_left < 0
    ff = [ff,'w',num2str(-lon_left)];
else
    ff = [ff,'e',num2str(lon_left)];
end
d = fullfile(dir,ff);
if exist(d,'dir') == 7
    try
    fid = fopen(fullfile(d,['float',ff,'_2.hdr']));
    ncols = sscanf(fgetl(fid),'ncols%d');               % ncols         1812
    nrows = sscanf(fgetl(fid),'nrows%d');               % nrows         1812
    xllcorner = sscanf(fgetl(fid),'xllcorner%f');       % xllcorner     -174.0033333333
    yllcorner = sscanf(fgetl(fid),'yllcorner%f');       % yllcorner     50.99666666667
    cellsize = sscanf(fgetl(fid),'cellsize%f');         % cellsize      0.000555555555556
    NODATA_value = sscanf(fgetl(fid),'NODATA_value%d'); % NODATA_value  -9999
    byteorder = sscanf(fgetl(fid),'byteorder%s');       % byteorder     LSBFIRST
    fclose(fid);
    lat = linspace(yllcorner, yllcorner+(nrows-1)*cellsize,nrows);
    lon = linspace(xllcorner, xllcorner+(ncols-1)*cellsize,ncols);
    data = fullfile(d,['float',ff,'_2.flt']);
    M = readmtx(data,nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');
    M(M == -9999) = NaN;
    M = M(7:1806,7:1806);
    lat = lat(7:1806);
    lon = lon(7:1806);
    catch
        [M, lat, lon] = empty(lat_top, lon_left);
    end
else
[M, lat, lon] = empty(lat_top, lon_left);
end
cd(olddir)

function [M, lat, lon] = empty(lat_top, lon_left)
cs = 1/1800;
M = zeros(1800);
lat = linspace(lat_top-1,lat_top-cs,1800);
lon = linspace(lon_left,lon_left+1-cs,1800);