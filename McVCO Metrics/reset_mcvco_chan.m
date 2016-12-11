function [M, W] = reset_mcvco_chan(M,SU,ST,CH,id,gain,lastcheck)

host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);

W = [];
X = M.(SU).(ST).(CH);
X.bvl = [];
X.start = [];
X.id = [];
X.gain = [];
X.real_id = id;
X.real_gain = gain;
X.lastcheck = lastcheck;
scnl = scnlobject(ST,CH,'AV',[]);
[X, W] = update(X,W,ds,scnl);
M.(SU).(ST).(CH) = X;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X,W] = update(X,W,ds,scnl)

if ~isempty(X.start)
lastfind = max(X.start);
else
    lastfind = datenum([2012 8 1 0 0 0]);
end
gapcnt = X.lastcheck - lastfind;
if gapcnt < 7
    t = lastfind + .5;
else
    t = ceil(X.lastcheck);
end

while t < now
    mnt = 1/24/60;
    if gapcnt < 7
        w = get_w(ds,scnl,t-mnt,t+2*mnt);
    elseif gapcnt >= 7
        w = get_w(ds,scnl,t,t+.5);
    end
    pause(.01)
    
    try
        [start, bvl, id, gain, off, amp, wave] = ...
            decode_mcvco(w,'start','bvl','id','gain','off','amp','wave');
    catch
        start = NaN;
    end
    
    if ~isnan(start)
        gapcnt = 0;
        X.start = [start; X.start];
        X.bvl = [bvl; X.bvl];
        X.id = [id; X.id];
        X.gain = [gain; X.gain];
        X.off = [off; X.off];
        X.ramp = [amp; X.ramp];
        W = [W, wave];
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
            get(scnl,'channel'),' - McVCO Signal Found'])
        t = start;
    else
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
            get(scnl,'channel'),' - McVCO Signal Not Found'])
    end
    
    if gapcnt < 7
        X.lastcheck = t;
        t = t+.5;
        gapcnt = gapcnt + .5;
    elseif gapcnt >= 7
        X.lastcheck = t;
        t = t + .5;
        gapcnt = gapcnt + .5;
    end
end
[A B] = sort(X.start,'descend');
X.start = X.start(B);
X.bvl   = X.bvl(B);
X.id    = X.id(B);
X.gain  = X.gain(B);