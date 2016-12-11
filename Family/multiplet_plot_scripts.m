
%% Compute Event Metrics for all Family waveforms
wb = waitbar(0);
for n=1:178
   waitbar(n/178,wb)
   w = extract(F.wave{n},'index',1,600);
   w = max_energy(w,5.12);
   for m = 1:length(w)
      F.pa{n}(m) = peak_amp(w(m),'val');
      F.rmsa{n}(m) = rms(w(m));
      F.pf{n}(m) = peak_freq(w(m),'val');
      F.fi{n}(m) = freq_index(w(m),[2 4],[8 25],'val');
   end
end

%% Split Family Structure into swarm and non-swarm
Sref = [];
for n = 1:178
   for m=1:8
      if (get(F.wave{n}(1),'start') > datenum(swarm_start(m,:))) &...
         (get(F.wave{n}(end),'start') < datenum(swarm_end(m,:)))
      Sref = [Sref n];
      end
   end
end

%% Make sure all waveforms are in order
for n=1:178
   tt = get(F.wave{n},'start')
   [val ref] = sort(tt);
   F.wave{n} = F.wave{n}(ref)
   F.pa{n} = F.pa{n}(ref)
   F.rmsa{n} = F.rmsa{n}(ref)
   F.pf{n} = F.pf{n}(ref)
   F.fi{n} = F.fi{n}(ref)
end

%% 
for n=1:178
   F.start(n) = get(F.wave{n}(1),'start')
   F.end(n) = get(F.wave{n}(end),'end')
end

%% FIG 1 - Multiplet Peak Frequency vs. RMS Amplitude
%  FIG 2 - Multiplet Frequency Index vs. RMS Amplitude

fh(1) = figure; ax(1) = axes; hold on
for n=1:178
   scatter(ax(1),get(F.wave{n},'start'),F.pf{n},F.rmsa{n}/15,...
           'MarkerFaceColor',F.color(n,:),'MarkerEdgeColor',[0 0 0])
end
dynamicDateTicks(ax(1))

fh(2) = figure; ax(2) = axes; hold on
for n=1:178
   scatter(ax(2),get(F.wave{n},'start'),F.fi{n},F.rmsa{n}/15,...
           'MarkerFaceColor',F.color(n,:),'MarkerEdgeColor',[0 0 0])        
end
dynamicDateTicks(ax(2))

linkaxes(ax,'x')

% ADD EXPLOSION LINES TO PLOTS, THEN MOVE LINES BEHIND SCATTER GROUP
nex = numel(explosion);
y1 = get(ax(1),'ylim'); axes(ax(1))
for m = 1:nex, line([explosion(m),explosion(m)],y1,'color','r'), end
y2 = get(ax(2),'ylim'); axes(ax(2))
for m = 1:nex, line([explosion(m),explosion(m)],y2,'color','r'), end
ch1 = get(ax(1),'children');
ch2 = get(ax(2),'children');
set(ax(1),'children',[ch1(1+nex:end); ch1(1:nex)])
set(ax(2),'children',[ch2(1+nex:end); ch2(1:nex)])
clear fh ax y1 y2 nex ch1 ch2