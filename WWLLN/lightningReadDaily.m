function lightningReadDaily

dir =  'C:\AVO\Github\SEMS\WWLLN';
cd(dir)
load 'MASTER.mat'; % 'L'

try
    url = 'http://flash3.ess.washington.edu/USGS/AVO/';
    cd([dir,'\KML'])
    raw = urlread(url);
    HTMLScanComplete = 0;
    t1 = findstr(raw, '<td>');
    t2 = findstr(raw, '</td>');
    ind = 0;
    while ~HTMLScanComplete
        try
            %KML File
            K = [raw((t1(ind+1)+4):(t2(ind+1)-1)),'.kml'];
            
            %Volcano
            V = fixName(raw((t1(ind+2)+4):(t2(ind+2)-1)));

            %Region
            R = fixName(raw((t1(ind+3)+4):(t2(ind+3)-1)));
            
            %Lightning Strikes
            S20 = str2num(raw((t1(ind+7)+4):(t2(ind+7)-1)));
            S100 = str2num(raw((t1(ind+8)+4):(t2(ind+8)-1)));
            
            if (S20>0)||(S100>0)
                urlwrite([url,K],[K]);
                kml = fileread(K);
                disp(K)
                l1 = findstr(kml, '<li>');
                l2 = findstr(kml, '</li>');
                n2 = findstr(kml, 'Z</name>');
                for n = 1:numel(l1)/4
                    timestamp = kml(n2(n)-19:n2(n)-1);
                    disp([R,' ',V,' ',timestamp])
                    time = datenum(strrep(timestamp,'T',' '));
                    L.(R).(V).Strikes.Time = [time; L.(R).(V).Strikes.Time];
                    lat = str2num(kml((l1(n*4-3)+8):(l2(n*4-3)-1)));
                    L.(R).(V).Strikes.Latitude = [lat; L.(R).(V).Strikes.Latitude];
                    lon = str2num(kml((l1(n*4-2)+8):(l2(n*4-2)-1)));
                    L.(R).(V).Strikes.Longitude = [lon; L.(R).(V).Strikes.Longitude];
                end
                %
                L = uniqueStrikes(L,R,V);
                ind = ind+9;
            else
                HTMLScanComplete = 1;
                cd(dir)
                save([dir,'\MASTER.mat'],'L')
            end
        catch
        end
    end
catch
end
end

function X = fixName(X)
X = strrep(X, '-', '_');
X = strrep(X, ' ', '_');
X = strrep(X, '.', '');
end

function L = uniqueStrikes(L,R,V)
[lat_val, lat_ind] = unique(L.(R).(V).Strikes.Latitude);
[lon_val, lon_ind] = unique(L.(R).(V).Strikes.Longitude);
[t_val, t_ind] = unique(L.(R).(V).Strikes.Time);
U_ind = sort(unique([lat_ind; lon_ind; t_ind]));
L.(R).(V).Strikes.Latitude = L.(R).(V).Strikes.Latitude(U_ind);
L.(R).(V).Strikes.Longitude = L.(R).(V).Strikes.Longitude(U_ind);
L.(R).(V).Strikes.Time = L.(R).(V).Strikes.Time(U_ind);
end
