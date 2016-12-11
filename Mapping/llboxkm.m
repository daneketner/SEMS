function [LAT, LON] = llboxkm(lat, lon, d)

lat_deg = d/110.54;
lon_deg = d/(111.320*cosd(lat));
LAT = [lat-lat_deg, lat+lat_deg];
LON = [lon-lon_deg, lon+lon_deg];