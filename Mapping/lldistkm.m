function dkm=lldistkm(lat1,lon1,lat2,lon2)

if numel(lat1) ~= numel(lon1) || numel(lat2) ~= numel(lon2)
error('lldistkm: bad input dimensions')
end
n1 = numel(lat1);
n2 = numel(lat2);
radius=6371;
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
dkm=radius*c;    
