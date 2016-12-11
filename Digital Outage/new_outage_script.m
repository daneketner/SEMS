

%%
cd 'C:\AVO\Dig_Sta_Outage'
load 'Master.mat'
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);
subnets = fieldnames(D);
warning off

for t = 1:numel(T)
    if (t>1) && (rem(t,24) == 0)
        save('Master.mat','D')
        disp(datestr(T(t)))
        close all
        new_outage_plot(D,T)
        pause(5)
    end
    for n = 1:numel(subnets)
        SU = subnets{n};
        stations = fieldnames(D.(SU));
        for m = 1:numel(stations)
            ST = stations{m};
            channels = fieldnames(D.(SU).(ST));
            for k = 1:numel(channels)
                X = D.(SU).(ST).BHZ;
                scnl = scnlobject(ST,'BHZ','AV',[]);
                w = get_w(ds,scnl,T(t),T(t)+5/24/60);
                pause(.01)
                if ~isempty(w)
                    w = zero2nan(w,5);
                    d = get(w,'data');
                    d(isnan(d)) = [];
                    X.percent(t) = numel(d)/(5*60*get(w,'freq'));
                else
                    X.percent(t) = 0;
                end
                D.(SU).(ST).BHZ = X;
            end
        end
    end
end


%%

subnets = fieldnames(D);
t1 = datenum([2012 8 1 0 0 0]);
t2 = datenum([2015 1 1 0 0 0]);
T = (t1:1/24:t2)';

for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        X = D.(SU).(ST).BHZ;
        X.percent = ones(size(T))*NaN;
        try
            X = rmfield(X,'time');
        catch
        end
        D.(SU).(ST).BHZ = X;
    end
end

