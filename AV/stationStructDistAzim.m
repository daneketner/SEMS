%% ANALOG SEISMIC
X=[]; Y=[];
ST = fieldnames(ANA);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = ANA.(Sta).LatitudeWG84;
    lon1 = ANA.(Sta).LongitudeWG84;
    rxsite = ANA.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'_ar')
        lat2 = ARP.(rxsite).LatitudeWG84;
        lon2 = ARP.(rxsite).LongitudeWG84;
    else
        lat2 = ANA.(rxsite).LatitudeWG84;
        lon2 = ANA.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    ANA.(Sta).Azimuth = azim;
    ANA.(Sta).DistanceMiles = dist;
    X(n,1) = azim;
    X(n,2) = dist;
end
clear Sta azim dist lat1 lat2 lon1 lon2 n rxsite

%% DIGITAL SEISMIC

ST = fieldnames(DIG);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = DIG.(Sta).LatitudeWG84;
    lon1 = DIG.(Sta).LongitudeWG84;
    rxsite = DIG.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'_dr')
        lat2 = DRP.(rxsite).LatitudeWG84;
        lon2 = DRP.(rxsite).LongitudeWG84;
    else
        lat2 = DIG.(rxsite).LatitudeWG84;
        lon2 = DIG.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    DIG.(Sta).Azimuth = azim;
    DIG.(Sta).DistanceMiles = dist;
    X(n,1) = azim;
    X(n,2) = dist;    
end
clear Sta azim dist lat1 lat2 lon1 lon2 n rxsite

%% ANALOG REPEATERS
X=[]; Y=[];
ST = fieldnames(ARP);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = ARP.(Sta).LatitudeWG84;
    lon1 = ARP.(Sta).LongitudeWG84;
    rxsite = ARP.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'_ar')
        lat2 = ARP.(rxsite).LatitudeWG84;
        lon2 = ARP.(rxsite).LongitudeWG84;
    else
        lat2 = ANA.(rxsite).LatitudeWG84;
        lon2 = ANA.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    ARP.(Sta).Azimuth = azim;
    ARP.(Sta).DistanceMiles = dist;
    X(n,1) = azim;
    X(n,2) = dist;
end
clear Sta azim dist lat1 lat2 lon1 lon2 n rxsite

%% DIGITAL REPEATERS

ST = fieldnames(DRP);
for n = 1:numel(ST)
    Sta = ST{n};
    lat1 = DRP.(Sta).LatitudeWG84;
    lon1 = DRP.(Sta).LongitudeWG84;
    rxsite = DRP.(Sta).RxSiteCode;
    if strcmp(rxsite(end-2:end),'_rx')
        lat2 = RX.(rxsite).LatitudeWG84;
        lon2 = RX.(rxsite).LongitudeWG84;
    elseif strcmp(rxsite(end-2:end),'_dr')
        lat2 = DRP.(rxsite).LatitudeWG84;
        lon2 = DRP.(rxsite).LongitudeWG84;
    else
        lat2 = DIG.(rxsite).LatitudeWG84;
        lon2 = DIG.(rxsite).LongitudeWG84;
    end
    [azim, dist] = latLon2AzimDist(lat1,lon1,lat2,lon2,'miles');
    DRP.(Sta).Azimuth = azim;
    DRP.(Sta).DistanceMiles = dist;
    X(n,1) = azim;
    X(n,2) = dist;    
end
clear Sta azim dist lat1 lat2 lon1 lon2 n rxsite
