%%



%%
f = fullfile('C:','Work','Iliamna','Single_Station_Detection','ILW','Block_Correlation');
cd(f)

%% 13
wb = waitbar(0); 
for n = 1:822
    waitbar(n/1000,wb) 
    wfa(n) = get_w(ds,scnl,...
             get(wfa(n),'start')-1/24/60/60,...
             get(wfa(n),'start')+9/24/60/60,'none',1); 
end

clear n wb

%%
load('WFA_BLOCK_001.mat');
W = wfa; clear wfa
load('WFA_BLOCK_002.mat');
W = [W; wfa]; clear wfa
C001 = correlation(W); clear W
C001 = set(C001,'trig',get(C001,'start')+1/24/60/60)
C001 = taper(C001);
C001 = butter(C001,[1 10]);
C001 = xcorr(C001,[-.5,7.5]);
C001 = sort(C001);
C001 = adjusttrig(C001,'MIN');
C001 = linkage2(C001);
save('C001.mat','C001')
clear C001

load('WFA_BLOCK_002.mat');
W = wfa; clear wfa
load('WFA_BLOCK_003.mat');
W = [W; wfa]; clear wfa
C002 = correlation(W); clear W
C002 = set(C002,'trig',get(C002,'start')+1/24/60/60)
C002 = taper(C002);
C002 = butter(C002,[1, 10]);
C002 = xcorr(C002,[-.5,7.5]);
C002 = sort(C002);
C002 = adjusttrig(C002,'MIN');
C002 = linkage2(C002);
save('C002.mat','C002')
clear C002

load('WFA_BLOCK_003.mat');
W = wfa; clear wfa
load('WFA_BLOCK_004.mat');
W = [W; wfa]; clear wfa
C003 = correlation(W); clear W
C003 = set(C003,'trig',get(C003,'start')+1/24/60/60)
C003 = taper(C003);
C003 = butter(C003,[1, 10]);
C003 = xcorr(C003,[-.5,7.5]);
C003 = sort(C003);
C003 = adjusttrig(C003,'MIN');
C003 = linkage2(C003);
save('C003.mat','C003')
clear C003

load('WFA_BLOCK_004.mat');
W = wfa; clear wfa
load('WFA_BLOCK_005.mat');
W = [W; wfa]; clear wfa
C004 = correlation(W); clear W
C004 = set(C004,'trig',get(C004,'start')+1/24/60/60)
C004 = taper(C004);
C004 = butter(C004,[1, 10]);
C004 = xcorr(C004,[-.5,7.5]);
C004 = sort(C004);
C004 = adjusttrig(C004,'MIN');
C004 = linkage2(C004);
save('C004.mat','C004')
clear C004

load('WFA_BLOCK_005.mat');
W = wfa; clear wfa
load('WFA_BLOCK_006.mat');
W = [W; wfa]; clear wfa
C005 = correlation(W); clear W
C005 = set(C005,'trig',get(C005,'start')+1/24/60/60)
C005 = taper(C005);
C005 = butter(C005,[1, 10]);
C005 = xcorr(C005,[-.5,7.5]);
C005 = sort(C005);
C005 = adjusttrig(C005,'MIN');
C005 = linkage2(C005);
save('C005.mat','C005')
clear C005

load('WFA_BLOCK_006.mat');
W = wfa; clear wfa
load('WFA_BLOCK_007.mat');
W = [W; wfa]; clear wfa
C006 = correlation(W); clear W
C006 = set(C006,'trig',get(C006,'start')+1/24/60/60)
C006 = taper(C006);
C006 = butter(C006,[1, 10]);
C006 = xcorr(C006,[-.5,7.5]);
C006 = sort(C006);
C006 = adjusttrig(C006,'MIN');
C006 = linkage2(C006);
save('C006.mat','C006')
clear C006

load('WFA_BLOCK_007.mat');
W = wfa; clear wfa
load('WFA_BLOCK_008.mat');
W = [W; wfa]; clear wfa
C007 = correlation(W); clear W
C007 = set(C007,'trig',get(C007,'start')+1/24/60/60)
C007 = taper(C007);
C007 = butter(C007,[1, 10]);
C007 = xcorr(C007,[-.5,7.5]);
C007 = sort(C007);
C007 = adjusttrig(C007,'MIN');
C007 = linkage2(C007);
save('C007.mat','C007')
clear C007

load('WFA_BLOCK_008.mat');
W = wfa; clear wfa
load('WFA_BLOCK_009.mat');
W = [W; wfa]; clear wfa
C008 = correlation(W); clear W
C008 = set(C008,'trig',get(C008,'start')+1/24/60/60)
C008 = taper(C008);
C008 = butter(C008,[1, 10]);
C008 = xcorr(C008,[-.5,7.5]);
C008 = sort(C008);
C008 = adjusttrig(C008,'MIN');
C008 = linkage2(C008);
save('C008.mat','C008')
clear C008

load('WFA_BLOCK_009.mat');
W = wfa; clear wfa
load('WFA_BLOCK_010.mat');
W = [W; wfa]; clear wfa
C009 = correlation(W); clear W
C009 = set(C009,'trig',get(C009,'start')+1/24/60/60)
C009 = taper(C009);
C009 = butter(C009,[1, 10]);
C009 = xcorr(C009,[-.5,7.5]);
C009 = sort(C009);
C009 = adjusttrig(C009,'MIN');
C009 = linkage2(C009);
save('C009.mat','C009')
clear C009

load('WFA_BLOCK_010.mat');
W = wfa; clear wfa
load('WFA_BLOCK_011.mat');
W = [W; wfa]; clear wfa
C010 = correlation(W); clear W
C010 = set(C010,'trig',get(C010,'start')+1/24/60/60)
C010 = taper(C010);
C010 = butter(C010,[1, 10]);
C010 = xcorr(C010,[-.5,7.5]);
C010 = sort(C010);
C010 = adjusttrig(C010,'MIN');
C010 = linkage2(C010);
save('C010.mat','C010')
clear C010

load('WFA_BLOCK_011.mat');
W = wfa; clear wfa
load('WFA_BLOCK_012.mat');
W = [W; wfa]; clear wfa
C011 = correlation(W); clear W
C011 = set(C011,'trig',get(C011,'start')+1/24/60/60)
C011 = taper(C011);
C011 = butter(C011,[1, 10]);
C011 = xcorr(C011,[-.5,7.5]);
C011 = sort(C011);
C011 = adjusttrig(C011,'MIN');
C011 = linkage2(C011);
save('C011.mat','C011')
clear C011

load('WFA_BLOCK_012.mat');
W = wfa; clear wfa
load('WFA_BLOCK_013.mat');
W = [W; wfa]; clear wfa
C012 = correlation(W); clear W
C012 = set(C012,'trig',get(C012,'start')+1/24/60/60)
C012 = taper(C012);
C012 = butter(C012,[1, 10]);
C012 = xcorr(C012,[-.5,7.5]);
C012 = sort(C012);
C012 = adjusttrig(C012,'MIN');
C012 = linkage2(C012);
save('C012.mat','C012')
clear C012

load('WFA_BLOCK_013.mat');
W = wfa; clear wfa
load('WFA_BLOCK_014.mat');
W = [W; wfa]; clear wfa
C013 = correlation(W); clear W
C013 = set(C013,'trig',get(C013,'start')+1/24/60/60)
C013 = taper(C013);
C013 = butter(C013,[1, 10]);
C013 = xcorr(C013,[-.5,7.5]);
C013 = sort(C013);
C013 = adjusttrig(C013,'MIN');
C013 = linkage2(C013);
save('C013.mat','C013')
clear C013
%%
load('C001')
C001 = cluster(C001,.75);
stat001 = getclusterstat(C001);
ind = stat001.index;
clear C001

load('C002')
C002 = cluster(C002,.75);
stat002 = getclusterstat(C002);
ind_002 = stat002.index;
for n=1:length(ind_002), ind_002{n}=ind_002{n}+1000; end
clear C002

load('C003')
C003 = cluster(C003,.75);
stat003 = getclusterstat(C003);
ind_003 = stat003.index;
for n=1:length(ind_003), ind_003{n}=ind_003{n}+2000; end
clear C003

load('C004')
C004 = cluster(C004,.75);
stat004 = getclusterstat(C004);
ind_004 = stat004.index;
for n=1:length(ind_004), ind_004{n}=ind_004{n}+3000; end
clear C004

load('C005')
C005 = cluster(C005,.75);
stat005 = getclusterstat(C005);
ind_005 = stat005.index;
for n=1:length(ind_005), ind_005{n}=ind_005{n}+4000; end
clear C005

load('C006')
C006 = cluster(C006,.75);
stat006 = getclusterstat(C006);
ind_006 = stat006.index;
for n=1:length(ind_006), ind_006{n}=ind_006{n}+5000; end
clear C006

load('C007')
C007 = cluster(C007,.75);
stat007 = getclusterstat(C007);
ind_007 = stat007.index;
for n=1:length(ind_007), ind_007{n}=ind_007{n}+6000; end
clear C007

load('C008')
C008 = cluster(C008,.75);
stat008 = getclusterstat(C008);
ind_008 = stat008.index;
for n=1:length(ind_008), ind_008{n}=ind_008{n}+7000; end
clear C008

load('C009')
C009 = cluster(C009,.75);
stat009 = getclusterstat(C009);
ind_009 = stat009.index;
for n=1:length(ind_009), ind_009{n}=ind_009{n}+8000; end
clear C009

load('C010')
C010 = cluster(C010,.75);
stat010 = getclusterstat(C010);
ind_010 = stat010.index;
for n=1:length(ind_010), ind_010{n}=ind_010{n}+9000; end
clear C010

load('C011')
C011 = cluster(C011,.75);
stat011 = getclusterstat(C011);
ind_011 = stat011.index;
for n=1:length(ind_011), ind_011{n}=ind_011{n}+10000; end
clear C011

load('C012')
C012 = cluster(C012,.75);
stat012 = getclusterstat(C012);
ind_012 = stat012.index;
for n=1:length(ind_012), ind_012{n}=ind_012{n}+11000; end
clear C012

load('C013')
C013 = cluster(C013,.75);
stat013 = getclusterstat(C013);
ind_013 = stat013.index;
for n=1:length(ind_013), ind_013{n}=ind_013{n}+12000; end
clear C013

%%

load('C005')
C005 = cluster(C005,.75);
stat005 = getclusterstat(C005);
ind_005 = stat005.index;
for n=1:length(ind_005), ind_005{n}=ind_005{n}+4000; end
clear C005

load('C006')
C006 = cluster(C006,.75);
stat006 = getclusterstat(C006);
ind_006 = stat006.index;
for n=1:length(ind_006), ind_006{n}=ind_006{n}+5000; end
clear C006

load('C007')
C007 = cluster(C007,.75);
stat007 = getclusterstat(C007);
ind_007 = stat007.index;
for n=1:length(ind_007), ind_007{n}=ind_007{n}+6000; end
clear C007

load('C008')
C008 = cluster(C008,.75);
stat008 = getclusterstat(C008);
ind_008 = stat008.index;
for n=1:length(ind_008), ind_008{n}=ind_008{n}+7000; end
clear C008

%% IMPROVED CODE FOR MERGING WAVEFORM BLOCKS!

tic

cind = ind_013;
off = 12000;

for n = 1:length(cind)
   over = 0;
   for m = 1:length(ind)
      noe = length(intersect(cind{n},ind{m})); % Number of overlapping events
      if noe > over
         over = noe;
         ref = m;
         pol = noe/sum(ind{m}>off);% Percentage of overlapping events
      end
   end
   if over > 4 && pol > .4
      ind{ref} = [ind{ref};cind{n}];
      ind{ref} = unique(sort(ind{ref}));
   else
      ind{end+1} = cind{n};
   end
end
toc

%%
for n = 1:length(ind)
   L(n) = numel(ind{n});
end
[V I] = sort(L);

%% CORRELATE ALL FAMILY TO GET TRIG TIMES
for n = 1:numel(ind)
    disp(num2str(n))
c = correlation(W(ind{n}))
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-.5,7.5]);
c = sort(c);
c = adjusttrig(c,'MIN');
trig = get(c,'trig');
for m = 1:length(trig)
   F{n}(1,m)=get_w(ds,scnl,trig(m)-2/24/60/60,trig(m)+8/24/60/60,'none',0);
end
end

%% BUILD FAMILY WAVEFORM STRUCTURE WITH MANUALLY SELECTED TIME WINDOW
%F{n} = waveform;
for m = 1:length(trig)
   F{n}(1,m)=get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+8/24/60/60,1);
end
figure, plot(stack(F{n}))
grid on
plot(c,'corr')

%% MAKE CUT BASED ON MINIMUM CUMULATIVE CORR
clear cut
csum = sum(get(c,'corr')); 
[cut(:,1) cut(:,2)] = sort(csum); 
clear csum

%% CUT MINIMUM
cut = cut(1:27,2);
ind{n}(cut) = [];

%% CUT SELECTION
ind{n}(1) = [];

%% DELETE
ind(n) = [];
F(n) = [];

%% BIN CORRELATE ALL WAVEFORMS IN LARGE FAMILY
for n=9:10
   if n<10
      sub = F{1}(1+(n-1)*500:n*500);
   else
      sub = F{1}(1+(n-1)*500:end);
   end
   c = correlation(sub);
   c = taper(c);
   c = butter(c,[1 10]);
   c = xcorr(c,[-1,5]);
   c = sort(c);
   c = adjusttrig(c,'MIN');
   trig = get(c,'trig');
   for m=1:length(trig)
      sub(m) = get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+6/24/60/60,0);
   end
   if n<10
      F{1}(1+(n-1)*500:n*500) = sub;
   else
      F{1}(1+(n-1)*500:end) = sub;
   end
end

