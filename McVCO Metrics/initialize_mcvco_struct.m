function M = initialize_mcvco_struct(M,dir)

cd dir

host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,16023);

subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.(SU).(ST).(CH);
            scnl = scnlobject(ST,CH,'AV',[]);
            X = backfill(X,ds,scnl);
            M.(SU).(ST).(CH) = X;
            cd dir
            save('Master.mat','M')
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = backfill(X,ds,scnl)
X.start = [];
X.bvl = [];
X.id = [];
X.gain = [];

if size(X.bvl,2) > 1
    X.bvl = X.bvl';
end
if size(X.id,2) > 1
    X.id = X.id';
end
if size(X.bvl,2) > 1
    X.gain = X.gain';
end

t = floor(now)-.5;
gapcnt = inf;

while t > datenum([2012 6 1 0 0 0])
    if gapcnt < 7
        mnt = 1/24/60;
        w = get_w(ds,scnl,t-mnt,t+2*mnt);
    else
        pause(3)
        w = get_w(ds,scnl,t,t+.5);
        pause(1)
    end
    
    try
    [start bvl id gain] = decode_mcvco(w,'start','bvl','id','gain');
    catch
        sst = NaN;
    end
    
    if ~isnan(sst(1))
        X.start = [X.start; start];
        X.bvl = [X.bvl; bvl];
        X.id = [X.id; id];
        X.gain = [X.gain; gain];
        if gapcnt > 7
            X = forwardfill(X,start,ds,scnl);
        end
        t = sst(1)-.5;
        gapcnt = .5;
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                              get(scnl,'channel'),' - McVCO Signal Found'])
    else
        if gapcnt < 7
            t = t-.5;
            gapcnt = gapcnt+.5;
        else
            t = t-7;
            gapcnt = gapcnt+7;
        end
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                          get(scnl,'channel'),' - McVCO Signal Not Found'])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = forwardfill(X,t,ds,scnl)
gapcnt = 0;
while gapcnt < 7
    t = t+.5;
    gapcnt = gapcnt + .5;
    mnt = 1/24/60;
    w = get_w(ds,scnl,t-mnt,t+2*mnt);
    try
    [start bvl id gain] = decode_mcvco(w,'start','bvl','id','gain');
    catch
        sst = NaN;
    end
    if ~isnan(sst(1))
        gapcnt = 0;
        X.start = [X.start; start];
        X.bvl = [X.bvl; bvl];
        X.id = [X.id; id];
        X.gain = [X.gain; gain];
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                              get(scnl,'channel'),' - McVCO Signal Found'])
    else
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                          get(scnl,'channel'),' - McVCO Signal Not Found'])
    end
    t = t+.5;
    gapcnt = gapcnt + .5;
end
[A B] = sort(X.start,'descend');
X.start = X.start(B);
X.bvl   = X.bvl(B);
X.id    = X.id(B);
X.gain  = X.gain(B);
