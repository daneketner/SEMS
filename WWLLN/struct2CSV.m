function struct2CSV(S,filename)

% INPUTS:  S - structure with separate fields that are identically sized
%          filename - where to place CSV file (should end with '.csv')

fid = fopen(filename,'w+');
fields = fieldnames(S);

for n = 1:numel(fields)
    
end

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

