function plot_fam_metric(F)

M = length(F);
warning off
C = distinguishable_colors(M);
warning on
for m=1:M
   %FI = freq_index(F{m},[2 4],[8 25],'val');
   PF = peak_freq(max_energy(F{m},5.12),'val');
   RMS = rms(F{m});
   if m == 1
      figure
      %scatter(get(F{m},'start'),FI,RMS/25,'cdata',C(m,:))
      scatter(get(F{m},'start'),PF,RMS/25,'cdata',C(m,:))      
      hold on
   else
      %scatter(get(F{m},'start'),FI,RMS/25,'cdata',C(m,:))
      scatter(get(F{m},'start'),PF,RMS/25,'cdata',C(m,:))      
   end
end
dynamicDateTicks