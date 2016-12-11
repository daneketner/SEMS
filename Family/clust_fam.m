function C = clust_fam(wfa,cval)

%CLUST_FAM: Outputs a family cluster structure for an array of waveforms 
%           and a threshold cluster value.
%
%USAGE: C = clust_fam(wfa,cval)
%
%INPUTS: wfa - a waveform object array
%        cval - correlation threshold for clustering
%
%OUTPUTS: C - cluster structure
%         C.stat - from correlation object 'getclusterstat'
%         C.c - correlation object for each family
%         C.w - waveform array for each family
%         C.stk - stacked waveforms from each array

%%
c = correlation(wfa);
%plot(c,'wig')
%c = crop(c,-5,5);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
%plot(c,'sha')
%plot(c,'corr')
%plot(c,'wig')
c = linkage2(c);
%plot(c,'den')
c = cluster(c,cval);
C.stat = getclusterstat(c);
k = 1;
while C.stat.numel(k)>=5
    C.c(k) = subset(c,C.fam.index{k});
    C.c(k) = xcorr(C.c(k));
    C.c(k) = adjusttrig(C.c(k),'MIN');
    C.c(k) = crop(C.c(k),[-10 10]);
    C.w{k} = wfa(C.fam.index{k});
    C.stk(k) = stack(waveform(C.clust(k)));
    k = k+1;
end
