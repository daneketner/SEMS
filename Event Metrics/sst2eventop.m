function [e_rms e_fi e_pf] = sst2eventop(e_sst)
e_rms = [];
e_fi = [];
e_pf = [];
for n = 1:size(e_sst,1)
if rem(n,1000) == 0
   pause(1)
end
e_wfa = get_red_w('ref:ehz',e_sst(n,1),e_sst(n,2),1);
e_rms = [e_rms; event_rms(e_wfa,'val')];
e_fi = [e_fi; freq_index(e_wfa,[1 2],[10 20],'val')];
e_pf = [e_pf; peak_freq(e_wfa,'val')];
end