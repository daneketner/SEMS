function sst = sort_sst(sst)

[S N] = sort(sst(:,1));
sst = [S; sst(N,2)];