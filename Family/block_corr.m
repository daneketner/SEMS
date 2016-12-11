function F = block_corr(e,varargin)

%BLOCK_CORR: Correlates waveforms in overlapping blocks
%
%USAGE: F = block_corr(e,varargin)
%
%INPUTS: e - Event array block
%        
%OUTPUTS: F - Updated block correlation family structure

%% CHECK EVENT INPUT
if isa(e,'waveform')
   nw = numel(e);    % Number of input events
elseif is_sst(e)
   nw = size(e,1);   % Number of input events
else
   error('block_corr: Event array input must be waveform or SST')
end

%% DEFAULT PROPERTIES
block = 2000;     % Cross-correlation block size
over = block/2;   % Cross-correlation block overlap
cc = 0.75;         % Correlation coefficient threshold
start = 1;        % Start at block 1
F = {};           % Start with empty Family array

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['block_corr: Arguments after input must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'start'    % Starting block
            start = val;
         case 'fam'      % Starting family array (use with 'start')
            F = val;          
         case 'block'    % Cross-correlation block size
            block = val;
            over = block/2;
         case 'cc'       % Correlation coefficient threshold
            cc = val;  
         case 'sc'       % Station/Channel tag
            sc = val;              
         otherwise
            error('block_corr: Property name not recognized')
      end
   end
end

%%  
N = floor(nw/over)-1;  % Number of full blocks
R = nw-(N+1)*over;  % Number of remaining waveforms after last block

%% GET SUBSET OF EVENTS WITH LENGTH = BLOCK
s2d = 1/24/60/60;
for n = start:N+1 % Number of full blocks + 1
   if n < N+1
      if isa(e,'waveform')
         sub_wfa = e((n-1)*over+1:(n-1)*over+block);
      elseif is_sst(e)
         sub_sst = e((n-1)*over+1:(n-1)*over+block,:);
         sub_wfa = [];
         for m = 1:size(sub_sst,1)
            if rem(m,500)==0, pause(10), end
            sub_wfa = [sub_wfa get_red_w(sc,sub_sst(m,1)-s2d,sub_sst(m,1)+7*s2d,0)];
         end
      end
   elseif (n == N+1) && (R>0)
      if isa(e,'waveform')
         sub_wfa = e((n-1)*over+1:end);
      elseif is_sst(e)
         sub_sst = e((n-1)*over+1:end,:);
         sub_wfa = [];
         for m = 1:size(sub_sst,1)
            if rem(m,500)==0, pause(10), end
            sub_wfa = [sub_wfa get_red_w(sc,sub_sst(m,1)-s2d,sub_sst(m,1)+7*s2d,0)];
         end
      end
   end
   
%% X-CORRELATE BLOCK OF EVENTS AND UPDATE F 
   c_ind = clust_index(sub_wfa,cc,5,n);
   for m = 1:length(c_ind) % Number of clusters in stat
      sub_ind = c_ind{m}+(n-1)*over;
      left = sub_ind(sub_ind<=(n*over));
      right = sub_ind(sub_ind>(n*over));
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
end

%% CLUST_INDEX
function c_ind = clust_index(wfa,cc,cut_off,n)
c = correlation(wfa);
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[-1,5]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
c = cluster(c,cc);
save(['BC',num2str(n,'%03.0f'),'.mat'],'c')
stat = getclusterstat(c);
cut = find(stat.numel < cut_off);
stat.index(cut) = [];
stat.begin(cut) = [];
[t_val t_pos] = sort(stat.begin);
stat.index = stat.index(t_pos);
c_ind = stat.index;
clear c stat

% function dontrun(A)
% %% NOT PART OF THE PROGRAM
% 
% %%
% wfa = [];
% s2d = 1/24/60/60;
% for m = 1:2000
%    wfa = [wfa get_red_w('red:ehz',red_sst(m,1)-s2d,red_sst(m,1)+7*s2d,0)];
% end

%% CONVERT LONG SST ARRAY INTO WFA BLOCKS OF LENGTH 2000

s2d = 1/24/60/60;
N = 31;           % Current block
K = size(sst,1);  % Length of sst
k = 1;            % sst array counter
found_end = 0
while found_end == 0
   wfa = [];  % Current wfa block
   L = 0;     % Current length of block N
   while L < 2000
      try
         wfa = [wfa get_red_w('rdn',sst(k,1)-s2d,sst(k,1)+7*s2d,0)];
      catch
         pause(30)
      end
      L = length(wfa);
      if rem(L,500)==0, pause(15), end
      k = k + 1;
   end
   save(['wfa',num2str(N,'%03.0f'),'.mat'],'wfa')
   clear wfa
   if k < K
      N = N + 1;
   else
      found_end = 1;
   end
end


