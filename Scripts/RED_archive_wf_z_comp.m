f = fullfile('C:','Documents and Settings','dketner','Desktop','RED_WF');
for day = 733774:734138
   disp(['starting ',datestr(day,29)])
   w1 = get_red_w('z',day,day+.5,0);
   w2 = get_red_w('z',day+.5,day+1,0);
   w = combine([w1 w2]);
   clear w1 w2
   for m = 1:numel(w)
      ww = w(m);
      save(fullfile(f,[datestr(get(ww,'start'),29),'-',get(ww,'station'),'.mat']),'ww')
      clear ww
   end
   clear w
end