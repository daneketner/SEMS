function plot_mcvco_network(M,type,SN,t_rng,tag,dr)

C = 0;
WW = [];
figure, hold on

stations = fieldnames(M.(SN));
for m = 1:numel(stations)
    ST = stations{m};
    channels = fieldnames(M.(SN).(ST));
    for k = 1:numel(channels)
        CH = channels{k};
        X = M.(SN).(ST).(CH);
        t = X.start;
        switch lower(type)
            case {'v','voltage','voltages'}
                b = X.bvl;
            case {'o','off','offset','offsets','dc'}
                b = X.off;
            case {'a','amp','amplitude','amplitudes'}
                b = X.amp;
            case {'w','wave','waveform','waveforms'}
                try
                    clear W
                    load([dr,'\WAVEFORMS\',ST,'_',CH,'.mat'])
                    W = check_id_gain(W);
                    WW = [WW W(1)];
                catch
                end
        end
        keep = find(t>=t_rng(1) & t<=t_rng(2));
        t = t(keep);
        if exist('b')
            b = b(keep);
        end
        C = C + 1;
        stalab{C} = [ST,':',CH,'  '];
        try
            switch lower(type)
                case {'v','voltage','voltages'}
                    if X.real_bvl
                        colorscat(t,t*0-C,t*0+200,b,'dataRange',[7, 15],'cBar',0)
                    else
                        scatter(t,t*0-C,t*0+200,...
                            'markerFaceColor',[.7 .7 .7],'markerEdgeColor',[.7 .7 .7])
                    end
                case {'o','off','offset','offsets','dc'}
                    colorscat(t,t*0-C,t*0+200,b,'dataRange',[-4000, 4000],'cBar',0)
                case {'a','amp','amplitude','amplitudes'}
                    colorscat(t,t*0-C,t*0+200,b,'dataRange',[0, 10000],'cBar',0)
                    
                    
colorscat(X,Y,S,R,varargin)

%COLORSCAT: Plots a scatter plot with marker color proportional to the full
%           range of the input array 'R'. The highst and lowest value in
%           'R' define the two extremes of the colorscale used.
%
%USAGE: colorscat(X,Y,S,R)
%       colorscat(X,Y,S,R,prop_name_1, prop_val_1, ...)
%
%MANDATORY INPUTS: X - horizontal axis data
%                  Y - vertical axis data
%                  S - marker scale data
%                  R - marker color range data
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nColorBins'   --> (1x1)-[numeric]-[default: 100]
%  'dataRange'    --> (1x2)
%  'cBar'         --> (1x1)-[logical]-[default: true]
%  'cBarDir'      --> (1x2)-[char]   -[default: 'reverse']
%  'cBarLab'      --> (1x2)-[char]   -[default: '']
%  'timeTickType' --> (1x1)-[char]-[default: '']                    
                    
                    
                    
            end
        catch
        end
        clear b
    end
end

switch lower(type)
    case {'w','wave','waveform','waveforms'}
        plotm2(WW,'scale',.75,'ylab','stachandate')
        xAxH = 30;
        figH = (C+1)*25 + xAxH;
        set(gcf,'Position',[1 1 1200 figH])
    otherwise 
        ylim([-C-1 0])
        set(gca,'YTick',[-C:-1])
        set(gca,'YTickLabel',stalab(end:-1:1))
        xAxH = 30;
        figH = (C+1)*25 + xAxH;
        set(gcf,'Position',[50 50 1200 figH])
        set(gca,'Position',[0.075 xAxH/figH 0.9 (figH-xAxH-5)/figH])
        setxticks(tag)
        xlim(t_rng)
        grid on
end
set(gcf,'Color',[1 1 1])

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


