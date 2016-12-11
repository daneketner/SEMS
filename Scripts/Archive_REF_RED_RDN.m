
%% STA/LTA REF station and save helicorder image for every day

edp = [1 7 2 1.6 3 1.5 0 0];
f = fullfile('C:','Work','RED_Events','STA_LTA_Daily');

% RD01
cd(fullfile(f,'RD01','WFA'))
t_start = datenum([2009 3 21 0 0 0]);
t_end = datenum([2009 4 4 0 0 0]);
n_sst = [datenum([2009 4 4 14 0 0]) datenum([2009 4 5 0 0 0])];
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rd01:bhz',day,day+1,1);
      w = zero2nan(w,10);
      sub_n_sst = extract_sst(n_sst,day,day+1);
      if ~isempty(sub_n_sst)
         w = set2val(w,sub_n_sst,NaN);
      end
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w sst
      pack
   catch
   end
end

% RD02
cd(fullfile(f,'RD02','WFA'))
t_start = datenum([2009 3 20 0 0 0]);
t_end = datenum([2009 5 7 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rd02:bhz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% RD03
cd(fullfile(f,'RD03','WFA'))
t_start = datenum([2009 3 20 0 0 0]);
t_end = datenum([2009 6 3 0 0 0]);
n_sst = [datenum([2009 5 8 13 24 0]) datenum([2009 5 9 0 0 0])];
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rd03:bhz',day,day+1,1);
      w = zero2nan(w,10);
      sub_n_sst = extract_sst(n_sst,day,day+1);
      if ~isempty(sub_n_sst)
         w = set2val(w,sub_n_sst,NaN);
      end
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w sst
      pack
   catch
   end
end

% RDW
cd(fullfile(f,'RDW','WFA'))
t_start = datenum([2009 3 21 0 0 0]);
t_end = datenum([2009 7 1 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdw:bhz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% RDJH
cd(fullfile(f,'RDJH','WFA'))
t_start = datenum([2009 2 20 0 0 0]);
t_end = datenum([2009 3 23 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdjh:bhz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end
t_start = datenum([2009 5 1 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdjh:bhz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% RDWB
cd(fullfile(f,'RDWB','WFA'))
t_start = datenum([2009 11 18 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdwb:bhz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% REF
cd(fullfile(f,'REF','WFA'))
t_start = datenum([2009 11 18 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('ref:ehz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% RDE
cd(fullfile(f,'RDE','WFA'))
t_start = datenum([2009 2 4 0 0 0]);
t_end = datenum([2009 7 2 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rde',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

%% NCT
cd(fullfile(f,'NCT','WFA'))
t_start = datenum([2009 10 2 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('nct',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% DFR
cd(fullfile(f,'DFR','WFA'))
t_start = datenum([2008 7 1 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('dfr',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

% RDT
cd(fullfile(f,'RDT','WFA'))
t_start = datenum([2008 7 1 0 0 0]);
t_end = datenum([2009 12 31 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('rdt',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end

%% REF
cd(fullfile(f,'REF','WFA'))
t_start = datenum([2008 7 8 0 0 0]);
t_end = datenum([2009 11 17 0 0 0]);
for day = t_start:t_end % Range to detect
   try
      w = get_red_w('ref:ehz',day,day+1,1);
      w = zero2nan(w,10);
      wfa = sta_lta(w,'edp',edp,'lta_mode','continuous','return','wfa');
      save([datestr(day,29),'.mat'],'wfa')
      clear w wfa
      pack
   catch
   end
end