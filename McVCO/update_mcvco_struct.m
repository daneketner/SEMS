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
            lastCheckVec = datevec(X.lastcheck);
            lastCheckYear = lastCheckVec(1);
            scnl = scnlobject(ST,CH,'AV',[]);
            try
                load([dr,'\WAVEFORMS\',num2str(lastCheckYear),'\',ST,'_',CH,'.mat'])
            catch
                W = [];
            end
            [X,W] = update(X,W,ds,scnl);
            M.(SU).(ST).(CH) = X;
            save([dr,'\Master.mat'],'M')
            date = get(W,'start'); year = datevec(date); year = year(:,1);
            years = unique(year);
            for p = 1:numel(years)
                WW = W(year == years(p));
                save([dr,'\WAVEFORMS\',num2str(years(p)),'\',ST,'_',CH,'.mat'],'W')
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
    t = floor(X.lastcheck);
end

while t < now-.5
    if gapcnt < 3
        w = get_w(ds,scnl,t-1/1440,t+1/720);
    elseif gapcnt >= 3
        w = get_w(ds,scnl,t,t+.5+1/1440);
    end
    X.lastcheck = t;
    pause(.01)
    correct_id = 0;
    endofwave = 0;
    while ~correct_id && ~endofwave
        try
        [start, bvl, id, gain, wave] = ...
            decode_mcvco(w,'start','bvl','id','gain','wave');
        catch
            start = NaN; 
        end
        if isnan(start)
            endofwave = 1;
            gapcnt = gapcnt + .5;
            disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                get(scnl,'channel'),' - McVCO Signal Not Found'])
            t = t+.5;
        elseif intersect(id, X.real_id)
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
        else
            if (get(w,'end')-start)>3/1440
                w = extract(w,'time',start+3/1440,get(w,'end'));
            else
                endofwave = 1;
                disp([datestr(t), ' - ', get(scnl,'station'), ':',...
                    get(scnl,'channel'),' - McVCO Signal Not Found'])
                t = t+.5;
            end
        end
    end
end

%% Final Sort
[A B] = sort(X.start,'descend');
X.start = X.start(B);
X.bvl   = X.bvl(B);
X.id    = X.id(B);
X.gain  = X.gain(B);
[A B] = sort(get(W,'start'),'descend');
W = W(B);


