function M = update_outage_struct(M,varargin)

%% DATA SOURCE
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);

%% NO TIME ARGUMENTS (UPDATE TO PRESENT)
if nargin == 1
    t1 = M.TimeVector(end)+1/24;
    t2 = round(floor(now*24)/24)-1/24;
    
%% TIME ARGUMENTS PROVIDED
elseif nargin==3 && isnumeric(varargin{1}) && isnumeric(varargin{2})
    t1 = varargin{1};
    t2 = varargin{2};
    t1 = floor(t1*24)/24;
    t2 = floor(t2*24)/24;
    if t1 > t2
        temp = t1;
        t1 = t2;
        t2 = temp;
    end
else
    error('update_outage_struct: wrong arguments')
end

pre_t = [];
pre_dat = [];
post_t = [];
post_dat = [];
if (t1 < M.TimeVector(1)) % First Time argument is before TV range
    pre_t = (t1:1/24:(M.TimeVector(1)-1/24))';
    pre_dat = zeros(length(pre_t),1);
    M.TimeVector = [pre_t; M.TimeVector];
end
if (t2 > M.TimeVector(end)) % Second Time argument is after TV range
    post_t = (M.TimeVector(end)+1/24:1/24:t2)';
    post_dat = zeros(length(post_t),1);
    M.TimeVector = [M.TimeVector; post_t];
end
ind1 = find(M.TimeVector == t1);
ind2 = find(M.TimeVector == t2);
ind = [ind1:ind2];

%%
warning('off')
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
            X = [pre_dat; X; post_dat];
            scnl = scnlobject(ST,CH,'AV',[]);
            for kk = ind
                w = get_w(ds,scnl,M.TimeVector(kk),M.TimeVector(kk)+1/24);
                if isempty(w)
                    X(kk) = 0;
                    fprintf([SU,' - ',ST,':',CH,' - ',...
                            datestr(M.TimeVector(kk),...
                            'dd-mmm-yyyy HH:MM:SS'),...
                            ' - ',sprintf('%3.0f',X(kk)*100),' %%\n'])
                else
                    f = get(w,'freq');
                    w = zero2nan(w,5);
                    d = get(w,'data');
                    X(kk) = single((numel(d)-sum(isnan(d)))/(60*60*f));
                    fprintf([SU,' - ',ST,':',CH,' - ',...
                            datestr(M.TimeVector(kk),...
                            'dd-mmm-yyyy HH:MM:SS'),...
                            ' - ',sprintf('%3.0f',X(kk)*100),' %%\n'])
                        
                end
            end
            M.Outage.(SU).(ST).(CH) = X;
        end
    end
    %save([dr,'\Master.mat'],'M')
end
warning('on')

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
%             YOUR CODE
%         end
%     end
% end
