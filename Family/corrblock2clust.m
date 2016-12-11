function config = corrblock2clust(config)

%CORRBLOCK2CLUST: Clustering portion of block correlation technique
%
%USAGE: config = corrblock2clust(config)
%
%INPUTS: config
%        
%OUTPUTS: config
%
%DIAGRAM:
%   ______________________________
%  |                              |
%  |                              |
%  |                              |
%  |                              |
%  |            MST.I             |
%  |            MST.T             |
%  |                              |
%  |                              |
%  |                      ________|________
%  |              MST.RSI|        |CUR.LSI |
%  |              MST.RST|        |CUR.LST |
%  |                ---->|        |<----   |
%  |_____________________|________|        |
%                        |                 |
%                        |      CUR.I      |
%                        |      CUR.T      |
%                        |_________________| 
%
%                        |--OVR---|
%                         
%                        |        |        |
%                   (m-1)*OVR   m*OVR   (m+1)*OVR

for n = 1:numel(config.scnl)
   cb_dir = fullfile(config.root_dir,get(config.scnl(n),'station'),'corr_block');
   fc_dir = fullfile(config.root_dir,get(config.scnl(n),'station'),'fam_clust');
   OVR = config.family.cc_size;
   % EXP.I: Expired Cluster Indices (These are extracted from MAS_IND)
   EXP.I = [];
   % EXP.T: Expired Cluster Times (These are extracted from MAS_IND)
   EXP.T = [];
   % EXP.C: Expired Cluster Corr Matrix (These are extracted from MAS_IND)
   EXP.C = [];
   % EXP.L: Expired Cluster Lag Matrix (These are extracted from MAS_IND)
   EXP.L = [];
   for m = 1:config.family.blockcnt(n)-1
      disp(['---------->', get(config.scnl(n),'station'),': Block ',...
          num2str(m),' <----------'])
      cd(cb_dir)
      load(['CORR_BLOCK_',num2str(m,'%03.0f'),'.mat'])
      % Get clusters from correlation object 'c' using threshold (config.cc)
      corr = get(c,'corr');
      lag = get(c,'lag');
      c = cluster(c,config.family.cc);
      stat = getclusterstat(c);
      clear CUR
      % CUR.I: Current Cluster Indices from Current Correlation Block 
      CUR.I = stat.index;
      % CUR.T: Current Cluster Times from Current Correlation Block
      CUR.T = stat.trig;
      for mm = 1:numel(CUR.I)
         CUR.C{mm} = corr(CUR.I{mm},CUR.I{mm});
         CUR.L{mm} = lag(CUR.I{mm},CUR.I{mm});
      end
      bgn = stat.begin;
      % Find and remove all singlets (non-clusters)
      cut = find(stat.numel < 2);
      CUR.I(cut) = [];
      CUR.T(cut) = [];
      CUR.C(cut) = [];
      CUR.L(cut) = [];
      bgn(cut) = [];
      clear c corr lag stat
      % Sort Clusters Chronologically based on first waveform arrival
      [t_val, t_pos] = sort(bgn);
      CUR.I = CUR.I(t_pos);
      CUR.T = CUR.T(t_pos);
      CUR.C = CUR.C(t_pos);
      CUR.L = CUR.L(t_pos);
      % MST.I: Master Cluster Index
      if m==1            % If this is the first block
         MST.I = CUR.I;  % Create MST.I from CUR.I
         MST.T = CUR.T;  % Create MST.T from CUR.T
         MST.C = CUR.C;  % Create MST.C from CUR.C
         MST.L = CUR.L;  % Create MST.L from CUR.L
      elseif m>1         % Otherwise add to existing MST.I
         % Loop Through all CUR.I Clusters and Join with MST.I Clusters
         for k = 1:numel(CUR.I)
            % CUR.SI: Current Cluster Sub-Indices /w Block Offest Added
            CUR.SI = CUR.I{k} + (m-1)*OVR;
            % CUR.ST: Current Cluster Sub-Times
            CUR.ST = CUR.T{k};
            % CUR.SC: Current Cluster Sub-Correlation Matrix            
            CUR.SC = CUR.C{k};
            % CUR.SL: Current Cluster Sub-Lag Matrix               
            CUR.SL = CUR.L{k};
            left = find(CUR.SI <= m*OVR);
            % CUR.LSI: Left Half of Current Cluster Sub-Indices
            CUR.LSI = CUR.SI(left);
            % CUR.LST: Left Half of Current Cluster Sub-Times
            CUR.LST = CUR.ST(left);
            % CUR.LSI: Left Half of Current Cluster Sub-Correlation Matrix 
            CUR.LSC = CUR.SC(left,left);
            % CUR.LST: Left Half of Current Cluster Sub-Lag Matrix   
            CUR.LSL = CUR.SL(left,left);            
            % Loop through all families in MST.I and find the one with the
            % greatest overlap with the current family
            maxovr = 0;  % Maximum number of overlapping events
            maxref = []; % Family reference of maximum overlap
            maxind = [];
            maxR = [];
            for kk = 1:numel(MST.I)
               try
                  MST.SI = MST.I{kk};
                  MST.ST = MST.T{kk};
                  MST.SC = MST.C{kk};
                  MST.SL = MST.L{kk};                  
                  right = MST.SI > (m-1)*OVR;
                  MST.RSI = MST.SI(right);
                  MST.RST = MST.ST(right);
                  MST.RSC = MST.SC(right,right);
                  MST.RSL = MST.SL(right,right);                  
                  % noe: Number of Overlapping Events between
                  %      MST.SI and CUR.SI
                  % intind: intersecting indices
                  intind = intersect(MST.RSI,CUR.LSI);
                  noe = length(intind);
                  % maxovr: Maximum number of overlapping events found so far
                  % maxref: Reference to which MST.SI had the max overlap
                  if noe > maxovr
                     maxovr = noe;
                     maxref = kk;
                     maxind = intind;
                     maxR = numel(MST.RSI);
                  end
               catch
               end
            end
            % The next loop determines under what conditions a cluster from
            % CUR.SI will be merged with a cluster in MST.SI. In this case
            % if the number of overlapping events represents a minimum of 50%
            % of either MST.RSI or CUR.LSI, then the clusters are merged
            if maxovr > 0
               if maxovr/maxR >= .5 || maxovr/numel(CUR.LSI) >= .5
                  % Store current MST.I{maxref} and CUR.SI for purposes of
                  % combing and re-mapping matrices MST.C{maxref} w/ CUR.SC
                  % and MST.L{maxref} w/ CUR.SL
                  A = MST.I{maxref};
                  B = CUR.SI;
                  C = [A; B];
                  [U U2C C2U] = unique(C,'first');
                  for nn=1:numel(A)
                     A2U(nn) = find(A(nn)==U);
                  end
                  for nn=1:numel(B)
                     B2U(nn) = find(B(nn)==U);
                  end
                  MST.I{maxref} = C(U2C);
                  MST.T{maxref} = [MST.T{maxref}; CUR.ST];
                  MST.T{maxref} = MST.T{maxref}(U2C);
                  NANCorr = nan(numel(U));
                  NANCorr(A2U,A2U) = MST.C{maxref};
                  NANCorr(B2U,B2U) = CUR.SC;   
                  MST.C{maxref} = NANCorr;
                  NANLag = nan(numel(U));
                  NANLag(A2U,A2U) = MST.L{maxref};
                  NANLag(B2U,B2U) = CUR.SL;   
                  MST.L{maxref} = NANLag;
                  clear A B C U U2C C2U A2U B2U NANCorr NANLag 
                  disp(['Connection --> RS: ',num2str(maxR),' LS: ',...
                        num2str(numel(CUR.LSI)),' NOE: ',num2str(maxovr)])
               end
            else % A new cluster is added to MST.I
               MST.I{numel(MST.I)+1} = CUR.SI;
               MST.T{numel(MST.T)+1} = CUR.ST;
               MST.C{numel(MST.C)+1} = CUR.SC;
               MST.L{numel(MST.L)+1} = CUR.SL;               
               disp(['No Connection --> RS: ',num2str(maxR),' LS: ',...
                     num2str(numel(CUR.LSI)),' NOE: ',num2str(maxovr)])
            end
         end
      end
      K = 1;
      while K <= numel(MST.I)
         if sum(MST.I{K} > (m-1)*OVR) == 0
            EXP.I{end+1} = MST.I{K};
            EXP.T{end+1} = MST.T{K};
            EXP.C{end+1} = MST.C{K};
            EXP.L{end+1} = MST.L{K};            
            MST.I(K) = [];
            MST.T(K) = [];
            MST.C(K) = [];
            MST.L(K) = [];            
         else
            K = K + 1;
         end
      end
   end
   F.I = [EXP.I MST.I];
   F.T = [EXP.T MST.T];
   F.C = [EXP.C MST.C];
   F.L = [EXP.L MST.L];   
   for KK = 1:numel(F.I)
      first(KK) = F.I{KK}(1);
      T1(KK) = F.T{KK}(1);
      T2(KK) = F.T{KK}(end);
      num(KK) = numel(F.I{KK});
   end
   [val ref] = sort(first);
   F.I = F.I(ref);
   F.T = F.T(ref);
   F.C = F.C(ref);
   F.L = F.L(ref);   
   F.numel = num(ref);
   F.start = T1(ref);
   F.end = T2(ref);
   cd(fc_dir)
   save('FAM_CLUST.mat','F')
end













