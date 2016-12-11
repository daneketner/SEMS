function colorscat3(X,Y,Z,S,R,varargin)

%COLORSCAT3: Plots a 3D scatter plot with marker color proportional to the 
%           full range of the input array 'R'. The highst and lowest value 
%           in 'R' define the two extremes of the colorscale used.
%
%USAGE: colorscat3(X,Y,Z,S,R)
%       colorscat3(X,Y,Z,S,R,prop_name, prop_val)
%
%STATIC INPUTS: X - horizontal axis data
%               Y - vertical axis data
%               S - marker scale data
%               R - marker color range data
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nbins'      --> (1x1)-[numeric]-[default: 50]
%  'colorlabel' --> (1x2)-[char]   -[default: '']
%  'time'       --> (1x1)-[logical]-[default: false]
%
%OUTPUTS: none 

nbins = 50;
cbarlab = '';
cbar = 1;
time = 0;
rng = [];

%%
if (nargin > 5)
   v = varargin;
   nv = nargin-5;
   if ~rem(nv,2) == 0
      error(['colorscat: Arguments after X,Y,Z,S,R must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nbins' 
            if isnumeric(val) && numel(val)==1
               nbins = val;
            end
         case 'range'
             rng = val;
         case 'cbarlab' 
            cbarlab = val;  
         case 'cbar' 
            cbar = val;       
         case 'time' 
            time = val;    
         otherwise
            error('colorscat: Property name not recognized')
      end
   end
end

%%
d = max(R) - min(R);
r = ceil((R-min(R))/d*nbins);
r(r==0) = 1;
c = jet(nbins);
for n=1:nbins
    if n == 2, hold on, end
    ref = r == n;
    scatter3(X(ref),Y(ref),Z(ref),S(ref),'markerEdgeColor','k',...
        'markerFaceColor',c(n,:))
end

if cbar
    if isempty(rng)
        rng = linspace(min(R),max(R),11);
    end
    for n = numel(rng)
        if time
            clab{n} = datestr(rng(n),'yyyy');
        else
            clab{n} = num2str(rng(n));
        end
    end
    colorbar('YTickLabel',clab)
    title(cbarlab)
end


