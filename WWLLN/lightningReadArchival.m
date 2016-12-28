function L = lightningReadArchival

dir =  'C:\AVO\Github\SEMS\WWLLN';
cd(dir)
load 'master.mat';
time1 = datenum([2010 10 26 0 0 0]);
time2 = datenum([2016 12 27 0 0 0]);
for day = time1:time2
    try
    url = ['http://flash3.ess.washington.edu/USGS/AVO/archive/',datestr(day,'YYYYmmDD'),'/'];
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
        V = fixname(raw((t1(ind+2)+4):(t2(ind+2)-1)));
        
        %Region
        R = fixname(raw((t1(ind+3)+4):(t2(ind+3)-1)));
        
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
end

function X = fixname(X)
X = strrep(X, '-', '_');
X = strrep(X, ' ', '_');
X = strrep(X, '.', '');
end