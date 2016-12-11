function M = add_outage_chan(M,SU,ST,CH,start)

if ischar(SU) 
    SUn = 1; SU = {SU};
elseif iscell(SU)
    SUn = length(SU);
end

if ischar(ST) 
    STn = 1; ST = {ST};
elseif iscell(ST)
    STn = length(ST);
end

if ischar(CH)
    CHn = 1; CH = {CH};
elseif iscell(CH)
    CHn = length(CH);
end

if (SUn == STn) && (STn == CHn)
    for n = 1:SUn
        M = add_chan(M,SU{n},ST{n},CH{n},start);
    end
else
    for n = 1:SUn
        for m = 1:STn
            for k = 1:CHn
                M = add_chan(M,SU{n},ST{m},CH{k},start);
            end
        end
    end
end

%%
function M = add_chan(M,SU,ST,CH,start)

warning('off','all')
X = [];
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);
scnl = scnlobject(ST,CH,'AV',[]);
start = chk_t('num',start);
[val ref] = min(abs(M.TimeVector-start));
for tt = ref:numel(M.TimeVector)
    w = get_w(ds,scnl,M.TimeVector(tt),M.TimeVector(tt)+1/24);
    if isempty(w)
        X(tt,1) = 0;
    else
        f = get(w,'freq');
        w = zero2nan(w,5);
        d = get(w,'data');
        X(tt) = single((numel(d)-sum(isnan(d)))/(60*60*f));
    end
    fprintf([SU,' - ',ST,':',CH,' - ',datestr(M.TimeVector(kk),...
         'dd-mmm-yyyy HH:MM:SS'),' - ',sprintf('%3.0f',X(tt)*100),' %%\n'])
end
M.Outage.(SU).(ST).(CH) = X;
warning('on','all')
