function [val cnt] = count_unique(A)

val = unique(A);
cnt = [];
if isnumeric(A)
    for n = 1:numel(val)
        cnt(n) = sum(A == val(n));
    end
elseif iscell(A)
    if ischar(A{1})
        for n = 1:numel(val)
            cnt(n) = sum(strcmp(val{n}, A));
        end
    end
else
    error('count_unique: bad input')
end

