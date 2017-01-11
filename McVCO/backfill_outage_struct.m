function M = backfill_outage_struct(M,nhours)

%% Source
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);

%%
t1 = M.TimeVector(end)-ceil(nhours)/24;
t2 = M.TimeVector(end);
LT = length(M.TimeVector);
ind = LT-ceil(nhours) : LT;

%%
subnets = fieldnames(M.Outage);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.Outage.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.Outage.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.Outage.(SU).(ST).(CH);
            scnl = scnlobject(ST,CH,'AV',[]);
            for kk = ind
                w = get_w(ds,scnl,M.TimeVector(kk),M.TimeVector(kk)+1/24);
                if isempty(w)
                    X(kk) = 0;
                else
                    f = get(w,'freq');
                    w = zero2nan(w,5);
                    d = get(w,'data');
                    X(kk) = single((numel(d)-sum(isnan(d)))/(60*60*f));
                    fprintf([SU,' - ',ST,':',CH,' - ',datestr(M.TimeVector(kk)),...
                ' - ',num2str(X(kk)*100),' %%\n'])
                end
            end
            M.Outage.(SU).(ST).(CH) = X;
        end
    end
end


%% Script for looping through all channels in structure M
% subnets = fieldnames(M.Outage);
% for n = 1:numel(subnets)
%     SU = subnets{n};
%     stations = fieldnames(M.Outage.(SU));
%     for m = 1:numel(stations)
%         ST = stations{m};
%         channels = fieldnames(M.Outage.(SU).(ST));
%         for k = 1:numel(channels)
%             CH = channels{k};
%             
%             YOUR CODE HERE
%
%         end
%     end
% end