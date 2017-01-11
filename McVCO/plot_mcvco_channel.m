function plot_mcvco_channel(M,metric,SN,t_range,tag,dr)

%% PLOT CHANNEL VOLTAGES
dr2 = [dr,'\HTML\Channel_',metric,'_Plots\'];
stations = fieldnames(M.(SN));
for m = 1:numel(stations)
    ST = stations{m};
    channels = fieldnames(M.(SN).(ST));
    for k = 1:numel(channels)
        CH = channels{k};
        X = M.(SN).(ST).(CH);
        x = find(X.start > t_range(1) & X.start < t_range(2));
        x_txt = t_range(1)+(t_range(2)-t_range(1))*.05;
        
        switch metric
            case 'Voltages'
                if X.real_bvl
                    figure, hold on
                    scatter(X.start(x),X.bvl(x))
                else
                    figure, hold on
                    text(x_txt,14.5,'No Voltage Monitoring','fontsize',16)
                end
            case 'Amplitudes'
                figure, hold on
                scatter(X.start(x),X.amp(x))
            case 'Offsets'
                figure, hold on
                scatter(X.start(x),X.off(x))
            case 'Waveforms'
                load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
                W = check_id_gain(W);
                W = W(x);
                nW = numel(W);
                lim = 15;
                step = ceil(nW/lim);
                plotm2(W(1:step:end))
        end
        
        set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[100 100 1200 400])
        
        switch metric
            case {'Voltages','Amplitudes','Offsets'}
                setxticks(tag)
                xlim(t_range)
            otherwise
        end
        
        switch metric
            case 'Voltages'
                ylim([9 16])
            case 'Waveforms'
        end
        
        grid on
        try
        title([ST,':',CH,'--[',metric,']--(ID: ',num2str(X.real_id),', GAIN: ',...
                       num2str(X.real_gain),')'],'FontSize',16)
        catch
            disp('What went wrong with the title?')
        end
        export_fig([dr2,ST,'-',CH,'-',tag],'-png')
        pause(.1)
        close all
    end
end

function setxticks(tag)

nowvec = datevec(now);
switch tag
    case 'Week'
        ticks = floor(now)-7 : floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case 'Month'
        ticks = floor(now)-30 :2: floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case '3Month'
        ticks = floor(now)-90 :6: floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case 'Year'
        y = floor(nowvec(1)-1 : 1/12 : nowvec(1)+1)';
        m = mod(1:length(y),12)'; m(m==0) = 12;
        d = ones(size(y));
        z = zeros(size(y));
        ticks = datenum([y,m,d,z,z,z]);
        ticklab = datestr(ticks,'mmm');

    case 'All'
        y = floor(2012 : .25 : nowvec(1)+1)';
        m = mod(1:3:length(y)*3,12)'; m(m==0) = 12;
        d = ones(size(y));
        z = zeros(size(y));
        ticks = datenum([y,m,d,z,z,z]);
        ticklab = datestr(ticks,'mmm-yyyy');
end
set(gca,'XTick',ticks,'XTickLabel',ticklab)
pause(.1)











