function [metric FFT] = sems_metric(wfa,w,config)

Fs = get(wfa(1),'freq');
cm = config.metric;

% COMPUTE RMS AMPLITUDE OF SIGNAL (EVERY 10 MINUTES) AND SMOOTH
[metric.bin_rms(1,:) br] = bin_rms(w, 1/24/6);
metric.bin_rms(2,:) = fastsmooth(br,6,3,1);

% COMPUTE FFT OF ALL EVENTS
[A F] = pos_fft(extract(wfa,'INDEX',Fs,Fs*(1+cm.sm_win)),...
   'nfft',cm.sm_nfft,'smooth',cm.sm_smo,'taper',cm.sm_tap);
FFT.amp = A;
FFT.freq = F;

if ~isempty(wfa)
   %START
   metric.start = get(wfa,'start');
   
   %EVENT PEAK AMPLITUDE
   if cm.pa == 1
      metric.pa = peak_amp(wfa,'val');
   else
      metric.pa = [];
   end
   
   %EVENT PEAK-TO-PEAK AMPLITUDE
   if cm.p2p == 1
      metric.p2p = peak2peak_amp(wfa,'val');
   else
      metric.p2p = [];
   end
   
   %EVENT RMS AMPLITUDE
   if cm.rms == 1
      metric.rms = rms(extract(wfa,'index',Fs,Fs*(1+cm.rms_win)));
   else
      metric.rms = [];
   end

   %SNR (RATIO OF EVENT RMS AMPLITUDE TO BIN RMS AMPLITUDE)
   if cm.snr == 1
      for n = 1:numel(metric.start)
         [val ind] = min(abs(metric.bin_rms(1,:)+5/24/60-metric.start(n)));
         metric.snr(n) = metric.rms(n)/metric.bin_rms(2,ind);
      end
   else
      metric.rms = [];
   end
   
   %EVENT PEAK FREQUENCY
   if cm.pf == 1
      [tmp I] = max(A);
      metric.pf = F(I);
   else
      metric.pf = [];
   end

   %EVENT FREQUENCY INDEX
   if cm.fi == 1
      for n = 1:numel(wfa)
         hf = A(F>=cm.fi_hi(1) & F<=cm.fi_hi(2),n);
         lf = A(F>=cm.fi_lo(1) & F<=cm.fi_lo(2),n);
         metric.fi(n,1) = log10(mean(hf)/mean(lf));
      end
   else
      metric.fi = [];
   end

   %INTER-EVENT TIME
   if cm.iet == 1
      t = get(wfa,'start');
      metric.iet = t(2:end) - t(1:end-1);
   else
      metric.iet = [];
   end

   %EVENT RATE PER
   if cm.erp == 1
      t = get(wfa,'start');
      per = 1/(cm.erp_win/24/60/60);
      ft = floor(t*per);
      bt = ft(1):ft(end);
      br = zeros(1,length(bt)); % bin rate
      for k = 1:length(bt)
         br(k) = sum(ft==bt(k));
      end
      metric.erp(1,:) = bt/per;
      metric.erp(2,:) = br;
   else
      metric.erp = [];
   end
else
   %EMPTY METRICS
   metric.start = [];
   metric.pa = [];
   metric.p2p = [];
   metric.rms = [];
   metric.pf = [];
   metric.fi = [];
   metric.iet = [];
   metric.erp = [];
end
