%% Make Distance & Azimuth

regions = fieldnames(L);
for n = 1:numel(regions)
    RG = regions{n};
    volcanoes = fieldnames(L.(RG));
    for m = 1:numel(volcanoes)
        VO = volcanoes{m};
        Volc_Lat = L.(RG).(VO).Latitude;
        Volc_Lon = L.(RG).(VO).Longitude;
        Lat = L.(RG).(VO).Strikes.Latitude;
        Lon = L.(RG).(VO).Strikes.Longitude;
        [azim, dist] = latLon2AzimDist(Volc_Lat,Volc_Lon,Lat,Lon,'km');
        L.(RG).(VO).Strikes.Azimuth = azim;
        L.(RG).(VO).Strikes.Distance = dist;
    end
end

%% Sort Strikes by Time

regions = fieldnames(L);
for n = 1:numel(regions)
    R = regions{n};
    volcanoes = fieldnames(L.(R));
    for m = 1:numel(volcanoes)
        V = volcanoes{m};
        STK = L.(R).(V).Strikes;
        [val ind] = sort(STK.Time,'descend');
        STK.Latitude = STK.Latitude(ind);
        STK.Longitude = STK.Longitude(ind);
        STK.Time = STK.Time(ind);
        STK.Distance = STK.Distance(ind);
        STK.Azimuth = STK.Azimuth(ind);
        L.(R).(V).Strikes = STK;
    end
end

%% Move from structure organization of strike data to matrix
regions = fieldnames(L);
for n = 1:numel(regions)
    R = regions{n};
    volcanoes = fieldnames(L.(R));
    for m = 1:numel(volcanoes)
        V = volcanoes{m};
        STK = L.(R).(V).Strikes;
        L.(R).(V).Strikes = [STK.Time, STK.Latitude, STK.Longitude, STK.Azimuth, STK.Distance;];
    end
end

