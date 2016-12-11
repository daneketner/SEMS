function  pf = peak_freq(w,op)

%PEAK_FREQ: Returns peak frequency for each waveform
%
%USAGE: pf = peak_freq(w,op)
%
%INPUTS: w  - waveforms
%        op - operation: 'val', 'plot' 
%
%OUTPUTS: pf - array of peak frequencies       

nw = numel(w);

pf = zeros(1,nw);
for n = 1:nw
   [A F] = pos_fft(w(n),'nfft',1024,'smooth',4,'taper',.02);
   [C I] = max(A);
   pf(1,n) = F(I);
end

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(w,'start'); 
      scatter(x,pf,4)
      dynamicDateTicks
      ylabel(['Peak Frequency (Hz)'])
      return
   case {'val'} % return frequency index values (no plot)
      return
 end