function [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,dunits)

if numel(lat1) ~= numel(lon1) || numel(lat2) ~= numel(lon2)
error('latlon2dist: bad input dimensions')
end
n1 = numel(lat1);
n2 = numel(lat2);
switch lower(dunits)
    case{'k','km','kilometer','kilometers'}
        radius=6371;
    case{'m','mi','mile','miles'}
        radius=3959;
end
lat1 = reshape(lat1,1,n1)*pi/180;
lat2 = reshape(lat2,1,n2)*pi/180;
[LAT1, LAT2] = meshgrid(lat1, lat2);
lon1 = reshape(lon1,1,n1)*pi/180;
lon2 = reshape(lon2,1,n2)*pi/180;
[LON1, LON2] = meshgrid(lon1, lon2);
deltaLat=LAT2-LAT1;
deltaLon=LON2-LON1;

%Haversine distance
a = sin(deltaLat/2).^2 + cos(LAT1).*cos(LAT2).*sin(deltaLon/2).^2;
c = 2*atan2(sqrt(a),sqrt(1-a));
dist = radius*c;    
azim = atan2(sin(deltaLon).*cos(LAT2), cos(LAT1).*sin(LAT2)-...
                                       sin(LAT1).*cos(LAT2).*cos(deltaLon));
azim = azim*180/pi;

