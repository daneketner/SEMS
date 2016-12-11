
%%
cc = .50:.01:1;
for n=1:numel(cc)
   F{n} = [];
   F{n} = block_clust(C001,F{n},1,1000,cc(n));
   F{n} = block_clust(C002,F{n},2,1000,cc(n));
   F{n} = block_clust(C003,F{n},3,1000,cc(n));
   F{n} = block_clust(C004,F{n},4,1000,cc(n));
end

%% Plot CC vs number of families for various minimum family sizes (R)
figure, hold on
for R = [4,5,6,7,8,10,12,15,18,23,30]
   cnt = zeros(1,length(cc));
   for n=1:length(cc)
      for m = 1:numel(F{1,n})   % Number of families
         if numel(Fd{1,n}{1,m})>=R
            cnt(n) = cnt(n)+1;
         end
      end
   end
   plot(cc,cnt)
end


%% Plot CC vs total number of multiplet events
figure
for n=1:length(cc) 
   y(n) = numel(F{n});
end
  plot(cc,y)

%% Rearrange F in descending order (Fd) according to family size
Fd =F;
for n=1:length(cc) % Number of CC values
   k = [];
   for m = 1:numel(Fd{1,n}) % Number of families
      k(m) = numel(Fd{1,n}{1,m}); % Number of events in family
   end
   [val pos]=sort(k,'descend');
   Fd{1,n} = Fd{1,n}(pos);
end
clear k m n pos val

%% Plot CC vs total number of family waveforms
figure, hold on
for n=1:length(cc) % Number of CC values
   cnt = 0;
   for m = 1:numel(Fd{1,n})   % Number of families
      k = numel(Fd{1,n}{1,m}) % Number of events in family
      if rem(m,2)==0
      rectangle('Position',[cc(n)-.005,cnt,.01,k],'FaceColor',[1 1 0]) 
      else
      rectangle('Position',[cc(n)-.005,cnt,.01,k],'FaceColor',[1 1 1])
      end
      cnt = cnt+k;
   end    
end

%% Attempt Castle Plot
figure, hold on

h = 0;
for m=1:numel(Fd{1,1})
   Pos{1,1}{1,m} = [cc(1)-.005,h,.01,length(Fd{1,1}{1,m})];
   rectangle('Position',Pos{1,1}{1,m}) 
   h = h + length(Fd{1,1}{1,m});
end

wb = waitbar(0);
for n=2:length(cc)
   waitbar(n/length(cc),wb)
   parent{1,n} = [];
   for m = 1:numel(Fd{1,n}) % Number of families for nth cc value
      c_ind = Fd{1,n}{1,m}; % event indecies for mth family, nth cc value
      maxovr = 0;
      maxref=0;
      for k = 1:numel(Fd{1,n-1})
         noe = length(intersect(Fd{1,n}{1,m},Fd{1,n-1}{1,k})); % Number of Overlapping Events
         if noe > maxovr
            maxovr = noe;
            maxref = k;
         end
      end
      parent{1,n} = [parent{1,n} maxref];
   end
   for m=1:numel(parent{1,n})
      sibling{1,n}{1,m} = find(parent{1,n}==parent{1,n}(m));
      %if numel(sibling{1,n}{1,m})==1
         Pos{1,n}{1,m} = Pos{1,n-1}{1,parent{1,n}(m)}
      %end
      rectangle('Position',Pos{1,n}{1,m})
   end
end

