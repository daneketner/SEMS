function mcvco_xls_report(M)

D = M.Outage;
T = M.TimeVector;

y1 = 2012;
y2 = 2016;
Row1 = [];
Row2 = [];
for k = 1:y2-y1+1
    RowOutage{k} = [];
end
subnets = fieldnames(D);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(D.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            Row1{end+1,1} = SU;
            Row2{end+1,1} = [ST,':',CH];
            X = D.(SU).(ST).(CH);
            S = M.Start.(SU).(ST);
            for year = y1:y2
               kk = year - y1 + 1; 
               t1 = datenum([year 1 1 0 0 0]);
               t2 = datenum([year 12 31 23 59 59]); 
               if S > t2
                   RowOutage{kk}(end+1,1) = 0;
               elseif (S > t1) && (S < t2)
                   t1 = S;
                   ref = (T>=t1 & T<=t2);
                   RowOutage{kk}(end+1,1) = mean(X(ref));
               else
                   ref = (T>=t1 & T<=t2);
                   RowOutage{kk}(end+1,1) = mean(X(ref));
               end
            end
        end
    end
end

cd 'C:\AVO\Station_Outage'
filename = 'outage_report.xls';
xlswrite(filename,Row1,1,'A1')
xlswrite(filename,Row2,1,'B1')
for n = 1:length(RowOutage)
    xlswrite(filename,RowOutage{n},1,[char('B'+n),'1'])
end
