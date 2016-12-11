function S = substruct(S,R,D,varargin)

% INPUTS:  S - structure with separate fields that are identically sized
%          R - reference to elements to keep or discard within each field
%          D - if D>0,  R is reference of elements to keep in each field
%              if D<=0, R is reference of elements to discard in each field

if ~isstruct(S)
    error('SUBSTRUCT: Input S must be type structure')
end
if ~isnumeric(D) || numel(D)>1
    error('SUBSTRUCT: Input D must be a single boolean value')
end

fields = fieldnames(S);

% if nargin == 4
%     field = varargin{1};
%     if ~isfield(S,field)
%         error('SUBSTRUCT: 4th input must be a valid field name')
%     end
%     [val r1 r2] = intersect(S.(field),R,'stable');
%     R = r1;
% end

for n = 1:numel(fields)
    s = S.(fields{n});
    [s1, s2] = size(s);
    if s1 ~= s2
        if D > 0
            S.(fields{n}) = s(R);
        else
            s(R) = [];
            S.(fields{n}) = s;
        end
    else
        if D > 0
            S.(fields{n}) = s(R,R);
        else
            s(R,R) = [];
            S.(fields{n}) = s;
        end
    end
end
