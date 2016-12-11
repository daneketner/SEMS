function E = metric_sort(E,srtfld)

if ~isa(E,'struct')
   error('METRIC_SORT: Input is not a structure array')
end

fn = fieldnames(E);
[V R] = sort(E.(srtfld));
for n=1:length(fn)
   E.(fn{n}) = E.(fn{n})(R);
end