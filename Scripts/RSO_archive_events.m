% STA/LTA RSO station and save helicorder image for every day

rso_edp = [1 7 2 1.6 3 1.5 0 0];
% 733408 --> Jan 1, 2008
% 733856 --> March 24, 2009
for day = 733424:733424 % Range to detect
   try
   t1 = day; 
   t2 = day+.5; 
   t3 = day+1; 
   w1 = get_red_w('rso',t1,t2,1);
   w2 = get_red_w('rso',t2,t3,1);
   w = combine([w1 w2]);
   e_g = sta_lta(w,'edp',rso_edp,'lta_mode','grow');
   e_c = sta_lta(w,'edp',rso_edp,'lta_mode','continuous');
   e_f = sta_lta(w,'edp',rso_edp,'lta_mode','freeze');
   w = resample(w,'median',4);
   fh_g = build(helicorder(w,'mpl',30,'e_sst',e_g));
   fh_c = build(helicorder(w,'mpl',30,'e_sst',e_c));
   fh_f = build(helicorder(w,'mpl',30,'e_sst',e_f));
   
%    set(fh,'PaperType','A','PaperOrientation','portrait',...
%       'PaperUnits','normalized','PaperPosition',[0,0,1,1])
%    f1 = fullfile('C:','Documents and Settings','dketner','Desktop',...
%       'RED_Events','RSO-EHZ-Daily-Detections-2',[datestr(t1,29),'.m']);
%    save(f1,'e')
%    f2 = fullfile('C:','Documents and Settings','dketner','Desktop',...
%       'Figures-Plots','RSO-EHZ-Daily-Detections-2',datestr(t1,29));
%    print(fh, '-djpeg', f2) 
%    close(fh)
%    clear fh t1 t2 t3 e e1 e2 f1 f2 w w1 w1_stk w2 w2_stk
%    clc
   catch
   end
end


