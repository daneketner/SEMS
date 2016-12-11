%% RESET LASTCHECK

% fid = fopen('mcvco_config.txt');
% dr = fgetl(fid);
% load([dr, '\Master.mat'])
% 
% subnets = fieldnames(M);
% for n = 1:numel(subnets)
%     SU = subnets{n};
%     stations = fieldnames(M.(SU));
%     for m = 1:numel(stations)
%         ST = stations{m};
%         channels = fieldnames(M.(SU).(ST));
%         for k = 1:numel(channels)
%             try
%                 CH = channels{k};
%                 M.(SU).(ST).(CH).lastcheck = M.(SU).(ST).(CH).start(1);
%             catch
%                 M.(SU).(ST).(CH).lastcheck = now;
%             end
%         end
%     end
% end

%% LOAD ALL WAVEFORMS AND COMPUTE RESPONSE AMPLITUDE

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])

subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            try
                load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
                Fs = get(W(1),'freq');
                W = W(end:-1:1);
                fprintf([SU,':',ST,':',CH,': ',num2str(numel(W)),' waveforms'])
                fprintf('\n')
                for kk = 1:length(W)
                    try
                        % pre = median(extract(wave,'INDEX',t2,t2+Fs));
                        % resp = extract(wave,'INDEX',t2+.75*Fs,t2+2.25*Fs);
                        % close all
                        pre = extract(W(kk), 'INDEX', 12.25*Fs, 13.25*Fs);
                        tone = extract(W(kk), 'INDEX', 13*Fs, 14.5*Fs);
                        % Compute the tone amplitude & store in Master structure
                        val = max(tone)- median(pre);
                        % plot(tone), hold on, plot(pre), title(num2str(val))
                        M.(SU).(ST).(CH).amp(kk) = val;
                        %M.(SU).(ST).(CH).off(kk) = mean(tone) - mean(pre);
                    catch
                    end
                end
            catch
                fprintf([SU,':',ST,':',CH,': 0 waveforms'])
                fprintf('\n')
            end
        end
    end
end

%% LOAD ALL WAVEFORMS AND RE-COMPUTE TONE AMPLITUDE

% fid = fopen('mcvco_config.txt');
% dr = fgetl(fid);
% load([dr, '\Master.mat'])
% 
% subnets = fieldnames(M);
% for n = 1:numel(subnets)
%     SU = subnets{n};
%     stations = fieldnames(M.(SU));
%     for m = 1:numel(stations)
%         ST = stations{m};
%         channels = fieldnames(M.(SU).(ST));
%         for k = 1:numel(channels)
%             CH = channels{k};
%             try
%                 load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
%                 Fs = get(W(1),'freq');
%                 W = W(end:-1:1);
%                 fprintf([SU,':',ST,':',CH,': ',num2str(numel(W)),' waveforms'])
%                 fprintf('\n')
%                 for kk = 1:length(W)
%                     % Extract a 1.8 second sample of waveform before tone
%                     % pre = extract(W(kk), 'INDEX', 1, 1.8*Fs);
%                     % Extract a 6 second sample of the tone waveform
%                     tone = extract(W(kk), 'INDEX', 4*Fs, 10*Fs);
%                     % Compute the tone amplitude & store in Master structure
%                     M.(SU).(ST).(CH).amp(kk) = max(abs(demean(tone)));
%                     %M.(SU).(ST).(CH).off(kk) = mean(tone) - mean(pre);
%                 end
%             catch
%                 fprintf([SU,':',ST,':',CH,': 0 waveforms'])
%                 fprintf('\n')
%             end
%         end
%     end
% end

%% LOAD ALL WAVEFORMS AND ADD STRUCTURE FIELDS TO WAVEFORM OBJECTS

% fid = fopen('mcvco_config.txt');
% dr = fgetl(fid);
% load([dr, '\Master.mat'])
% 
% subnets = fieldnames(M);
% for n = 1:numel(subnets)
%     SU = subnets{n};
%     stations = fieldnames(M.(SU));
%     for m = 1:numel(stations)
%         ST = stations{m};
%         channels = fieldnames(M.(SU).(ST));
%         for k = 1:numel(channels)
%             try
%             CH = channels{k};
%             X = M.(SU).(ST).(CH);
%             load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
%             W = addfield(W,'bvl',X.bvl);
%             W = addfield(W,'id',X.id);
%             W = addfield(W,'gain',X.gain);
%             W = addfield(W,'real_id',X.real_id);
%             W = addfield(W,'real_gain',X.real_gain);
%             W = addfield(W,'real_bvl',X.real_bvl);
%             W = addfield(W,'off',X.off);
%             W = addfield(W,'amp',X.amp);
%             save([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'],'W')
%             catch
%             end
%             clear W
%             fprintf([SU,':',ST,':',CH])
%             fprintf('\n')
%         end
%     end
% end