function F = block_clust(BC,F,N,OVR,CVAL)

%BLOCK_CLUST: Clustering portion of block correlation technique
%
%USAGE: F = block_clust(BC,F,BS,N,OVR,CVAL)
%
%INPUTS: BC   - Current correlation block
%        F    - Current family index values
%        N    - Block number
%        OVR  - Block overlap
%        CVAL - Clustering correlation theshold
%        
%OUTPUTS: F - Updated block correlation family structure

%% Get clustering info from BC based on CVAL
BC = cluster(BC,CVAL);
stat = getclusterstat(BC);  
cind = stat.index;
begin = stat.begin;

%% Find and remove all singular waveforms
cut = find(stat.numel < 2); 
cind(cut) = [];  % Current index
begin(cut) = [];
clear stat

%% Sort chronologically based on first waveform arrival
[t_val t_pos] = sort(begin);
cind = cind(t_pos);

%% Create or ammend master index (F)
if N==1       % This is the first block
   F = cind;  % So create master index (F) from cind
elseif N>1    % Otherwise add to existing F
   %% Loop through all families in cind and join then with master index (F)
   for m = 1:length(cind)
      sub_ind = cind{m}+(N-1)*OVR;
      left = sub_ind(sub_ind<=(N*OVR));
      right = sub_ind(sub_ind>(N*OVR));
      % Loop through all families in F and find the one with the greatest
      % overlap with the current family
      maxovr = 0;  % Maximum number of overlapping events
      maxref = []; % Family reference of maximum overlap
      for k = 1:numel(F)
         noe = length(intersect(F{k},left)); % Number of Overlapping Events
         if noe > maxovr
            maxovr = noe;
            maxref = k;
         end
      end
      if maxovr > 0
         F{maxref}=[F{maxref};right];
      else
         F{numel(F)+1} = sub_ind;
      end
   end
end