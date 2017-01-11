function mcvco_xls_report(M,varargin)

y1 = 2012;
y2 = 2016;

R1 = [];
R2 = [];
R3 = [];
R4 = [];
P = [];
cnt = 0;
subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            R1{end+1,1} = SU;
            R2{end+1,1} = [ST,':',CH];
            X = M.(SU).(ST).(CH);
            R3(end+1,1) = X.real_id(1);
            R4(end+1,1) = X.real_gain(1);
            cnt = cnt + 1;
            for year = y1:y2
                kk = year - y1 + 1;
                t1 = datenum([year 1 1 0 0 0]);
                t2 = datenum([year 12 31 23 59 59]);
                if year == 2012
                    t1 = datenum([2012 8 19 0 0 0]);
                elseif year == 2016
                    t2 = now - 1;
                end
                tt = X.start((X.start > t1) & (X.start < t2));
                dd = unique(floor(tt));
                P(cnt, kk) = numel(dd)/(t2-t1);
            end
        end
    end
end


cd 'C:\AVO\McVCO_Metrics'
filename = 'mcvco_report.xls';
xlswrite(filename,R1,1,'A1')
xlswrite(filename,R2,1,'B1')
xlswrite(filename,R3,1,'C1')
xlswrite(filename,R4,1,'D1')
xlswrite(filename,P(:,1),1,'E1')
xlswrite(filename,P(:,2),1,'F1')
xlswrite(filename,P(:,3),1,'G1')
xlswrite(filename,P(:,4),1,'H1')
xlswrite(filename,P(:,5),1,'I1')
