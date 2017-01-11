function L = lightningReadDaily(dr,L)

try
url = 'http://flash3.ess.washington.edu/USGS/AVO/';
cd([dr,'\KML'])
raw = urlread(url);
HTMLScanComplete = 0;
t1 = findstr(raw, '<td>');
t2 = findstr(raw, '</td>');
ind = 0;
while ~HTMLScanComplete
    K = [raw((t1(ind+1)+4):(t2(ind+1)-1)),'.kml'];   % KML File
    V = fixName(raw((t1(ind+2)+4):(t2(ind+2)-1)));   % Volcano
    R = fixName(raw((t1(ind+3)+4):(t2(ind+3)-1)));   % Region
    S20 = str2num(raw((t1(ind+7)+4):(t2(ind+7)-1))); % Lightning Strikes
    S100 = str2num(raw((t1(ind+8)+4):(t2(ind+8)-1)));

    if (S20>0)||(S100>0)
        urlwrite([url,K],K);
        kml = fileread(K);
        disp(K)
        l1 = findstr(kml, '<li>');
        l2 = findstr(kml, '</li>');
        n2 = findstr(kml, 'Z</name>');
        for n = 1:numel(l1)/4
            timestamp = kml(n2(n)-19:n2(n)-1);
            disp([R,' ',V,' ',timestamp])
            time = datenum(strrep(timestamp,'T',' '));
            lat = str2num(kml((l1(n*4-3)+8):(l2(n*4-3)-1)));
            lon = str2num(kml((l1(n*4-2)+8):(l2(n*4-2)-1)));
            Volc_Lat = L.(R).(V).Latitude;
            Volc_Lon = L.(R).(V).Longitude;
            [azim, dist] = latLon2AzimDist(Volc_Lat,Volc_Lon,lat,lon,'km');
            L.(R).(V).Strikes = [time, lat, lon, azim, dist; L.(R).(V).Strikes];
        end
        %
        L.(R).(V).Strikes = unique(L.(R).(V).Strikes, 'rows');
        [tmp sortInd] = sort(L.(R).(V).Strikes(:,1),'descend');
        L.(R).(V).Strikes = L.(R).(V).Strikes(sortInd,:);
    else
        HTMLScanComplete = 1;
        cd(dr)
        save([dr,'\MASTER.mat'],'L')
    end    % END IF
end     % END While
catch   % CATCH Outer Try
end     % END Outer Try
end     % END Main Function 

function X = fixName(X)
X = strrep(X, '-', '_');
X = strrep(X, ' ', '_');
X = strrep(X, '.', '');
end

