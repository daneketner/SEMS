function [e_rms e_pa e_fi e_pf] = wfa2eventop(e_wfa)
e_rms = [];
e_fi = [];
e_pf = [];
e_pa = [];
nw = numel(e_wfa);
for n = 1:nw
   waitbar(n/nw)
   w=(e_wfa(n));
   e_rms = [e_rms; event_rms(w,'val')];
   e_fi = [e_fi; freq_index(w,[1 2],[10 20],'val')];
   e_pf = [e_pf; peak_freq(w,'val')];
   e_pa = [e_pa; max(abs(w))];
end