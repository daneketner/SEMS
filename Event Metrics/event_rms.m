function  eventrms = event_rms(e_wfa,op)
%
%EVENT_RMS: 
%
%INPUTS: e_wfa - event waveform array
%        op    - operation: 'val', 'plot'
%
%OUTPUTS: erms
%         

er = rms(e_wfa);

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(e_wfa,'start');
      scatter(x,er)
      dynamicDateTicks
      ylabel('Event RMS')
      return
   case {'val'} % return frequency index values (no plot)
      eventrms = er; 
      return
end
 
