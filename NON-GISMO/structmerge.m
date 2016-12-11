function S = structmerge(S1,S2)

S = [];
fields1 = fieldnames(S1);
fields2 = fieldnames(S2);
[R1 R2] = strcmp2(fields1, fields2);
for n = 1:numel(R1)
    name1 = fields1{n};
    name2 = fields2{n};
    if isrow(S1.(name1)) && isrow(S2.(name2))
        S.(name1) = [S1.(name1), S2.(name2)];
    elseif iscolumn(S1.(name1)) && iscolumn(S2.(name2))
        S.(name1) = [S1.(name1); S2.(name2)];
    end
end

