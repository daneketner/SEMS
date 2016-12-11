
%% STA/LTA Archive All Remaining Events

edp = [1 7 2 1.6 3 1.5 0 0];
f = fullfile('C:','Work','RED_Events','STA_LTA_Daily','RDT');
t_start = datenum([2008 12 14 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdt',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([f,'\WFA_Daily\',datestr(day,29),'.mat'],'wfa')
      sst = wfa2sst(wfa);
      save([f,'\SST_Daily\',datestr(day,29),'.mat'],'sst')
      clear w wfa sst
      pack
   catch
   end
end

%%

edp = [1 7 2 1.6 3 1.5 0 0];
f = fullfile('C:','Work','RED_Events','STA_LTA_Daily','RDWB');
t_start = datenum([2009 2 1 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdwb:bhz',day,day+1,1);
      w = bp_filt(w);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([f,'\WFA_Daily\',datestr(day,29),'.mat'],'wfa')
      sst = wfa2sst(wfa);
      save([f,'\SST_Daily\',datestr(day,29),'.mat'],'sst')
      clear w wfa sst
      pack
   catch
   end
end

