function M = add_new_channel(M,SU,ST,CH,start)

%% DATA SOURCE
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);
scnl = scnlobject(ST,CH,'AV',[]);
tv = M.TimeVector;
L = length(tv);
[val, ind] = min(abs(tv-start));
warning('off')
X = zeros(L,1);
for t = ind:L
    w = get_w(ds,scnl,tv(t),tv(t)+1/24);
    if isempty(w)
        X(t) = 0;      
    else
        f = get(w,'freq');
        w = zero2nan(w,5);
        d = get(w,'data');
        X(t) = single((numel(d)-sum(isnan(d)))/(60*60*f));
    end
    fprintf([SU,' - ',ST,':',CH,' - ',datestr(tv(t),...
        'dd-mmm-yyyy HH:MM:SS'),' - ',sprintf('%3.0f',X(t)*100),' %%\n'])
end
M.Outage.(SU).(ST).(CH) = X;
warning('on')
