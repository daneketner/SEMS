
%%
C001 = taper(C001);
C001 = butter(C001,[1 10]);
C001 = xcorr(C001,[-1,5]);
C001 = sort(C001);
C001 = adjusttrig(C001,'MIN');
C001 = linkage2(C001);

C002 = taper(C002);
C002 = butter(C002,[1 10]);
C002 = xcorr(C002,[-1,5]);
C002 = sort(C002);
C002 = adjusttrig(C002,'MIN');
C002 = linkage2(C002);

C003 = taper(C003);
C003 = butter(C003,[1 10]);
C003 = xcorr(C003,[-1,5]);
C003 = sort(C003);
C003 = adjusttrig(C003,'MIN');
C003 = linkage2(C003);

C004 = taper(C004);
C004 = butter(C004,[1 10]);
C004 = xcorr(C004,[-1,5]);
C004 = sort(C004);
C004 = adjusttrig(C004,'MIN');
C004 = linkage2(C004);

C005 = taper(C005);
C005 = butter(C005,[1 10]);
C005 = xcorr(C005,[-1,5]);
C005 = sort(C005);
C005 = adjusttrig(C005,'MIN');
C005 = linkage2(C005);

C006 = taper(C006);
C006 = butter(C006,[1 10]);
C006 = xcorr(C006,[-1,5]);
C006 = sort(C006);
C006 = adjusttrig(C006,'MIN');
C006 = linkage2(C006);

%%
C001 = cluster(C001,.75);
C002 = cluster(C002,.75);
C003 = cluster(C003,.75);
C004 = cluster(C004,.75);
C005 = cluster(C005,.75);
C006 = cluster(C006,.75);

%%
stat001 = getclusterstat(C001);
stat002 = getclusterstat(C002);
stat003 = getclusterstat(C003);
stat004 = getclusterstat(C004);
stat005 = getclusterstat(C005);
stat006 = getclusterstat(C006);

%%
ind = stat001.index;
ind_002 = stat002.index;
ind_003 = stat003.index;
ind_004 = stat004.index;
ind_005 = stat005.index;
ind_006 = stat006.index;

%%
for n=1:length(ind_002), ind_002{n}=ind_002{n}+1000; end
for n=1:length(ind_003), ind_003{n}=ind_003{n}+2000; end
for n=1:length(ind_004), ind_004{n}=ind_004{n}+3000; end
for n=1:length(ind_005), ind_005{n}=ind_005{n}+4000; end
for n=1:length(ind_006), ind_006{n}=ind_006{n}+5000; end

%%
cind = ind_006;
for n = 1:length(cind)
   over = 0;
   for m = 1:length(ind)
      noe = length(intersect(cind{n},ind{m}));
      if noe > over
         over = noe;
         ref = m;
      end
   end
   if over > 0
      ind{ref} = [ind{ref};cind{n}];
      ind{ref} = unique(sort(ind{ref}));
   else
      ind{end+1} = cind{n};
   end
end

%%
for n = 1:length(ind)
   L(n) = numel(ind{n});
end
[V I] = sort(L);

%% CORRELATE ALL FAMILY TO GET TRIG TIMES
n=20; 
c = correlation(F{20});
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
trig = get(c,'trig');

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

