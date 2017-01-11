function colorscat(X,Y,S,C,varargin)

%COLORSCAT: Plots a scatter plot with marker color proportional to the full
%           range of the input array 'C'. The highst and lowest value in
%           'C' define the two extremes of the colorscale used.
%
%USAGE: colorscat(X,Y,S,C)
%       colorscat(X,Y,S,C,prop_name_1, prop_val_1, ...)
%
%MANDATORY INPUTS: X - horizontal axis data
%                  Y - vertical axis data
%                  S - marker scale data
%                  C - marker color range data
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nColorBins'      --> (1x1)-[numeric]-[default: 100]
%  'dataRange'       --> (1x2)-[numeric]-[default: min & max of C]
%  'cBar'            --> (1x1)-[logical]-[default: true]
%  'cBarDir'         --> (1x2)-[char]   -[default: 'reverse']
%  'cBarLab'         --> (1x2)-[char]   -[default: '']
%  'cBarDateTicks'   --> (1x1)-[logical]-[default: 0]
%  'markerEdgeColor' -->
%  'markerLayerOrder'--> +x, -x, +y, -y, +c, -c
%
%OUTPUTS: none 

%%
gca;
cut = find(isnan(C));
C(cut) = []; X(cut) = []; Y(cut) = []; S(cut) = [];
if isempty(X)||isempty(Y)
    return
end

%%
nColorBins = 100;
dataRange = [min(C) max(C)];
cBar = 1;
cBarDir = 'normal';
cBarTicks = linspace(dataRange(1),dataRange(2),11);
cBarLab = '';
cBarDateTicks = 0;

%%
if (nargin > 4)
   v = varargin;
   nv = nargin-4;
   if ~rem(nv,2) == 0
       error(['colorscat: Arguments after X,Y,S,C must appear in ',...
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
                       C(C>dataRange(2)) = [];
                       C(C<dataRange(1)) = [];
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
           case 'cbardateticks'
               cBar = 1;
               [cBarTicks, cBarLab] = timeTicks(val,dataRange);
           case 'markeredgecolor'
           case 'markerlayerorder'
         otherwise
            error('colorscat: Property name not recognized')
      end
   end
end

%%
C = C - dataRange(1);
C = C/(dataRange(2)-dataRange(1));
C = C*nColorBins;
C = round(C);
C(C==0)=1;
cBarTicks = cBarTicks- dataRange(1);
cBarTicks = cBarTicks/(dataRange(2)-dataRange(1));
extraBins = round(nColorBins*1.1);
Cdat = jet(extraBins);
Cdat = Cdat(1:nColorBins,:);

switch markerLayerOrder
    case '+x'
    case '-x'
    case '+y'
    case '-y'
    case '+c'
    case '-c'
    othewise
end

for k = 1:nColorBins;
    ref = find(C==k);
    cdata = Cdat(k,:);
    if numel(S)==1
    scatter(X(ref),Y(ref),S,'markerFaceColor',cdata,'markerEdgeColor',[0 0 0])
    else
    scatter(X(ref),Y(ref),S(ref),'markerFaceColor',cdata,'markerEdgeColor',[0 0 0])
    end
    colormap(Cdat)
end


if cBar
    colorbar('YTick',cBarTicks,'YTickLabel',cBarLab,'YDir',cBarDir)
end
end

function [Ticks, Lab] = timeTicks(dR)

h = figure('visible','off'); 
scatter(dR,dR);
dynamicDateTicks;
Ticks = get(gca,'xTick');
Lab = get(gca,'xTickLabel');
close(h)
Ticks = flip(Ticks);
Lab = flip(Lab);
end


