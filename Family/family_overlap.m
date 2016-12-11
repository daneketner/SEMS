function ovr = family_overlap(t1,t2,tmin)

if isa(t1,'double') && ((size(t1,1)==1) || (size(t1,2)==1))
    tt1{1} = t1;
elseif isa(t1,'cell') && ((size(t1,1)==1) || (size(t1,2)==1))
    tt1 = t1;
end

if isa(t2,'double') && ((size(t2,1)==1) || (size(t2,2)==1))
    tt2{1} = t2;
elseif isa(t2,'cell') && ((size(t2,1)==1) || (size(t2,2)==1))
    tt2 = t2;
end

ovr = zeros(numel(tt1)+1,numel(tt2)+1);

for n=1:numel(tt1)
    ovr(n+1,1) = numel(tt1{n});
    for m=1:numel(tt2)
        if n==1
            ovr(1,m+1) = numel(tt2{m});
        end
        [X Y] = meshgrid(tt1{n}, tt2{m});
        Z = abs(Y-X);
        ovr(n+1,m+1) = sum(sum(Z<tmin));
    end
end
