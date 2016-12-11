% SOME SCRIPTS

%% BUILD 3-COMPONENT VECTORS
for n = 1:446, 
   try
      F_RD01(1,n) = get_red_w('rd01:bhz',sst(n,1),sst(n,2),1);
   catch
      F_RD01(1,n) = waveform;
   end
   
   try
      F_RD01(2,n) = get_red_w('rd01:bhe',sst(n,1),sst(n,2),1);
   catch
      F_RD01(2,n) = waveform;
   end
   
   try
      F_RD01(3,n) = get_red_w('rd01:bhn',sst(n,1),sst(n,2),1);
   catch
      F_RD01(3,n) = waveform;
   end
end

%% 
for n = 1:length(r)
      if cc(r(n))>cc(r(n)+1)
         tt(r(n)+1) = NaN;
         cc(r(n)+1) = NaN;
      else
         tt(r(n)) = NaN;
         cc(r(n)) = NaN;
      end
end

%% REMOVE SMALLER RMS EVENTS THAT OVERLAP
for n = 1:length(wfa_512)-1
   if get(wfa_512(n),'end')>get(wfa_512(n+1),'start')
      if rms(wfa_512(n))>rms(wfa_512(n+1))
         wfa_512(n+1) = [];
      else
         wfa_512(n) = [];
      end
   end
end

%%
for n = 651:1631
   try
   w_rdwb(n) = get_red_w('rdwb:bhz',sst(n,1),sst(n,2),1);
   catch
   w_rdwb(n) = waveform;
   end
   %rmsa(n) = rms(w);
   %pf(n) = peak_freq(w,'val');
   %fi(n) = freq_index(w,[1 4],[8 25],'val');
   %if rem(n,500)==0
      %pause(5)
   %end
end

%% 
for n = 1:170
   load(['Corr',num2str(n,'%03.0f'),'.mat'])
   save(['cc',num2str(n,'%03.0f'),'.mat'],'c')
   clear c
end

%% Check that WFA Blocks only contain one station
for n = 1:172
   load(['Block',num2str(n,'%03.0f'),'.mat'])
   d = []; 
   for m = 2:1000 
      if ~strcmp(get(b(m),'station'),get(b(m-1),'station')) 
         d = [d m+(n-1)*1000];
      end 
   end
end


%% XCORR blocks
for n = 1:171
   w = [];
   load(['Block',num2str(n,'%03.0f'),'.mat'])
   w = b; clear b
   load(['Block',num2str(n+1,'%03.0f'),'.mat'])
   w = [w b]; clear b
   c = correlation(w);
   c = taper(c);
   c = butter(c,[1 10]);
   c = xcorr(c,[-1,5]);
   c = sort(c);
   c = adjusttrig(c,'MIN');
   c = linkage2(c);
   c = cluster(c,.7);
   save(['Corr',num2str(n,'%03.0f'),'.mat'],'c')
   clear w c
   pack
end

%% Reshape WFA Daily detections into blocks of length 1000
% First remove waveforms that are spaced too closely

bn = 1; %block number
r = []; %waveform repository
d1 = datenum([2008 07 01]);
d2 = datenum([2009 12 31]);
for day = d1:d2
   try
   load([datestr(day,29),'.mat'])
   if size(wfa,1)>1
      wfa = wfa';
   end
   r = [r wfa]; clear wfa
   if length(r)>1000
      b = r(1:1000);
      save(['Block',num2str(bn,'%03.0f'),'.mat'],'b')
      bn = bn+1;
      clear b
      r(1:1000)=[];
   end
   catch
   end
end

%%
k = 1
rdwb_wfa = [];
for n=1:size(sst,1)
   w = get_red_w('rdwb:bhz',sst(n,1)-1/24/60/60,sst(n,1)+7/24/60/60,0);
   if ~isempty(w)
      rdwb_wfa(k) = [rdwb_wfa w];%%%%
      k=k+1
   end
end

% clust_fam
c = correlation(rdwb_wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
c = cluster(c,clust_val);
stat = getclusterstat(c);
k = 1;
while stat.numel(k)>=5
   cc = correlation(rdwb_wfa(stat.index{k}));%%%%
   cc = taper(cc);
   cc = butter(cc,[1 10]);
   cc = xcorr(cc,[-1,5]);
   cc = adjusttrig(cc,'MIN');
   t = get(cc,'trig')
   for n=1:stat.numel(k)
      rdwb_fam{k}(n) = get_red_w('rdwb',t(n)-1/24/60/60,t(n)+7/24/60/60,0);%%%%
   end
   k=k+1;
end
clear k t n cc stat

%% Family reference cell array 'F' and start/stop time array 'sst'
s2d = 1/24/60/60;
k = 1;
n = 1475;
for m = 1:length(F{1,n})
   k = F{1,n}(m);
   Fam.wave{n}(m) = get_red_w('rso',sst(k,1)-s2d,sst(k,2)+7*s2d,0);
end

c = correlation(Fam.wave{n});
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
trig = get(c,'trig');
for m = 1:length(F{1,n})
   k = F{1,n}(m);
   Fam.wave{n}(m) = get_red_w('rso',trig(m)-2*s2d,trig(m)+6*s2d,0);
end

plotm2(Fam.wave{n})
esam(Fam.wave{n});
plot(c,'corr')
clear trig n m k

%%
N = 21;
plotm2(Fam.wave{N})
esam(Fam.wave{N});
plot(c,'corr')
clear N

%%
close all

%%
N = 1;
plotm2(C.w{N})
esam(C.w{N});
plot(C.clust(N),'corr')
clear N

%% THIS DOES SOMETHING
d1 = [2009 03 20 14];
d2 = [2009 03 20 16];
w = get_red_w('ref:ehz',d1,d2,1);
sub_sst = extract_sst(sst,get(w,'start'),get(w,'end'));
c = sub_sst; 
c = event_pick(w,'e_sst',c);
sub_sst = c{:};
sst = add_sst(sst,sub_sst,1);

%% SST2WFA
%N = 2172;
%for n = 1:N
k=1;
for n = 1:length(sst)
   wfa(n) = get_red_w('ref:ehz',sst(k,1),sst(k,2),0);
end

%% MAX EVENT RATE (10 Min)

d1 = datenum([2009 05 02 20 40 00]);
d2 = datenum([2009 05 08 05 20 00]);
cnt = []; 
inc = 10/24/60;
for d=d1:inc:d2
   sub_sst = extract_sst(sst,d,d+inc);
   cnt = [cnt; d, size(sub_sst,1)];
end

%% MAX EVENT RATE (FIND HIGHEST 1 HOUR WINDOW FROM 10 MINUTE BINS)
bin = 6;
max_d = 0;
max_r = 0;
for n =1:size(cnt,1)-bin+1
   x = sum(cnt(n:n+bin-1,2));
   if x>max_r
      max_d = cnt(n);
      max_r = x;
   end
end

%% OPEN ALL SST FILES AND EXTRACT WFA FROM DAILY WAVEFORMS (RSO)
d1 = datenum([2008 01 01 00 00 00]);
d2 = datenum([2009 03 24 00 00 00]);
wfa = [];
f1 = fullfile('C:','Documents and Settings','dketner','Desktop',...
   'RED_Events','STA_LTA_Daily','RSO','SST_002');
for day=d1:d2
   try
      w = get_red_w('rso',day,day+1,0);
      load(fullfile(f1,[datestr(day,29),'.mat']))
      wfa = [wfa sst2wfa(sst,w)];
   catch
   end
end

%% SET ALL EVENT WAVEFORMS ABOVE TO SPAN 1s BEFORE, 9s AFTER TRIGGER_ON
%% THIS BROUGHT SYSTEM MEMORY TO ITS KNEES
for n=1:length(wfa)
   try
      wfa(n) = get_red_w('rso',get(wfa(n),'start')-1/24/60/60,get(wfa(n),'start')+9/24/60/60,0);
   catch
      pause(30)
      try
         wfa(n) = get_red_w('rso',get(wfa(n),'start')-1/24/60/60,get(wfa(n),'start')+9/24/60/60,0);
      catch
         pause(60)
         wfa(n) = get_red_w('rso',get(wfa(n),'start')-1/24/60/60,get(wfa(n),'start')+9/24/60/60,0);
      end
   end
end

F = multiplet(wfa);

%% ATTEMPT TO BREAK BIG WFA INTO BLOCKS OF 2000, MEMORY FAIL
path = fullfile('C:','Documents and Settings','dketner','Desktop',...
   'RED_Events','STA_LTA_Daily','RSO','WFA_002');
for n = 1:48
   wfa = rso_wfa((n-1)*2000+1:n*2000);
   save(fullfile(path,['WFA_',num2str(n,'%03.0f'),'.mat']),'wfa')
end

%% LOAD DAY-LONG HELICORDER
w = get_red_w('ref:ehz',[2009 03 25],[2009 03 26],1);
build(helicorder(w,'mpl',30))

%% MANUALLY PICK SST OVER N hour block
N = 3;
d = [2009 03 25 00 00 00];
w = get_red_w('ref:ehz',datenum(d),datenum(d)+N/24,1);
sub_sst = event_pick(w);
sub_sst = sub_sst{:};
sst = add_sst(sst,sub_sst,'merge');

%% For a given day, grab a subset of sst occuring on that day, convert the 
%% subset to wfa, cross-correlate, and plot it on a day-long helicorder.
%% (generates multiple helicorders: multi-e_sst helicorder function not yet 
%% implemented)
day = datenum([2009 01 25 00 00 00]);
sub_sst = extract_sst(sst,day,day+1);
sub_w = get_red_w('ref:ehz',day,day+1,0);
sub_wfa = sst2wfa(sub_sst,sub_w);
C = clust_fam(sub_wfa,.7);
for n = 1:1
   build(helicorder(sub_w,'mpl',30,'e_sst',wfa2sst(get(C.clust(n),'waveform'))))
end

%% LOAD ALL ARCHIVED EVENTS AND COMBINE EVENT OPS
big_sst = [];
big_fi = [];
big_rms = [];
big_pf = [];
big_pa = [];
d1 = datenum([2009 02 28 00 00 00]);
d2 = datenum([2009 11 17 00 00 00]);
for day = d1:d2
   try
      f = fullfile('C:','Work','RED_Events','STA_LTA_Daily',...
         'RDWB','SST_001',[datestr(day,29),'.mat']);
      load(f);
      big_sst = [big_sst; sst];
      big_fi = [big_fi; fi];
      big_rms = [big_rms; rms];
      big_pf = [big_pf; pf];
      big_pa = [big_pa; pa];
      clear sst fi rms pf pa
   catch
   end
end
clear d1 d2 day f
      
%% LOAD EVENT TIMES FROM 'SST' (SINGLE LIST) ONE AT A TIME INTO EVENT_PICK
%% AND STORE ALL PICKED WAVEFORMS FROM ALL VERTICAL COMPONENT CHANNELS IN A 
%% LONG MIXED-STATION ARRAY 'WFA'
wfa = [];
for n = 1:20 
w = get_red_w('z',sst(n,1)-20/24/60/60,sst(n,2)+20/24/60/60,1);
clc
pick_sst = event_pick(w);
for m = 1:length(pick_sst)
   if ~isempty(pick_sst{m})
      wfa = [wfa sst2wfa(pick_sst{m},w(m))];
   end
end
end

%% LOAD WAVEFORMS OF DETECTED EVENTS
d_start = datenum([2009 01 01 00 00 00]);
d_end = datenum([2009 03 01 00 00 00]);
f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','STA_LTA_Daily','REF','SST_002');
wfa = [];
for day = d_start:d_end
   open(fullfile(f,[datestr(day,29),'.mat']))
   w = get_red_w('ref:ehz',day,day+1,1);
   wfa = [wfa sst2wfa(sst,w)];
end