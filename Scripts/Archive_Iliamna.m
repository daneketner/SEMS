
%% NEW EVENT DETECTION PROJECT
%  INCLUDES:
%     DAILY STA/LTA EVENT DETECTION
%     DAILY HELICORDER
%     DAILY EVENT METRICS
%     FAMILY DETECTION

%% CREATE NEW LOG STRUCTURE
%  THIS WILL CONTAIN ALL INFO CONCERNING THE EVENT DETECTION PROJECT
%  DETAILS AND PROGRESS
log = [];

%% SCNL
%  Currently set up to point at Iliamna stations 'IVE', 'ILW', and 'ILS'
log.scnl(1) = scnlobject('IVE','EHZ','AV');
log.scnl(2) = scnlobject('ILW','EHZ','AV');
log.scnl(3) = scnlobject('ILS','EHZ','AV');


%% f IS THE ROOT DIRECTORY OF ALL THINGS TO BE SAVED - CHOOSE f WISELY
%  IF f DOES NOT EXIST, CREATE IT
log.root = fullfile('C:','Work','Iliamna','Single_Station_Detection_3');
if exist(log.root) ~= 7
   mkdir(log.root)
end
cd(log.root);

%% CHECK FILE STRUCTURE - CREATE IF DOESN'T EXIST
for n = 1:numel(log.scnl)
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'wfa_day'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'wfa_day'))
   end
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'metric_day'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'metric_day'))
   end   
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'helicorder'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'helicorder')) 
   end
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'wfa_block'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'wfa_block'))
   end
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'corr_block'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'corr_block'))
   end
   if exist(fullfile(log.root,get(log.scnl(n),'station'),'fam_clust'))~=7
      mkdir(fullfile(log.root,get(log.scnl(n),'station'),'fam_clust'))
   end
end

%% SET DATASOURCE
host = 'avowinston01.wr.usgs.gov';
%host = 'pubavo1.wr.usgs.gov';
port = 16022;
log.ds = datasource('winston',host,port);

%% TIME RANGE
log.start = floor(datenum([2012 1 1 0 0 0]));
log.end = ceil(datenum([2012 10 30 0 0 0]));
log.dur = log.end - log.start + 1;
log.day = (log.start : log.end)';

%% EVENT DETECTION PARAMETERS
log.edp = [.8 7 2 1.5 0 2];

%%
h = log.dur;
w = numel(log.scnl);
log.wavefetch = nan(h,w);
log.eventcount = nan(h,w);
log.daycnt = [];
log.scnlcnt = [];
log.cc = .75;
log.blocksize = 500;
log.blockcnt = zeros(1,size(log.scnl));

%% LOOP OVER ALL DAYS FOR ALL SCNL -->
%  DETECT EVENTS
%  COMPUTE METRICS
%  BUILD/SAVE HELICORDERS
try
for n = 1:numel(log.day)      % LOOP OVER DATE RANGE
   for m = 1:numel(log.scnl)  % LOOP OVER SCNL
      log.daycnt = n;
      log.scnlcnt = m;
      disp(['Currently looking at ', get(log.scnl(m),'station'),':',...
             get(log.scnl(m),'channel'),' on ',datestr(log.day(n))])
      disp('fetching waveform')
      w = get_w(log.ds,log.scnl(m),log.day(n),log.day(n)+1);
      if ~isempty(w)
         log.wavefetch(n,m) = 1;
         w = filt(w,'bp',[1 10]);
         w = zero2nan(w,5);
         disp('detecting events')
         wfa_day = sta_lta(w,'edp',log.edp,'lta_mode','grow','eot','wfa',...
                        'fix',9,'pad',[1 0]);
         if ~isempty(wfa_day)
            cd(fullfile(log.root,get(log.scnl(m),'station'),'wfa_day'))
            disp('saving events')
            save([datestr(log.day(n),29),'.mat'],'wfa_day')
            log.eventcount(n,m) = numel(wfa_day);
            disp('computing metrics')
            metric_day.start = get(wfa,'start')
            metric_day.rms = rms(wfa_day);
            metric_day.pa = peak_amp(wfa_day,'val');
            metric_day.p2p = peak2peak_amp(wfa_day,'val');
            metric_day.pf = peak_freq(wfa_day,'val');
            metric_day.fi = freq_index(wfa_day,[1 3],[8 15],'val');
            metric_day.mf = middle_freq(wfa_day,'val');
            disp('saving metrics')
            cd(fullfile(log.root,get(log.scnl(m),'station'),'metric_day'))
            save([datestr(log.day(n),29),'.mat'],'metric_day')
            disp('building helicorder')
            fh = build(helicorder(w,'mpl',30,'e_sst',wfa2sst(wfa_day)));
            set(fh,'PaperType','A','PaperOrientation','portrait',...
               'PaperUnits','normalized','PaperPosition',[0,0,1,1])
            print(fh, '-dpng', fullfile(log.root,get(log.scnl(m),'station'),...
               'Helicorder',datestr(log.day(n),29)))
            close(fh)
            clear w wfa metric_day
            pack
         else
            disp(['No events detected from ', get(log.scnl(m),'station'),...
               ':', get(log.scnl(m),'channel'),' on ',datestr(log.day(n))])
            wfa_day = waveform(); 
            wfa_day(:) = [];
            metric.start = [];
            metric.rms = [];
            metric.pa = [];
            metric.p2p = [];
            metric.pf = [];
            metric.fi = [];
            metric.mf = [];
            disp('saving no events')
            cd(fullfile(log.root,get(log.scnl(m),'station'),'wfa_day'))
            save([datestr(log.day(n),29),'.mat'],'wfa_day')
            disp('building helicorder')
            fh = build(helicorder(w,'mpl',30));
            set(fh,'PaperType','A','PaperOrientation','portrait',...
               'PaperUnits','normalized','PaperPosition',[0,0,1,1])
            print(fh, '-dpng', fullfile(log.root,get(log.scnl(m),'station'),...
               'Helicorder',datestr(log.day(n),29)))
            close(fh)
            clear w wfa metric
            pack
         end
      else % Unable to fetch waveform
         log.wavefetch(n,m) = 0;
         log.eventcount(n,m) = 0;
         disp(['No waveform available for ', get(scnl(m),'station'),...
            ':', get(scnl(m),'channel'),' on ',datestr(day)])
      end
   end
end

%% CONVERT DAILY WAVEFORMS TO WAVEFORM BLOCKS

log =  wfa_day2block(log)

%% CROSS-CORRELATE PAIRS OF WAVEFORM BLOCKS

log = wfablock2corrblock(log)

%% CROSS-CORRELATION BLOCKS TO FAMILY CLUSTER

log = corrblock2clust(log)

%%
catch
   cd log.root
   save log
end







