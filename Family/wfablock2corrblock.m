function config = wfablock2corrblock(config)

%WFABLOCK2CORRBLOCK: Take daily blocks of waveforms and correlate them and
%stuff
%
%USAGE: config = wfablock2corrblock(config)
%
%INPUTS:  config
%
%OUTPUTS: config

for n = 1:numel(config.scnl)
   sta = get(config.scnl(n),'station');
   wb_dir = fullfile(config.root_dir,sta,'wfa_block');
   cb_dir = fullfile(config.root_dir,sta,'corr_block');
   range = [1 config.family.blockcnt(n)];
   corr_int = config.edp.pad(1)+[0 config.family.cc_win];
   if range(1) == range(2)
      m = range(1);
      cd(wb_dir)
      load(['WFA_BLOCK_',num2str(m,'%03.0f'),'.mat'])
      wfa_block = remove_empty(wfa_block);
      wfa_block = fillgaps(wfa_block,0);
      c = correlation(wfa_block);
      c = set(c,'trig',get(c,'start'));
      c = taper(c);
      c = butter(c,[1 10]);
      c = xcorr(c,corr_int);
      c = sort(c);
      c = linkage(c);
      cd(cb_dir)
      save(['CORR_BLOCK_',num2str(m,'%03.0f'),'.mat'],'c')
   elseif range(1)<range(2)
      b1 = waveform();
      for m = range(1):range(2)-1
         cd(wb_dir)
         if isempty(b1)
            load(['WFA_BLOCK_',num2str(m,'%03.0f'),'.mat'])
            b1 = wfa_block;
            load(['WFA_BLOCK_',num2str(m+1,'%03.0f'),'.mat'])
            b2 = wfa_block;
         else
            b1 = b2;
            load(['WFA_BLOCK_',num2str(m+1,'%03.0f'),'.mat'])
            b2 = wfa_block;
         end
         b12 = [b1; b2];
         b12 = remove_empty(b12);
         b12 = fillgaps(b12,0);
         c = correlation(b12);
         c = set(c,'trig',get(c,'start'));
         c = taper(c);
         c = butter(c,[1 10]);
         c = xcorr(c,corr_int);
         c = sort(c);
         c = linkage(c);
         cd(cb_dir)
         save(['CORR_BLOCK_',num2str(m,'%03.0f'),'.mat'],'c')
      end
   end
end

