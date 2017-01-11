
fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])
M = check_id(M);
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
            X = rmfield(X,'amp');
            X = rmfield(X,'off');
%             load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
%             WW = check_id(W);
%             for kk = 2012:2016
%                 ref = find(X.start >= datenum([kk 0 0 0 0 0]) &...
%                     X.start <  datenum([kk+1 0 0 0 0 0]));
%                 if ~isempty(ref)
%                     W = WW(ref);
%                     W = addfield(W,'bvl',X.bvl(ref));
%                     W = addfield(W,'id',X.id(ref));
%                     W = addfield(W,'gain',X.gain(ref));
%                     W = addfield(W,'real_id',X.real_id);
%                     W = addfield(W,'real_gain',X.real_gain);
%                     W = addfield(W,'off',[]);
%                     W = addfield(W,'amp',[]);
%                     save([dr,'\WAVEFORMS\',num2str(kk),'\',ST,'_',CH,'.mat'],'W')
%                 end
%             end
            M.(SU).(ST).(CH) = X;
        end
    end
end
