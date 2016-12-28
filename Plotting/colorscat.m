function colorscat(X,Y,S,R,varargin)

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
%
%OUTPUTS: none 

%%
cut = find(isnan(R));
R(cut) = []; X(cut) = []; Y(cut) = []; S(cut) = [];

%%
nColorBins = 100;
dataRange = [min(R) max(R)];
cBar = 1;
cBarDir = 'normal';
cBarTicks = linspace(dataRange(1),dataRange(2),11);
cBarLab = '';
timeTickType = '';

%%
if (nargin > 4)
   v = varargin;
   nv = nargin-4;
   if ~rem(nv,2) == 0
       error(['colorscat: Arguments after X,Y,S,R must appear in ',...
           'property name/val pairs'])
   end
   for n = 1:2:nv-1
       name = lower(v{n});
       val = v{n+1};
       switch lower(name)
           case 'nbins'
               if isnumeric(val) && numel(val)==1
                   nColorBins = val;
               end
           case 'datarange'
               if isnumeric(val) && numel(val)==2
                   dataRange = val;
                   if dataRange(2) < dataRange(1)
                       temp = dataRange(2);
                       dataRange(2) = dataRange(1);
                       dataRange(1) = temp;
                       R(R>dataRange(2)) = [];
                       R(R<dataRange(1)) = [];
                   end
               end
           case 'cbar'
               cBar = val;
           case 'cbardir'
               cBar = 1;
               cBarDir = val;        
           case 'cbarticks'
               cBar = 1;
               cBarTicks = val;                  
           case 'cbarlab'
               cBar = 1;
               cBarLab = val;               
           case 'timeticktype'
               cBar = 1;
               [cBarTicks, cBarLab] = timeTicks(val,dataRange);
         otherwise
            error('colorscat: Property name not recognized')
      end
   end
end

%%
R = R - dataRange(1);
R = R/(dataRange(2)-dataRange(1));
R = R*nColorBins;
R = round(R);
R(R==0)=1;
cBarTicks = cBarTicks- dataRange(1);
cBarTicks = cBarTicks/(dataRange(2)-dataRange(1));
extraBins = round(nColorBins*1.1);
C = jet(extraBins);
C = C(1:nColorBins,:);
for k = 1:nColorBins;
    ref = find(R==k);
    cdata = C(k,:);
    scatter(X(ref),Y(ref),S(ref),'markerFaceColor',cdata,'markerEdgeColor',[0 0 0])
    colormap(C)
end


if cBar
    colorbar('YTick',cBarTicks,'YTickLabel',cBarLab,'YDir',cBarDir)
end
end

function [Ticks, Lab] = timeTicks(type,dR)

switch(lower(type))
    case{'auto'}
        span = dR(2)-dR(1);
        if span<=1/144     % 10 Minutes or less
            type = 'min'; 
        elseif span<=1/24  % 1 Hour to 10 Minutes
            type = '5min';
        elseif span<=1/8  % 3 Hours to 1 Hour
            type = '15min';    
        elseif span<=1/4  % 6 Hours to 3 Hours
            type = '30min';  
        elseif span<=1/2  % 12 Hours to 6 Hours
            type = 'hr';  
        elseif span<=1    % 1 Day to 12 Hours
            type = '2hr';  
        elseif span<=3    % 3 Days to 1 Day
            type = '6hr';      
        elseif span<=6    % 6 Days to 3 Days
            type = '12hr'; 
        elseif span<=12   % 12 Days to 6 Days
            type = 'day';   
        elseif span<=42   % 6 Weeks to 12 Days 
            type = 'week'; 
        elseif span<=84   % 3 Months to 6 Weeks 
            type = '2week';   
        elseif span<=365  % 1 Year to 3 Months 
            type = 'month';    
        elseif span<=1095  % 3 Years to 1 Year 
            type = '3month'; 
        else             % Greater than 3 Years
            type = 'year';
        end
    otherwise
end

dv1 = datevec(dR(1)); 
Y1 = dv1(1); M1 = dv1(2); D1 = dv1(3); H1 = dv1(4); m1 = dv1(5); s1 = dv1(6);
dv2 = datevec(dR(2)); 
Y2 = dv2(1); M2 = dv2(2); D2 = dv2(3); H2 = dv2(4); m2 = dv2(5); s2 = dv2(6);
MM = M2-M1+12*(Y2-Y1); 

switch(lower(type))
    case {'min','minute', 'minutes'}
        tickSpace = 1/1440;
    case {'5min','5minute', '5minutes'}
        tickSpace = 1/288;
    case {'15min','15minute', '15minutes'} 
        tickSpace = 1/96;
    case {'30min','30minute', '30minutes','halfhour'} 
        tickSpace = 1/48;
    case {'hr', 'hour', 'hours', 'hourly'} 
        tickSpace = 1/24;
    case {'2hr', '2hour', '2hours'}
        tickSpace = 1/12;
    case {'6hr', '6hour', 'quarterday'}    
        tickSpace = 1/4;
    case {'12hr', '12hour', 'halfday'}   
        tickSpace = 1/2;
    case {'day', 'days', 'daily'} 
        tickSpace = 1;
    case {'week', 'weekly', 'weeks'} 
        tickSpace = 7;
    case {'2week', 'biweekly', '2weeks'}  
        tickSpace = 14; 
    case {'month', 'monthly', 'months'}
        Ticks = datenum(Y1, M1:MM, 1);
        Lab = datestr(Ticks,'mmm-YYYY');
    case {'3month', '3months', 'quarters', 'quarterly'} 
        Ticks = datenum(Y1, M1:3:MM, 1);
        Lab = datestr(Ticks,'mmm-YYYY');
    case {'6month', '6months', 'biannual', 'biannually'}
        Ticks = datenum(Y1, M1:6:MM, 1);
        Lab = datestr(Ticks,'mmm-YYYY');
    case {'year', 'years', 'yearly', 'annual'}     
        Ticks = datenum(Y1:Y2, 1, 1);
        Lab = datestr(Ticks,'YYYY');
    otherwise
end
Ticks = flip(Ticks);
Lab = flip(Lab);
end


