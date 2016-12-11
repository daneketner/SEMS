function colorhist(X,C,varargin)

%COLORHIST: 
%
%USAGE: colorhist(X,C)
%                                       
%  .                                        
%  .                                         
%  .         [ ]         [ ]  
%  .         [ ]         [ ][ ] 
%  .         [ ]         [ ][ ]  
%  .      [ ][ ]      [ ][ ][ ][ ]  
%  .      [ ][ ][ ]   [ ][ ][ ][ ][ ][ ] 
%  .   [ ][ ][ ][ ]   [ ][ ][ ][ ][ ][ ][ ]  
%  .   [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]                                        
%  ..........................................
%
%STATIC INPUTS: X - Data controlling bar height (after mapping to bins)
%               C - Data controlling bar color (after mapping to bins)
%
%OPTIONAL INPUTS: 
%  xbins   - When xbins is a single positive number, it represents the 
%              number of evenly spaced bins in which to map data (X). When
%              xbins contains multiple monotonically increasing values,
%              these values become edges of each histogram column
%  cbins   - When cbins is a single positive number, it represents the 
%              number of evenly spaced bins in which to map data (C). When
%              cbins contains multiple monotonically increasing values,
%              these values become the upper bound value of each bin in
%              which to map C.
%  xlimit    - (1x2 numeric) - Sets the upper and lower limits for the data
%              range of X. Values exceeding the upper and lower limit will
%              be lumped into the highest or lowest bin, but can also be
%              truncated by changing the value of 'xexceed'.
%  climit    - (1x2 numeric) - Sets the upper and lower limits for the data
%              range of C. Values exceeding the upper and lower limit will
%              be lumped into the highest or lowest bin, but can also be
%              truncated by changing the value of 'cexceed'.
%  xexceed - 'merge'    - merge values which exceed xlimit with the highest
%            'truncate' - trucate values above and below xlimit
%  cexceed - 'merge'    - merge values which exceed climit with the highest
%            'truncate' - trucate values above and below climit
%
%OUTPUTS: none

%%
if ~isnumeric(X) || ~isnumeric(C) || (numel(X) ~= numel(C))
    error('COLORHIST: Inputs X and C must be numeric with the same length')
end

%% Check varargin size
nv = numel(varargin);
if ~rem(nv,2) == 0
   error(['COLORHIST: Arguments after wave must appear in ',...
          'property_name/property_value pairs'])
end

xexceed = 1;
cexceed = 1;

%% User-defined parameters (varargin)
if nv > 0
    for p = 1:2:nv-1
        v1 = varargin{p};
        v2 = varargin{p+1};
        switch lower(v1)
            case 'xbins'
                xbins = v2;
            case 'cbins'
                cbins = v2;
            case 'xlimit'
                xlimit = v2;
            case 'climit'
                climit = v2;
            case 'xexceed'
                switch lower(v2)
                    case 'merge'
                        xexceed = 1;
                    case 'truncate'
                        xexceed = 0;
                end
            case 'cexceed'
                switch lower(v2)
                    case 'merge'
                        cexceed = 1;
                    case 'truncate'
                        cexceed = 0;
                end
            otherwise
                error('COLORHIST: Property name not recognized')
        end
    end
end

%% Default parameters
if ~exist('xlimit','var')
    xlimit = [min(X), max(X)];
end

if ~exist('climit','var')
    climit = [min(C), max(C)];
end

if xexceed
    X(X<xlimit(1)) = xlimit(1);
    X(X>xlimit(2)) = xlimit(2);
else
    X(X<xlimit(1)) = [];
    X(X>xlimit(2)) = [];
    C(X<xlimit(1)) = [];
    C(X>xlimit(2)) = [];
end

if cexceed
    C(C<climit(1)) = climit(1);
    C(C>climit(2)) = climit(2);
else
    C(C<climit(1)) = [];
    C(C>climit(2)) = [];
    X(C<climit(1)) = [];
    X(C>climit(2)) = [];
end

if ~exist('xbins','var')
    xbins = xlimit(1):(xlimit(2)-xlimit(1))/20:xlimit(2);
elseif length(xbins) == 1
    xbins = xlimit(1):(xlimit(2)-xlimit(1))/xbins:xlimit(2);
end

if ~exist('cbins','var')
    cbins = climit(1) : (climit(2)-climit(1))/20 : climit(2);
elseif length(cbins) == 1
    cbins = climit(1) : (climit(2)-climit(1))/cbins : climit(2);
end

%%
hold on

Cmap = jet(length(cbins));
for n = 1:length(xbins)-1
    x1 = xbins(n);
    x2 = xbins(n+1);
    if n < length(xbins)-1
        ind = find(X >= x1 & X < x2);
    else
        ind = find(X >= x1 & X <= x2);
    end
    subC = C(ind);
    yoff = 0;
    y_bottom = 0;
    for m = 1:length(cbins)-1
        c1 = cbins(m);
        c2 = cbins(m+1);
        y1 = y_bottom;
        if m < length(cbins)-1
            y2 = sum(subC >= c1 & subC < c2) + y_bottom;
        else
            y2 = sum(subC >= c1 & subC <= c2) + y_bottom;
        end
        area([x1,x2,x2,x1],[y1,y1,y2,y2],...
            'LineStyle','none','FaceColor',Cmap(m,:))
        y_bottom = y2;
    end
end
