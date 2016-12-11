function plot_event(EM,N,varargin)

%PLOT_PICKS: Plot Multiple Waveforms

Dir = make_dir_mstr;
load([Dir.Evt_Wav,'\',num2str(EM.evid(N)),'.mat'])

%% DEFAULT PROPERTIES

sp = 10;          % trace spacing
hpf = 1;          % high-pass filter waveforms?
aligntime = 0;    % don't align traces to similar time scale
fill = 0;         % don't area fill bottom half of waveform
xltype = 'med';   

W = W(isvertical(W));
[v r] = sort(get_picks(W,'p'));
W = W(r);
sta = get(W,'station');
cha = get(W,'channel');
nsta = numel(unique(sta));
ncha = numel(unique(cha));
if (nsta == 1) && (ncha == 1)
    ylabtype = 'time';
    tit = 'sta:chan';
else
    ylabtype = 'sta:chan';
    t = floor(get(W,'start')*24*60*60);
    nt = numel(unique(t));
    if nt == 1
        tit = 'time';
    else
        tit = 'none';
        ylabtype = 'sta:chan [time]';
    end
end
nid = numel(unique(get(W,'evid')));
if nid == 1
    aligntime = 1;
    tit = 'event';
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
    v = varargin;
    nv = nargin-2;
    if ~rem(nv,2) == 0
        error(['plotm2: Arguments after wave must appear in ',...
            'property name/val pairs'])
    end
    for n = 1:2:nv-1
        name = lower(v{n});
        val = v{n+1};
        switch name
            case 'ID'
                if val
                    hpf = 1;
                end
            case 'filt'
                if val
                    hpf = 1;
                end
            case 'aligntime'
                if val
                    aligntime = 1;
                end
            case 'scale' % Event Start/Stop Times
                if isnumeric(val) && numel(val)==1
                    sp = sp/val; % Where I left off...
                end
            case 'fill' % Trace Fill
                fill = val;
            case 'ylab' % Y-Tick Spacing
                ylabtype = val;
            case 'tit' % Title
                tit = val;    
            otherwise
                error('plotm2: Property name not recognized')
        end
    end
end

%%
if hpf
    W = filt(W,'hp',.5);
end

if aligntime
    medur = nanmedian(get(W,'duration'));
    t = get(W(1),'ev_datenum');
    W = extract(W,'TIME',t,t+medur);
    medur = nanmedian(get(W,'duration'));
end

L = get(W,'data_length')./get(W,'freq');
switch xltype
    case 'max'
        xl = max(L);
    case 'min'
        xl = min(L);
    case 'mean'
        xl = mean(L);    
    case 'med'
        xl = median(L);
end
W = demean(W);
W = W./mean(abs(W)); % scale waveforms

if isempty(findobj('type','figure'))
    fh = figure;
    ax = axes;
elseif isempty(findobj('type','axes'))
    fh = gcf;
    ax = axes;
else
    fh = gcf;
    ax = gca;    
end

nw = numel(W);

%%
warning off
for n = 1:nw
    cl(n) = -n*sp;   % trace center line
    sta = get(W(n),'station');
    cha = get(W(n),'channel');
    tv = get(W(n),'timevector');
    start = get(W(n),'start');
    d2s = 24*60*60;
    dat = get(W(n),'data');
    pt = get(W(n),'p_datenum');
    st = get(W(n),'s_datenum');
    if fill~=0
        area((tv-start)*d2s,dat+cl(n),cl(n),'LineWidth',1)
        if n==1, hold on, end
        off = min(dat);
        area((tv-start)*d2s,dat+cl(n),-nw*sp*2,'FaceColor',[1 1 1])
    else
        plot((tv-start)*d2s,dat+cl(n),'Color',[0 0 0])
        if n==1, hold on, end
        try scatter((pt-start)*24*60*60,cl(n),'*','r'), catch, end
        try scatter((st-start)*24*60*60,cl(n),'*','g'), catch, end
    end
    ypos(n)=cl(n);
    switch ylabtype
        case {'sta:chan [time]'}
            ylab{n}=[sta,':',cha,' [',datestr(start),']'];
        case 'time'
            ylab{n}=datestr(start);
        case {'station','sta'}
            ylab{n}=sta;
        case {'station-channel','station:channel','station/channel',...
                'sta-chan','sta:chan','sta/chan','stachan'}
            ylab{n}=[sta,':',cha];
            if n==1, title(datestr(start)), end
    end
end
ypos=ypos(end:-1:1);
ylab=ylab(end:-1:1);
set(ax,'YTick',ypos,'YTickLabel',ylab)
ylim([cl(end)-2*sp cl(1)+2*sp])
xlim([0 xl])
if aligntime
    xlim([0 medur*24*60*60])
end
xlabel('Time (s)')
switch tit
    case 'time'
        title(datestr(get(W(1),'start')))
    case 'sta:chan'
        title([sta,':',cha])
    case 'event'
            evid = num2str(get(W(1),'evid'));
            start = datestr(get(W(1),'ev_datenum'));
            depth = num2str(get(W(1),'ev_depth'));
            mag = num2str(get(W(1),'ev_mag'));
            pfmed = num2str(EM.pfmed(N));
            title(['EVENT ID: ',evid,',  DATE: ',start,...
                ',  DEPTH: ',depth,',  MAG: ',mag,',  FREQ: ',pfmed])
end










