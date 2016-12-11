
%%
F.cc = 0.75;
F.ind = []; % Family member indices array
wb = waitbar(0);
n=1;
load(['cc',num2str(n,'%03.0f'),'.mat'])
F.ind = block_clust(c,F.ind,n,1000,.75);
st = get(c,'start');
waitbar(n/171,wb,['Working on block ',num2str(n)])
for n=2:171
   load(['cc',num2str(n,'%03.0f'),'.mat'])
   F.ind = block_clust(c,F.ind,n,1000,.75);
   t = get(c,'start');
   st = [st; t(1001:end)];
   waitbar(n/171,wb,['Working on block ',num2str(n)])
end


%% Build Family Indicies for array of correlation values
wb = waitbar(0);
F.cc = .50:.01:.99;

for n=1:numel(F.cc)
   waitbar(n/numel(F.cc),wb)
   F.ind{n} = []; % Family member indices array
   F.ind{n} = block_clust(C001,F.ind{n},1,1000,F.cc(n));
   F.ind{n} = block_clust(C002,F.ind{n},2,1000,F.cc(n));
   F.ind{n} = block_clust(C003,F.ind{n},3,1000,F.cc(n));
   F.ind{n} = block_clust(C004,F.ind{n},4,1000,F.cc(n));
   F.ind{n} = block_clust(C005,F.ind{n},5,1000,F.cc(n));
   F.ind{n} = block_clust(C006,F.ind{n},6,1000,F.cc(n)); 
   F.ind{n} = block_clust(C007,F.ind{n},7,1000,F.cc(n));
   F.ind{n} = block_clust(C008,F.ind{n},8,1000,F.cc(n));
   F.ind{n} = block_clust(C009,F.ind{n},9,1000,F.cc(n));
   F.ind{n} = block_clust(C010,F.ind{n},10,1000,F.cc(n));
   F.ind{n} = block_clust(C011,F.ind{n},11,1000,F.cc(n));
   F.ind{n} = block_clust(C012,F.ind{n},12,1000,F.cc(n)); 
   F.ind{n} = block_clust(C013,F.ind{n},13,1000,F.cc(n));
   F.ind{n} = block_clust(C014,F.ind{n},14,1000,F.cc(n));
%    F.ind{n} = block_clust(C015,F.ind{n},15,1000,F.cc(n));
%    F.ind{n} = block_clust(C016,F.ind{n},16,1000,F.cc(n));
end

%% Build Family Indicies for array of correlation values

wfa = [w1 w2];
c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
C001 = c;

wfa = [w2 w3];
c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
C002 = c;

wfa = [w3 w4];
c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
C003 = c;

wb = waitbar(0);
F.cc = .50:.01:.99;
for n=1:numel(F.cc)
   waitbar(n/numel(F.cc),wb)
   F.ind{n} = []; % Family member indices array
   F.ind{n} = block_clust(C001,F.ind{n},1,1007,F.cc(n));
   F.ind{n} = block_clust(C002,F.ind{n},2,1007,F.cc(n));
   F.ind{n} = block_clust(C003,F.ind{n},3,1007,F.cc(n));
end

%%
F.cc = .50:.01:.99;
for n=1:numel(F.cc)
   F.ind{n} = []; % Family member indices array
   F.ind{n} = block_clust(c,F.ind{n},1,655,F.cc(n));
end

%% Remove Events Outside of Range
first = 51847;
last = 130118;
for n=1:length(F.ind) % Number of CC values
   for m = 1:numel(F.ind{n}) % Number of families
      F.ind{n}{m} = F.ind{n}{m}(F.ind{n}{m}>=first & F.ind{n}{m}<=last); 
   end

%% Remove Events Outside of Range
first = 51847;
last = 130118;
for n=1:length(F.ind) % Number of CC values
   for m = 1:numel(F.ind{n}) % Number of families
      F.ind{n}{m} = F.ind{n}{m}(F.ind{n}{m}>=first & F.ind{n}{m}<=last); 
   end
end

%% Reset First Index to 1 after Event Removal
for n=1:length(F.ind) % Number of CC values
   for m = 1:numel(F.ind{n}) % Number of families
      F.ind{n}{m} = F.ind{n}{m}-982; 
   end
end

%% Build Family Size array for each cc value
for n=1:length(F.ind) % Number of CC values
   for m = 1:numel(F.ind{n}) % Number of families
      F.size{n}(m) = length(F.ind{n}{m}); % Number of events in family
   end
end

%% Rearrange F in descending order according to family size
for n=1:length(F.ind) % Number of CC values
   [val pos]=sort(F.size{n},'descend');
   F.ind{n} = F.ind{n}(pos);
   F.size{n} = F.size{n}(pos);
   for m = 1:numel(F.ind{n}) % Number of families
      F.ind{n}{m}=sort(F.ind{n}{m});
   end
end
clear k m n pos val

%% Remove Families smaller than minimum size (x)
x = 5;
for n=1:length(F.ind) % Number of CC values
   F.ind{n} = F.ind{n}(F.size{n}>=x);
end
clear k m n pos val

%% Plot CC vs number of families for various minimum family sizes (R)
figure, hold on
for R = [2,3,4,5,6,7,8,10,12,15,18,23,30]
   cnt = zeros(1,length(F.cc));
   for n=1:length(F.cc)
      for m = 1:numel(F.ind{n})   % Number of families
         if numel(F.ind{n}{m})>=R
            cnt(n) = cnt(n)+1;
         end
      end
   end
   plot(F.cc,cnt)
end
clear R cnt n m

%% Plot CC vs total number of family waveforms
figure, hold on
for n=1:length(F.cc) % Number of CC values
   cnt = 0;
   for m = 1:numel(F.ind{n})  % Number of families
      k = numel(F.ind{n}{m}); % Number of events in family
      if rem(m,2)==0
      rectangle('Position',[F.cc(n)-.005,cnt,.01,k],'FaceColor',[1 1 0]) 
      else
      rectangle('Position',[F.cc(n)-.005,cnt,.01,k],'FaceColor',[1 1 1])
      end
      cnt = cnt+k;
   end    
end
clear cnt k m n

%% Fray Plot
F.pos = cell(1,length(F.ind));
F.off = cell(1,length(F.ind));
F.par = cell(1,length(F.ind));
fpf = figure;
ah = axes;
hold on
F.off{1}(1) = 0;
for m = 1:numel(F.ind{1})
   ii = abs(F.cc(2)-F.cc(1));
   F.pos{1}(m,:) = [F.cc(1)-ii/2,F.off{1}(m),ii,F.size{1}(m)];
   rectangle('Position',F.pos{1}(m,:),'FaceColor',[.5 .5 .5]) 
   F.off{1}(m+1) = F.off{1}(m) + length(F.ind{1}{m});
end

% SOME NOMENCLATURE: The x-axis displays incremental cc values moving from
% lower values at left side, to higher values at right side. Families often
% split apart into smaller branches as cc is shifted from lower to higher.
% Branches are considered 'siblings' immediately after such a split occurs.
% All siblings touch a common 'Parent' family. 
%
%  S     ___     TO ILLUSTRATE: A is the parent of B, B is the child of A.
%  i F  |   |___             C and D are siblings because they share a
%  Z a  |   |   |___ ___     common parent (B). F and G are also siblings
%  e m  | A | B |_C_|_E_|    of parent D. E has no siblings by contast, it 
%    i  |   |   | D |_F_|    has a unique parent (C). etc.
%  o l  |___|___|___|_G_| 
%  f y
%       CC Values increase -->

wb = waitbar(0);
for n=2:length(F.cc)
   waitbar(n/length(F.cc),wb)
   F.par{n} = [];
   % Loop builds parent cell array
   for m = 1:numel(F.ind{n}) % Number of families for nth cc value
      maxovr = 0;
      maxref=0;
      for k = 1:numel(F.ind{n-1})
         %  noe = Number of Overlapping Events
         noe = length(intersect(F.ind{n}{m},F.ind{n-1}{k})); 
         if noe > maxovr
            maxovr = noe;
            maxref = k;
         end
      end
      F.par{n} = [F.par{n} maxref];
   end
   % Loop builds sibling cell array
   for m = 1:numel(F.ind{n})
      try
      cpo = F.off{n-1}(F.par{n}(m));    % current parent offset
      cph = F.pos{n-1}(F.par{n}(m),4);  % current parent height
      cs = find(F.par{n}==F.par{n}(m)); % current siblings
      tsh = 0;                          % total sibling height
      for mm=1:length(cs)
         tsh = tsh + F.size{n}(cs(mm));
      end
      tso = cpo + (cph-tsh)/2;         % total sibling offset
      cso = 0;                         % current sibling offset
      for mm=1:find(cs==m)-1
         cso = cso + F.size{n}(cs(mm));
      end
      F.off{n}(m) = tso + cso;
      ii = abs(F.cc(2)-F.cc(1));
      F.pos{n}(m,:) = [F.cc(n)-ii/2,F.off{n}(m),ii,F.size{n}(m)];    
      rectangle('Position',F.pos{n}(m,:),'FaceColor',[.5 .5 .5])
      %line([F.pos{n}(m,1) F.pos{n}(m,1)],...
      %     [F.pos{n}(m,2) F.pos{n}(m,2)+F.pos{n}(m,4)],'Color',[1 1 1])
      catch
      end
   end
end
clear m maxovr maxref k noe ah cph cpo cs cso ii mm n tsh tso wb

%% FIND FAMILY FROM CASTLE PLOT
spf = figure; 
hold on
figure(fpf)
[c_clk y_clk] = ginput;
c_clk = round(100*c_clk)/100;
for n = 1:length(c_clk)
   N = find(c_clk(n) == F.cc);
   bot = F.pos{N}(:,2);
   top = F.pos{N}(:,2)+F.pos{N}(:,4);
   M = find(bot<y_clk(n) & top>y_clk(n));
   R = F.ind{N}{M};
   figure(spf)
   scatter(get(wfa(R),'start'),peak_amp(wfa(R),'val'))
end
dynamicDateTicks
clear n c_clk y_clk N bot top M R

%%
figure, hold on
r = F.ind{36}{1};
scatter(P3.start(r),P3.pa(r))

figure, hold on
r = F.ind{37}{1};
scatter(P3.start(r),P3.pa(r))
r = F.ind{37}{2};
scatter(P3.start(r),P3.pa(r))

%%
figure
for n=1:49
   r = F.ind{n}{1};
   scatter(P2.start(r),P2.rms(r)), hold on
   r = F.ind{n}{2};
   scatter(P2.start(r),P2.rms(r))
   r = F.ind{n}{3};
   scatter(P2.start(r),P2.rms(r))
   r = F.ind{n}{3};
   scatter(P2.start(r),P2.rms(r)), hold off
   title(num2str(F.cc(n)))
   if n==1
      xl = get(gca,'xlim');
      yl = get(gca,'ylim');
   else
      set(gca,'xlim',xl)
      set(gca,'ylim',yl)
   end
   pause(1)
end

%%
plot(c,'corr')
colormap(bone)
e = datenum(explosion);
for n=1:length(e)
   [Val Ref] = min(abs(t-e(n)));
   if t(Ref) < e(n)
      line([0 Ref+.5],[Ref+.5 Ref+.5],'color',[1 0 0])
      line([Ref+.5 Ref+.5],[Ref+.5 0],'color',[1 0 0])
   elseif t(Ref) > e(n)
      line([0 Ref-.5],[Ref-.5 Ref-.5],'color',[1 0 0])
      line([Ref-.5 Ref+.5],[Ref-.5 0],'color',[1 0 0])
   end
end

%%
clear X
 for n=5:15
  X(n)=sum(F.size{26}==n);
 end
figure, bar(X)




