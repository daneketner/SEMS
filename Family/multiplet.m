function F = multiplet(Wc) % Or change to W for full program

% %% INITIALIZE
% W(find(get(W,'duration')==0))=[]; % Remove Empty waveforms (if any)
% Wc = [];
% nw = numel(W);       % Number of waveforms
% block = 2000;        % Cross-correlation block size
% N = floor(nw/block); % Number of complete blocks
% rem = nw-block*N;    % Number of remaining waveforms after last block
% 
% %% CORRELATE W IN BLOCKS
% for n = 1:N
%    C = clust_fam(W((n-1)*block+1:n*block),.75);
%    for m = 1:numel(C.clust)
%       Wc = [Wc, W(C.fam.index{m})];
%    end
% end
% if rem > 0
%    C = clust_fam(W(N*block+1:end),.75);
%    for m = 1:numel(C.clust)
%       Wc = [Wc, W(C.fam.index{m})];
%    end
% end
% 
% clear W C N rem nw
% [X I] = sort(get(Wc,'start')); Wc = Wc(I); clear X I

%% CORRELATE Wc IN BLOCKS
block = 2000;
nw = numel(Wc);                   % Number of waveforms
N = floor(nw/(block/2))-1;        % Number of complete blocks
F = {};
for n = 1:N+1 % Number of full blocks + 1
   if n < N+1
      sub_Wc = Wc(1+(n-1)*block/2:(n+1)*(block/2));
   elseif n == N+1
      sub_Wc = Wc(1+(n-1)*block/2:end);
   end
   c_ind = clust_index(sub_Wc,0.75,5,n);
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
end
%F = combine_families(F,Wc,0.75);

%% CLUST_INDEX
function c_ind = clust_index(wfa,coeff,cut_off,n)
f = fullfile('C:','Work','RED_Events','STA_LTA_Daily','REF','CORR_002');
c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
c = cluster(c,coeff);
save(fullfile(f,['B',num2str(n,'%03.0f'),'.mat']),'c')
imwrite(get(c,'corr'),fullfile(f,['BB',num2str(1,'%03.0f'),'.bmp']),'bmp')
stat = getclusterstat(c);
cut = find(stat.numel < cut_off);
stat.index(cut) = [];
stat.begin(cut) = [];
[t_val t_pos] = sort(stat.begin);
stat.index = stat.index(t_pos);
c_ind = stat.index;
clear c stat

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
% 
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
% ax = axes('Position',[.06 .06 .72 .9]); % Axes handle for occurence plot
% nf = numel(F);                         % Number of families
% tm = .025;                             % Axes Top Margin
% bm = .025;                             % Axes Bottom Margin
% t_start = floor(get(Wc(1),'start'))-1; % Start Day before Wc(1)
% t_end = ceil(get(Wc(end),'start'))+1;  % End Day after Wc(end)
% gap = (1-tm-bm)*.2/(nf-1);             % Gap between rectangles 
% h = (1-tm-bm-gap*(nf-1))/nf;           % Height of rectangles
% 
% PLOT VERTICAL EXPLOSION LINES
% for n = 1:length(explosion)            
%    line([explosion(n) explosion(n)],[0 1],'color',[1 0 0])
% end
% 
% for n = 1:nf                           % 1:number of families
%    yts = 10; % Y-Tick Spacing
%    if rem(n,yts)==0
%    ylab{n/yts} = num2str(n,'%03.0f');      % Y-axis Family Label
%    ypos(n/yts) = bm+(h+gap)*(n-1)+h/2;     % Y-axis Family Label Position
%    end
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
% 
% set(ax,'YTick',ypos)
% set(ax,'YTickLabel',ylab)
% set(ax,'XGrid','on')
% YLabel('MULTIPLET NUMBER')
% XLabel('DATE')
% dynamicDateTicks
% ylim([0,1])
% xlim([t_start,t_end])
% 
% ax2 = axes('Position',[.78 .06 .18 .9]); % Axes handle for occurence plot
% lnw = log10(Fam.nw);
% roof = ceil(max(lnw));
% norm = lnw/roof;
% 
% for n = 1:nf                           % 1:number of families
%    rectangle('Position',[1-norm(n),bm+(h+gap)*(n-1),norm(n),h],...
%              'FaceColor',[0 0 0]);    
% end
% 
% for n = 1:roof
%    xlab{n} = (['10^',num2str(roof+1-n)]);
%    xpos(n) = ((n-1)/roof);
% end
% 
% set(ax2,'YTick',ypos)
% set(ax2,'YTickLabel',[])
% set(ax2,'XGrid','on')
% XLabel('LOG_1_0(EVENT COUNT)')
% set(ax2,'XTick',xpos)
% set(ax2,'XTickLabel',xlab)
% 
% clear ylab ypos xlab xpos x tm t_start t_end gap nf n m h fh dur bm ax F_start F_end

%% CORRELATE ALL FAMILY TO GET TRIG TIMES
% n=290; 
% w_fam = Wc(F{n});
% c = correlation(w_fam);
% c = taper(c);
% c = butter(c,[1 10]);
% c = xcorr(c,[-1,5]);
% c = sort(c);
% c = adjusttrig(c,'MIN');
% trig = get(c,'trig');
 
%% BUILD FAMILY WAVEFORM STRUCTURE WITH MANUALLY SELECTED TIME WINDOW
% for m = 1:length(trig)
%    Fam.wave{n}(1,m)=get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+8/24/60/60,0);
% end
% figure, plot(stack(Fam.wave{n}))
% grid on
% plot(c,'corr')
%
%% EXAMINE ALL FAMILY MEMBERS AND DELETE THE QUEER LOOKIN' ONES
% Fam.wave{n} = event_editor2(Fam.wave{n},20);
 
%% DELETE CURRENT FAMILY
% Fam.wave(n)=[];
% F(n)=[];
% 
%% SPLIT A FAMILY AT POINT d
% cut = 221-7;
% Fam.wave(n)=[];
% F_move = F{n}(cut:end);
% F{n} = F{n}(1:cut-1);
% k=n+1; found=0;
% while found == 0
%    if F{k}(1)<F_move(1)
%       k=k+1;
%    else
%       F = [F(1:k-1),{F_move},F(k:end)];
%       found = 1;
%    end
% end
 
%% FAMILY IS TOO LARGE
% n = 236;
% nw = numel(F{n});     
% block = 500;         
% N = floor(nw/block); % Number of complete blocks
% rem = nw-block*N;    % Number of remaining waveforms after last block
% trig = [];
% 
% for k = 1:N
%    w_fam = Wc(F{n}((k-1)*block+1:k*block));
%    c = correlation(w_fam);
%    c = crop(c,-2,4);
%    c = taper(c);
%    c = butter(c,[1 10]);
%    c = xcorr(c);
%    c = sort(c);
%    c = adjusttrig(c,'MIN');
%    trig = get(c,'trig');
%    for m = 1:length(trig)
%       Fam.wave{n}(1,m+(k-1)*block)=get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+10/24/60/60,0);
%    end
%    figure, plot(stack(Fam.wave{n}))
%    grid on
% end
% if rem > 0
%    w_fam = Wc(F{n}(N*block+1:end))
%    c = correlation(w_fam);
%    c = crop(c,-2,4);
%    c = taper(c);
%    c = butter(c,[1 10]);
%    c = xcorr(c);
%    c = sort(c);
%    c = adjusttrig(c,'MIN');
%    trig = get(c,'trig');
%    for m = 1:length(trig)
%       Fam.wave{n}(1,m+N*block)=get_red_w('ref:ehz',trig(m)-2/24/60/60,trig(m)+8/24/60/60,0);
%    end
%    figure, plot(stack(Fam.wave{n}))
%    grid on
% end

%% BUILD METRIC STRUCTURE ONTO WAVE STRUCTURE
% for k=1:numel(Fam.wave)
%    w = Fam.wave{k};
%    if numel(w)>500
%       mid = round(numel(w)/2);
%       Fam.stk(k) = stack(w(mid-249:mid+250));
%    else
%       Fam.stk(k) = stack(w);      
%    end
% end

%%
% for k=1:numel(Fam.wave)
%    Fam.nw(k) = numel(Fam.wave{k});
% end

%%
% for k=1:numel(Fam.wave)
%    Fam.seed(k) = max_energy(Fam.stk(k),5.12);
% end
 
%%
% for k=1:numel(Fam.wave)
%    Fam.seed(k) = max_energy(Fam.stk(k),5.12);
% end
 
%%
% for k=1:numel(W)
%    waitbar(k/27622)
%    W_max_512(k) = max_energy(W(k),5.12);
% end






























