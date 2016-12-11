function F = wfa2fam(wfa,trig,xcwin,cc,mfs,ffwin,scnl,ds)

wfa = sort(wfa);
c = correlation(wfa);
c = set(c,'trig',get(c,'start')+trig/24/60/60);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,xcwin);
c = linkage2(c);
c = cluster(c,cc);
stat = getclusterstat(c);
ind = stat.index;
N = sum(stat.numel>=mfs);

for n = 1:N
    c2 = correlation(wfa(ind{n}));
    c2 = sort(c2);
    st = get(c2,'start');
    c2 = set(c2,'trig',st+trig/24/60/60);
    c2 = taper(c2);
    c2 = butter(c2,[1 10]);
    c2 = xcorr(c2,xcwin);
    c2 = adjusttrig(c2,'MIN');
    trigarray = get(c2,'trig');
    for m = 1:numel(ind{n})
        tt = ffwin/24/60/60 + trigarray(m);
        F.wave{n}(m) = get_w(ds,scnl,tt(1),tt(2));
        F.start{n}(m) = trigarray(m);
    end 
    Fstart(n) = min(F.start{n});
end
[V R] = sort(Fstart);
F.wave = F.wave(R);
F.start = F.start(R);


