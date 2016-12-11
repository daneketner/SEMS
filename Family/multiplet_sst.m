function F = multiplet_sst(sst) 

%% INITIALIZE

nw = size(sst,1);    % Number of waveforms
block = 2000;        % Cross-correlation block size
N = floor(nw/block); % Number of complete blocks
rem = nw-block*N;    % Number of remaining waveforms after last block

%% ALL BUT LAST BLOCK
for n = 1:N
   W = [];
   for m = 1:block
      start = sst((n-1)*block+m,1);
      try
         W = [W get_red_w('rso',start-1/24/60/60,start+7/24/60/60,0)];
      catch
         pause(30)
         W = [W get_red_w('rso',start-1/24/60/60,start+7/24/60/60,0)];
      end
   end
   C = clust_fam(W,.75);
   save(['WB',num2str(n,'%03.0f'),'.mat'],'C')
   k=1;
   while C.fam.numel(k)>=5
      c_ind{k}=C.fam.index{k}
      k=k+1;
   end
   for m = 1:length(c_ind) % Number of clusters in stat
      sub_ind = c_ind{m}+(n-1)*block/2;
      left = sub_ind(sub_ind<=(n*block/2));
      right = sub_ind(sub_ind>(n*block/2));
      overlap = 0; f_ref = 0;
      for k = 1:numel(F) % Number of families currently in F
         noe = length(intersect(F{k},left));
         if noe > overlap
            overlap = noe;
            f_ref = k;
         end
      end
      if overlap > 0
         F{f_ref}=[F{f_ref};right];
      else
         F{numel(F)+1} = sub_ind;
      end
   end
   save('F.mat','F')
   clear W start C k c_ind sub_ind left right overlap noe f_ref
end

%% LAST BLOCK
if rem > 0
   W = [];
   for m = 1:rem
      start = sst(N*block+m,1);
      try
         W = [W get_red_w('rso',start-1/24/60/60,start+7/24/60/60,0)];
      catch
         pause(30)
         W = [W get_red_w('rso',start-1/24/60/60,start+7/24/60/60,0)];
      end
   end
   C = clust_fam(W,.75);
   save(['WB',num2str(n,'%03.0f'),'.mat'],'C')
   k=1;
   while C.fam.numel(k)>=5
      c_ind{k}=C.fam.index{k}
      k=k+1;      
   end
   for m = 1:length(c_ind) % Number of clusters in stat
      sub_ind = c_ind{m}+(n-1)*block/2;
      left = sub_ind(sub_ind<=(n*block/2));
      right = sub_ind(sub_ind>(n*block/2));
      overlap = 0; f_ref = 0;
      for k = 1:numel(F) % Number of families currently in F
         noe = length(intersect(F{k},left));
         if noe > overlap
            overlap = noe;
            f_ref = k;
         end
      end
      if overlap > 0
         F{f_ref}=[F{f_ref};right];
      else
         F{numel(F)+1} = sub_ind;
      end
   end
   save('F.mat','F')
   clear W start C k c_ind sub_ind left right overlap noe f_ref
end

%% MAKE SURE FIRST ELEMENTS IN F ARE IN ASCENDING ORDER (TIME)
A=[]; 
for n=1:numel(F)
   F{n}=sort(F{n}); 
   A = [A, F{n}(1)]; 
end
[I J] = sort(A);
F = F(J);
save('F.mat','F')

%% STACK ALL FAMILY WAVEFORMS, CROSS CORRELATE, & COMBINE RELATED FAMILIES
% function F = combine_families(F,Wc,coeff)
% stk = [];
% for n = 1:numel(F)
%    % If family size is less than 500, stack all waveforms
%    if numel(F{n})<500
%       stk = [stk stack(Wc(F{n}))];
%    % If family size is greater than 500, interpolate waveforms to stack
%    else
%       inc = round(length(F{n})/500);
%       stk = [stk stack(Wc(F{n}(1:inc:end)))];
%    end
% end
% 
% c = correlation(stk);
% %c = crop(c,-2,4);
% c = taper(c);
% c = butter(c,[1 10]);
% c = xcorr(c,[-1,5]);
% c = sort(c);
% c = adjusttrig(c,'MIN');
% c = linkage2(c);
% c = cluster(c,coeff);
% stat = getclusterstat(c);
% N = sum(stat.numel>1);

%% WAVEFORMS IN FAMILIES THAT CORRELATE OVER 'coeff' ARE COMBINED INTO
%% FIRST FAMILY. FAMILIES ARE SET TO [] AFTER THEY ARE MOVED.
% for n = 1:N
%    rel = stat.index{n};
%    for m = 2:numel(rel)
%       F{rel(1)} = [F{rel(1)}; F{rel(m)}];
%       F{rel(m)} = [];
%    end
%    F{rel(1)} = sort(F{rel(1)});
% end
% 
%% FAMILES SET TO [] ARE REMOVED FROM 'F'
% n = 1
% while n <= length(F)
%    if isempty(F{n})
%       F(n)=[];
%    else
%       n=n+1;
%    end
% end

%% REMOVE FROM F, MULTIPLETS WHICH ARE SMALLER THAN 'mms'
% mms = 5; % Minimum multiplet size
% n = 1;
% while n <= length(F)
%    if length(F{n})<mms
%       F(n)=[];
%    else
%       n=n+1;
%    end
% end
 
%% PLOT FAMILY OCCURENCE CHART
% fh = figure;                           % Figure hande for occurence plot
% ax = axes('Position',[.05 .05 .9 .9]); % Axes handle for occurence plot
% nf = numel(F);                         % Number of families
% tm = .025;                             % Axes Top Margin
% bm = .025;                             % Axes Bottom Margin
% t_start = floor(get(Wc(1),'start'))-1; % Start Day before Wc(1)
% t_end = ceil(get(Wc(end),'start'))+1;  % End Day after Wc(end)
% gap = (1-tm-bm)*.2/(nf-1);             % Gap between rectangles 
% h = (1-tm-bm-gap*(nf-1))/nf;           % Height of rectangles

%% PLOT VERTICAL EXPLOSION LINES
% for n = 1:length(explosion)            
%    line([explosion(n) explosion(n)],[0 1],'color',[1 0 0])
% end
% 
% for n = 1:nf                           % 1:number of families
%    ylab{n} = num2str(n,'%03.0f');      % Y-axis Family Label
%    ypos(n) = bm+(h+gap)*(n-1)+h/2;     % Y-axis Family Label Position
%    F_start = get(Wc(F{n}(1)),'start'); % Time of first family member
%    F_end = get(Wc(F{n}(end)),'start'); % Time of last family member
%    % DRAW FAMILY RECTANGLE
%    rectangle('Position',[F_start,bm+(h+gap)*(n-1),F_end-F_start,h],...
%              'FaceColor',[1 1 1]);    
%    % DRAW VERTICAL TICKS INSIDE FAMILY RECTANGLE FOR ALL INTERIOR MEMBERS
%    for m = 2:numel(F{n})-1            
%       x = get(Wc(F{n}(m)),'start');
%       line([x x],[bm+(h+gap)*(n-1), bm+(h+gap)*(n-1)+h],'color',[0 0 0])
%    end
% end
% %
% set(ax,'YTick',ypos)
% set(ax,'YTickLabel',ylab)
% dynamicDateTicks
% ylim([0,1])
% xlim([t_start,t_end])
% clear ylab x tm ypos t_start t_end gap nf n m h fh dur bm ax F_start F_end

%% CORRELATE ALL FAMILY TO GET TRIG TIMES
% for n=8:8%length{F}
%    w_fam = Wc(F{n});
%    c = correlation(w_fam);
%    c = taper(c);
%    c = butter(c,[1 10]);
%    c = xcorr(c,[-1,5]);
%    c = sort(c);
%    c = adjusttrig(c,'MIN');
%    trig = get(c,'trig');
% end
 
%% BUILD FAMILY WAVEFORM STRUCTURE WITH MANUALLY SELECTED TIME WINDOW
% for m = 1:length(trig)
%    Fam.wave{n}(1,m)=get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+10/24/60/60,0);
% end
% figure, plot(stack(Fam.wave{n}))
% grid on

%% EXAMINE ALL FAMILY MEMBERS AND DELETE THE QUEER LOOKIN' ONES
% Fam.wave{n} = event_editor2(Fam.wave{n},20);
 
%% SAY SOMETHING MEANINGFUL ABOUT SOMEONE'S FAMILY
% Fam.note{n} = [];

%% SPLIT A FAMILY AT POINT d
% d = datenum([2009 04 01 00 00 00]); % Time value used to split family
% sst = wfa2sst(Wc(F{n}));     % Get SST of all waveforms in family
% [N P] = search_sst(d,sst);   % Determined where to split family
% if P == 0                    % If time value not splitting a member
%    find(F{n}==N)             % Element N is first after 'd'
%    f1 = F{n}(1:N-1);         % First half of split family
%    f2 = F{n}(N:end);         % Second half of split family
%    F{n} = f1;                % Adjust Cell Array
%    Fam.wave{n} = Fam.wave{n}(1:N-1); %Adjust Structure
% end
% found = 0 % Found location in F where f2 should reside
% nn = n
% while found == 0
%    if nn<=length(F)
%       if f2(1)<F{nn}
%          F = [F(1:nn-1) f2 F(nn:end)];
%          found = 1;
%       end
%    else
%       F{end+1} = f2;
%       found = 1;
%    end
% end
 
%% FAMILY IS TOO LARGE
% w_fam = Wc(F{83}(15001:15538));
% c = correlation(w_fam);
% c = crop(c,-2,4);
% c = taper(c);
% c = butter(c,[1 10]);
% c = xcorr(c);
% c = sort(c);
% c = adjusttrig(c,'MIN');
% trig = [trig; get(c,'trig')];
 
%%
% for k = 10:-1:1, figure, plot(Fam.wave{110}(k)), end





























