function plot_outage(M,t_rng,tag,dr)

D = M.Outage;
T = M.TimeVector;
subnets = fieldnames(D);

%%
if isempty(t_rng)
    switch tag
        case 'Week'
            t_rng = [now-7, now];
        case 'Month'
            t_rng = [now-30, now];
        case '3Month'
            t_rng = [now-90, now];
        case 'Year'
            t_rng = [now-365, now];
        case 'All'
            t_rng = [T(1), now];
    end
end
keep = find(T>=t_rng(1) & T<=t_rng(2));
T = T(keep);

%%
for n = 1:numel(subnets)
    dat = [];
    names = {};
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(D.(SU).(ST));
        for k =1:numel(channels)
            CH = channels{k};
            d = D.(SU).(ST).(CH);
            dat = [dat, d(keep)];
            names{end + 1} = [ST,':',CH];
        end
    end
    imagesc(T,1:m,dat')
    set(gcf,'Color','w')
    % d1 & d2 define upper & lower limits of red & green values
    % (d1 = 1) if (dat min =   0%) --> red = 1, green = 1
    % (d2 = 0) if (dat max = 100%) --> red = 0, green = 0
    % d3 defines upper & lower limits of blue values
    % (d3 = 1)  if (dat min =   0%) --> blue = 1
    % (d4 = .5) if (dat min = 100%) --> blue = .5
    % Color map range: 100% --> [0 0 .5] (dark blue), 0% --> [1 1 1] (white)
    % dd is number of elements in colormap (max = 64), i.e. 
    % 0% and 100% appear on the same map
    d1 = 1-min(min(dat)); 
    d2 = 1-max(max(dat)); 
    d3 = 1-.5*(1-d1);
    d4 = .5+d2/2;
    dd = ceil(64*(d1-d2));
    Cmap = [linspace(d1,d2,dd)', linspace(d1,d2,dd)', linspace(d3,d4,dd)'];
    colormap(Cmap);
    for l = 1:m-1
        line([t_rng(1), t_rng(2)],[l+.5, l+.5],'Color','w','LineWidth',2)
    end
    grid on
    setxticks(tag)
    xlim(t_rng)
    set(gca,'YTick',1:length(names))
    set(gca,'YTickLabel',names)
    set(gcf,'Position',[100 100 1200 45+35*m])
    export_fig([dr,'\HTML\',SU,'-',tag],'-png')
    pause(.1)
    close all
end

%%
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