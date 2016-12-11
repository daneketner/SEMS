function varargout = get_picks(W,varargin)

pout = 0;
sout = 0;

if ~isa(W,'waveform')
    error('GET_PICKS: First input must be a waveform object')
end

% if (nargin-1) ~= nargout
%     error(['GET_PICKS: Number of picks specified by inputs must match ',...
%                        'the number of outputs'])
% end

for n = 1:nargin-1
    if strcmpi(varargin{n},'p')
        pout = n;
    elseif strcmpi(varargin{n},'s')
        sout = n;
    end
end

if pout
    pp = get(W,'P_DATENUM');
    P = [];
    if iscell(pp)
        for r = 1:numel(pp)
            if ~isempty(pp{r})
                P = [P pp{r}];
            else
                P = [P 0];
            end
        end
    else
        P = pp;
    end
    varargout{n} = P;
end

if sout
    sp = get(W,'S_DATENUM');
    S = [];
    if iscell(sp)
        for r = 1:numel(sp)
            if ~isempty(sp{r})
                S = [S sp{r}];
            else
                S = [S 0];
            end
        end
    else
        S = sp;
    end
    varargout{n} = S;
end


