function [config, log] = sems_program(config,log)

if exist(config.root_dir) ~= 7
   mkdir(config.root_dir)
end
cd(config.root_dir);

%% CHECK FILE STRUCTURE - CREATE IF DOESN'T EXIST
for n = 1:numel(config.scnl)
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'wfa_day'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'wfa_day'))
   end
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'fft_day'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'fft_day'))
   end
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'metric_day'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'metric_day'))
   end   
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'helicorder'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'helicorder')) 
   end
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'wfa_block'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'wfa_block'))
   end
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'corr_block'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'corr_block'))
   end
   if exist(fullfile(config.root_dir,get(config.scnl(n),'station'),'fam_clust'))~=7
      mkdir(fullfile(config.root_dir,get(config.scnl(n),'station'),'fam_clust'))
   end
end

%%
fh = getappdata(0,'sems_main_fig');
handles = guidata(fh);

%%
edp = config.edp;
base_edp = [edp.l_sta, edp.l_lta, edp.th_on,...
            edp.th_off, edp.min_sep, edp.min_len];

%% LOOP OVER ALL DAYS FOR ALL SCNL -->
%  DETECT EVENTS
%  SAVE EVENTS TO FILE
%  COMPUTE METRICS
%  SAVE METRICS TO FILE
%  BUILD HELICORDER
%  SAVE HELICORDER TO FILE

for n = log.cur_day : numel(config.day)  % LOOP OVER DATE RANGE
for m = 1 : numel(config.scnl)           % LOOP OVER SCNL
try                                      % IF THINGS GO SOUTH...
   log.cur_day = n;
   log.cur_scnl = m;
   % UPDATE DISPLAY TEXT
   update_display(handles,config,n,m,'Fetching waveform from ');
   % FETCH WAVEFORM
   w = get_w(config.ds,config.scnl(m),config.day(n),config.day(n)+1);
   if ~isempty(w)
      log.wavefetch(n,m) = 1;
      % FILTER WAVEFORM FOR EVENT DETECTOR
      w2 = filt(w,'bp',[edp.bp_low edp.bp_hi]);
      % HILBERT TRANSFORM WAVEFORM IF REQUESTED
      if edp.hilb > 0
         try
         w2 = hilbert(w2);
         catch
         end
      end
      % MAKE GAPS INTO NAN VALUES
      w2 = zero2nan(w2,5);
      % UPDATE DISPLAY TEXT
      update_display(handles,config,n,m,'Detecting events from ')
      % DETECT EVENTS
      wfa_day = sta_lta(w2,'edp',base_edp,'lta_mode',edp.lta_mod,...
         'eot','wfa','fix',edp.fix,'pad',edp.pad);
      if isempty(wfa_day)
         update_display(handles,config,n,m,'No events detected from ')
         wfa_day = waveform();
         wfa_day(:) = []; % Make wfa_day a 0x0
      else
         % UPDATE DISPLAY TEXT
         update_display(handles,config,n,m,'Computing event metrics from ')
      end
      cd(fullfile(config.root_dir,get(config.scnl(m),'station'),'wfa_day'))
      save([datestr(config.day(n),29),'.mat'],'wfa_day')
      log.eventcount(n,m) = numel(wfa_day);
      % COMPUTE EVENT METRICS
      [metric_day FFT] = sems_metric(wfa_day,w,config);
      % SAVE EVENT FFT
      cd(fullfile(config.root_dir,get(config.scnl(m),'station'),'fft_day'))
      save([datestr(config.day(n),29),'.mat'],'FFT')
      % SAVE EVENT METRICS
      cd(fullfile(config.root_dir,get(config.scnl(m),'station'),'metric_day'))
      save([datestr(config.day(n),29),'.mat'],'metric_day')
      % UPDATE DISPLAY TEXT
      update_display(handles,config,n,m,'Building helicorder for ')      
      % BUILD HELICORDER
      fh = build(helicorder(w,'mpl',30,'e_sst',wfa2sst(wfa_day)));
      set(fh,'PaperType','A','PaperOrientation','portrait',...
         'PaperUnits','normalized','PaperPosition',[0,0,1,1])
      % SAVE HELICORDER
      print(fh, '-dpng', fullfile(config.root_dir,get(config.scnl(m),'station'),...
         'Helicorder',datestr(config.day(n),29)))
      close(fh)
      clear w wfa metric_day
   else % UNABLE TO FETCH WAVEFORM
      log.wavefetch(n,m) = 0;
      % UPDATE DISPLAY TEXT
      update_display(handles,config,n,m,'No waveform was available from ')
   end
catch % SOMETHING WENT WRONG, SAVE THE LOG!
   [pathstr, name, ext, versn] = fileparts(config.log_path);
   cd(pathstr)
   save(name,'log')
   % UPDATE DISPLAY TEXT
   update_display(handles,config,n,m,'An error occurred: ')
end
end
end

%% CONVERT DAILY WAVEFORMS TO WAVEFORM BLOCKS
%[config,log] =  wfa_day2block(config,log)

%% CROSS-CORRELATE PAIRS OF WAVEFORM BLOCKS
%[config,log] = wfablock2corrblock(config,log)

%% CROSS-CORRELATION BLOCKS TO FAMILY CLUSTER
%[config,log] = corrblock2clust(config,log)

%% UPDATE THE TOP LINE OF THE DISPLAY TEXT IN SEMS GUI
function update_display(handles,config,n,m,txt)
str = get(handles.disp_txt,'String');
if ischar(str)
   set(handles.disp_txt,'String',{str})
   str = get(handles.disp_txt,'String');
end
new{1} = [txt,get(config.scnl(m),'station'),':',...
              get(config.scnl(m),'channel'),' on ',datestr(config.day(n))];
str = [new;str];
set(handles.disp_txt,'String',str)
pause(.1)


