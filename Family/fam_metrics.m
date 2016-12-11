function F = fam_metrics(F,trig,span)

for N = 1:numel(F.wave)
    t1 = F.start{N}+trig/24/60/60;
    t2 = t1+span/24/60/60;
    for m = 1:numel(F.wave{N})
        w(m) = extract(F.wave{N}(m),'Time',t1(m),t2(m));
    end
    F.rms{N} = rms(w);
    F.pa{N} = peak_amp(w,'val');
    F.p2p{N} = peak2peak_amp(w,'val');
    F.pf{N} = peak_freq(w,'val');
    F.fi{N} = freq_index(w,[1 3],[8 15],'val');
    F.mf{N} = middle_freq(w,'val');
    clear w t1 t2
end