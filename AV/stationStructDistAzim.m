%% ANALOG

ST = fieldnames(ANA);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = ANA.(Sta).LatitudeWG84;
    lon1 = ANA.(Sta).LongitudeWG84;
    rxsite = ANA.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_Rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'Rep')
        lat2 = REP.(rxsite).LatitudeWG84;
        lon2 = REP.(rxsite).LongitudeWG84;
    else
        lat2 = ANA.(rxsite).LatitudeWG84;
        lon2 = ANA.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    ANA.(Sta).Azimuth = azim;
    ANA.(Sta).DistanceMiles = dist;
end
clear ST Sta azim dist lat1 lat2 lon1 lon2 n rxsite

%% DIGITAL

ST = fieldnames(DIG);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = DIG.(Sta).LatitudeWG84;
    lon1 = DIG.(Sta).LongitudeWG84;
    rxsite = DIG.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_Rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'Rep')
        lat2 = REP.(rxsite).LatitudeWG84;
        lon2 = REP.(rxsite).LongitudeWG84;
    else
        lat2 = DIG.(rxsite).LatitudeWG84;
        lon2 = DIG.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    DIG.(Sta).Azimuth = azim;
    DIG.(Sta).DistanceMiles = dist;
end
clear ST Sta azim dist lat1 lat2 lon1 lon2 n rxsite

