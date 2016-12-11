function  pa = peak_amp(w,op)

%PEAK_MAP: Returns absolute peak amplitude for each waveform
%
%USAGE: pa = peak_amp(w,op)
%
%INPUTS: w  - waveforms
%        op - operation: 'val', 'plot' 
%
%OUTPUTS: pf - array of peak frequencies       

pa = max(abs(demean(w)));

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(w,'start'); 
      scatter(x,pa,4)
      dynamicDateTicks
      ylabel(['Peak Amplitude'])
      return
   case {'val'} % return peak amplitude values (no plot)
      return
 end