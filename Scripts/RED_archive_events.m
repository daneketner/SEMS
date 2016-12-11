% STA/LTA RSO station and save helicorder image for every day

f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','STA_LTA_Daily');
edp = [1 7 2 1.6 3 1.5 0 0];
% 733408 --> Jan 1, 2008
% 733856 --> March 24, 2009
for day = 733774:733856 % Range to detect
   try
   t1 = day; 
   t2 = day+.5; 
   t3 = day+1; 
   w1 = get_red_w('rso',t1,t2,1);
   w2 = get_red_w('rso',t2,t3,1);
   w = combine([w1 w2]);
   clear w1 w2
   
   e_002 = sta_lta(w,'edp',edp,'lta_mode','grow');
   e_003 = sta_lta(w,'edp',edp,'lta_mode','continuous');
   save(fullfile(f,'RSO','SST_002',[datestr(t1,29),'.m']),'e_002')
   save(fullfile(f,'RSO','SST_003',[datestr(t1,29),'.m']),'e_003')
   
   w = resample(w,'median',4);
   fh_002 = build(helicorder(w,'mpl',30,'e_sst',e_002));
   fh_003 = build(helicorder(w,'mpl',30,'e_sst',e_003));
   
   set(fh_002,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   set(fh_003,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   
   print(fh_002, '-djpeg', fullfile(f,'RSO','HEL_002',datestr(t1,29))), close(fh_002)
   print(fh_003, '-djpeg', fullfile(f,'RSO','HEL_003',datestr(t1,29))), close(fh_003)
   clc
   catch
   end
end

for day = 733408:734138 % Range to detect
   try
   t1 = day; 
   t2 = day+.5; 
   t3 = day+1; 
   w1 = get_red_w('ref:ehz',t1,t2,1);
   w2 = get_red_w('ref:ehz',t2,t3,1);
   w = combine([w1 w2]);
   clear w1 w2
   
   e_002 = sta_lta(w,'edp',edp,'lta_mode','grow');
   e_003 = sta_lta(w,'edp',edp,'lta_mode','continuous');
   e_004 = sta_lta(w,'edp',edp,'lta_mode','freeze');
   
   save(fullfile(f,'REF','SST_002',[datestr(t1,29),'.m']),'e_002')
   save(fullfile(f,'REF','SST_003',[datestr(t1,29),'.m']),'e_003')
   save(fullfile(f,'REF','SST_004',[datestr(t1,29),'.m']),'e_004')
   
   w = resample(w,'median',4);
   fh_002 = build(helicorder(w,'mpl',30,'e_sst',e_002));
   fh_003 = build(helicorder(w,'mpl',30,'e_sst',e_003));
   fh_004 = build(helicorder(w,'mpl',30,'e_sst',e_004));
   
   set(fh_002,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   set(fh_003,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   set(fh_004,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   
   print(fh_002, '-djpeg', fullfile(f,'REF','HEL_002',datestr(t1,29))), close(fh_002)
   print(fh_003, '-djpeg', fullfile(f,'REF','HEL_003',datestr(t1,29))), close(fh_003)
   print(fh_004, '-djpeg', fullfile(f,'REF','HEL_004',datestr(t1,29))), close(fh_004)   
   clc
   catch
   end
end

