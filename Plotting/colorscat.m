function colorscat(X,Y,S,R,varargin)

%COLORSCAT: Plots a scatter plot with marker color proportional to the full
%           range of the input array 'R'. The highst and lowest value in
%           'R' define the two extremes of the colorscale used.
%
%USAGE: colorscat(X,Y,S,R)
%       colorscat(X,Y,S,R,prop_name, prop_val)
%
%STATIC INPUTS: X - horizontal axis data
%               Y - vertical axis data
%               S - marker scale data
%               R - marker color range data
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nbins'      --> (1x1)-[numeric]-[default: 50]
%  'cbarlab'    --> (1x2)-[char]   -[default: '']
%  'cbar'       --> (1x1)-[logical]-[default: true]
%  'time'       --> (1x1)-[logical]-[default: false]
%  'range'      --> (1x2)
%
%OUTPUTS: none 

nbins = 100;
cbar = 1;
cbarlab = '';
cbardir = 'reverse';
time = 0;
range = [max(R) min(R)];

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
       switch name
           case 'nbins'
               if isnumeric(val) && numel(val)==1
                   nbins = val;
               end
           case 'range'
               if isnumeric(val) && numel(val)==2
                   range = val;
                   if range(1) < range(2)
                       temp = range(1);
                       range(1) = range(2);
                       range(2) = temp;
                       R(R>range(1)) = range(1);
                       R(R<range(2)) = range(2);
                   end
               end
           case 'cbar'
               cbar = val;
           case 'cbarlab'
               cbarlab = val;
           case 'cbardir'
               cbardir = val;
           case 'time'
               time = val;
         otherwise
            error('colorscat: Property name not recognized')
      end
   end
end

%%

R = R - range(2);
R = R/(range(1)-range(2));
R = R*nbins;
R = round(R);
R(R==0)=1;
C = flipud(jet(nbins));
%C = jet(nbins);
cut = find(isnan(R));
R(cut) = []; X(cut) = []; Y(cut) = []; S(cut) = [];
cdata = C(R,:);
scatter(X,Y,S,cdata,'fill')

if cbar
    crange = linspace(range(1),range(2),11);
    for n = 1:11
        if time
            clab{n} = datestr(crange(n),'yyyy');
        else
            clab{n} = num2str(crange(n));
        end
    end
    colorbar('YTickLabel',clab,'YDir',cbardir)
    title(cbarlab)
end


