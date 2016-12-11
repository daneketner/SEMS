
%% Build Family Indicies for array of correlation values
F.cc = .50:.01:.99;
for n=1:numel(F.cc)
   F.ind{n} = []; % Family member indices array
   F.ind{n} = block_clust(C001,F.ind{n},1,1000,F.cc(n));
   F.ind{n} = block_clust(C002,F.ind{n},2,1000,F.cc(n));
   F.ind{n} = block_clust(C003,F.ind{n},3,1000,F.cc(n));
   F.ind{n} = block_clust(C004,F.ind{n},4,1000,F.cc(n));
   F.ind{n} = block_clust(C005,F.ind{n},4,1000,F.cc(n));
   F.ind{n} = block_clust(C006,F.ind{n},4,1000,F.cc(n));   
end


%% Build Family Indicies for array of correlation values

c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);

F.cc = .50:.01:.99;
for n=1:numel(F.cc)
   F.ind{n} = []; % Family member indices array
   F.ind{n} = block_clust(c,F.ind{n},1,786,F.cc(n));
end

%% Build Family Size array for each cc value
for n=1:length(F.ind) % Number of CC values
   for m = 1:numel(F.ind{n}) % Number of families
      F.size{n}(m) = length(F.ind{n}{m}); % Number of events in family
   end
end

%% Rearrange F in descending order according to family size
for n=1:length(F.ind) % Number of CC values
   [val pos]=sort(F.size{n}(m),'descend');
   F.ind{n} = F.ind{n}(pos);
   F.size{n} = F.ind{n}(pos);
end
clear k m n pos val

%% Plot CC vs number of families for various minimum family sizes (R)
figure, hold on
for R = [4,5,6,7,8,10,12,15,18,23,30]
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

%% Plot CC vs total number of multiplet events
figure
for n=1:length(F.cc) 
   y(n) = numel(F.ind{n});
end
plot(F.cc,y)
clear y

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

%% Attempt Castle Plot
F.pos = cell(1,length(F.ind));
F.off = cell(1,length(F.ind));
F.par = cell(1,length(F.ind));
figure
ah = axes;
hold on
F.off{1}(1) = 0;
for m = 1:numel(F.ind{1})
   ii = abs(F.cc(2)-F.cc(1));
   F.pos{1}(m,:) = [F.cc(1)-ii/2,F.off{1}(m),ii,F.size{1}(m)];
   rectangle('Position',F.pos{1}(m,:),'FaceColor',[1 0 0]) 
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
      rectangle('Position',F.pos{n}(m,:),'FaceColor',[1 0 0])
      %line([F.pos{n}(m,1) F.pos{n}(m,1)],...
      %     [F.pos{n}(m,2) F.pos{n}(m,2)+F.pos{n}(m,4)],'Color',[1 1 1])
      catch
      end
   end
end
clear m maxovr maxref k noe ah cph cpo cs cso ii mm n tsh tso wb






