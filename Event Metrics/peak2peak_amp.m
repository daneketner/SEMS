function  p2p = peak2peak_amp(w,op)

%PEAK2PEAK_AMP: Returns peak-to-peak amplitude for each waveform
%
%USAGE: p2p = peak2peak_amp(w,op)
%
%INPUTS: w  - waveforms
%        op - operation: 'val', 'plot' 
%
%OUTPUTS: p2p - array of peak amplitudes      

p2p = max(w)-min(w);

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(w,'start'); 
      scatter(x,p2p,4)
      dynamicDateTicks
      ylabel('Peak-to-Peak Amplitude')
      return
   case {'val'} % return peak amplitude values (no plot)
      return
 end