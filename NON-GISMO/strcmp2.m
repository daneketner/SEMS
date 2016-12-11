function [r1, r2] = strcmp2(C1, C2)

r1 = [];
r2 = [];
for n = 1:numel(C1)
    for m = 1:numel(C2)
        if strcmp(C1{n},C2{m})
            r1 = [r1, n];
            r2 = [r2, m];            
        end
    end
end

