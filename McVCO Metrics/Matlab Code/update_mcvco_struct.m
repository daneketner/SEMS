function M = update_mcvco_struct(M,dr)

%% Source
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,16023);

%%
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
            try
                load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
            catch
                W = waveform;
            end
            try
            [X,W] = update(X,W,ds,scnl);
            M.(SU).(ST).(CH) = X;
            save([dr,'\Master.mat'],'M')
            save([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'],'W')
            catch
            end
        end
    end
end

%%
function [X,W] = update(X,W,ds,scnl)

lastfind = max(X.start);
gapcnt = X.lastcheck - lastfind;
if gapcnt < 3
    t = lastfind + .5;
else
    t = ceil(X.lastcheck);
end

while t < now-.5
    mnt = 1/24/60;
    if gapcnt < 3
        w = get_w(ds,scnl,t-mnt,t+2*mnt);
    elseif gapcnt >= 3
        w = get_w(ds,scnl,t,t+.5);
    end
    X.lastcheck = t;
    pause(.01)
    correct_id = 0;
    endofwave = 0;
    while ~correct_id && ~endofwave
        [start, bvl, id, gain, wave] = ...
            decode_mcvco(w,'start','bvl','id','gain','wave');
        if isnan(start)
            endofwave = 1;
            gapcnt = gapcnt + .5;
            disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                get(scnl,'channel'),' - McVCO Signal Not Found'])
            t = t+.5;
        elseif ~isnan(start) && ~isempty(intersect(id, X.real_id))
            correct_id = 1;
            gapcnt = 0;
            X.start = [start; X.start];
            X.bvl = [bvl; X.bvl];
            X.id = [id; X.id];
            X.gain = [gain; X.gain];
            W = [wave, W];
            disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                get(scnl,'channel'),' - McVCO Signal Found'])
            t = start+.5;
        end
    end
end

%% Final Sort
[A B] = sort(X.start,'descend');
X.start = X.start(B);
X.bvl   = X.bvl(B);
X.id    = X.id(B);
X.gain  = X.gain(B);
W = W(B);
W = addfield(W,'bvl',X.bvl);
W = addfield(W,'id',X.id);
W = addfield(W,'gain',X.gain);
W = addfield(W,'real_id',X.real_id);
W = addfield(W,'real_gain',X.real_gain);

