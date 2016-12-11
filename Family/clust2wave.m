function log = clust2wave(log)

%CLUST2WAVE: 
%
%USAGE: log = clust2wave(log)
%
%INPUTS: log
%
%OUTPUTS: log

for n = 1%:numel(log.scnl)
   fc_dir = fullfile(log.root,get(log.scnl(n),'station'),'fam_clust');
   cd(fc_dir)
   load('FAM_CLUST.mat')
   for m = 672:numel(F.T)
      w = waveform;
      for k = 1:numel(F.T{m})
         t = F.T{m}(k);
         try %1
         w(k) = get_w(log.ds,log.scnl(n),t,t+10/24/60/60);
         catch %1
         pause(10)
         try %2
         w(k) = get_w(log.ds,log.scnl(n),t,t+10/24/60/60);
         catch %2
         pause(20)
         try %3
         w(k) = get_w(log.ds,log.scnl(n),t,t+10/24/60/60);
         catch %3
         pause(30)
         w(k) = get_w(log.ds,log.scnl(n),t,t+10/24/60/60);
         end %3
         end %2
         end %1
      end
      w = fillgaps(w,0);
      c = correlation(w);
      c = set(c,'trig',get(c,'start'));
      trig = get(c,'trig');
      c = taper(c);
      c = butter(c,[1 10]);
      c = xcorr(c,[1 8]);
      c = sort(c);
      [V R] = max(sum(get(c,'corr')));
      lag = double(get(c,'lag'));
      trig = trig + lag(:,R)/24/60/60;
      % Find and remove duplicate events
      h=2;
      while h <= numel(trig)
         if abs(trig(h) - trig(h-1)) < 5/24/60/60
            trig(h) = [];
            w(h) = [];
            F.T{m}(h) = [];
            F.I{m}(h) = [];
         else
            h = h+1;
         end
      end
      for kk = 1:numel(trig)
         try %1
         w(kk) = get_w(log.ds,log.scnl(n),trig(kk),trig(kk)+10/24/60/60);
         catch %1
         pause(10) %1
         try %2
         w(kk) = get_w(log.ds,log.scnl(n),trig(kk),trig(kk)+10/24/60/60);
         catch %2
         pause(20) %2     
         try %3
         w(kk) = get_w(log.ds,log.scnl(n),trig(kk),trig(kk)+10/24/60/60);
         catch %3
         pause(30) %3
         w(kk) = get_w(log.ds,log.scnl(n),trig(kk),trig(kk)+10/24/60/60);
         end % 3
         end % 2
         end % 1
      end
      save(['CLUST_',num2str(m,'%03.0f'),'.mat'],'w')
      R = ceil(numel(w)/50);
      stk = bin_stack(w,R,0);
      plotm2(stk,'scale',.5)
      title(['Cluster ',num2str(m,'%03.0f'),' Stacks of ',num2str(R), ' waveforms'])
      print(gcf, '-dpng', fullfile(fc_dir,['CLUST_',num2str(m,'%03.0f')]))
      close(gcf)
   end
   for g = 1:numel(F.I)
      F.numel(g) = numel(F.I{g});
      F.start(g) = F.T{g}(1);
      F.start(g) = F.T{g}(2);
   end
   save('FAM_CLUST.mat','F')
end
