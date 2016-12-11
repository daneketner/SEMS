function mf = middle_freq(w,op)

%MIDDLE_FREQ: Returns middle frequency values for each waveform
%
%USAGE: mf = middle_freq(w,op)
%
%INPUTS: w  - waveforms
%        op - operation: 'val', 'plot' 
%
%OUTPUTS: mf - array of middle frequencies  

for n=1:length(w)
   [amp freq] = pos_fft(w(n),'nfft',1024);
   c = cumsum(amp);
   [val ref] = min(abs(c-c(end)/2));
   mf(n) = freq(ref);
end

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(w,'start'); 
      scatter(x,mf,4)
      dynamicDateTicks
      ylabel('Middle Frequency')
      return
   case {'val'} % return middle frequency values (no plot)
      return
 end