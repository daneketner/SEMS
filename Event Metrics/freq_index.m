function fi = freq_index(wfa,lfr,hfr,op)

%FREQ_INDEX: Frequency Index
%
%INPUTS: wfa  - event waveform array
%        lfr  - low freq range
%        hfr  - high freq range
%        op   - operation: 'val' returns values
%                          'plot' returns a plot
%
%OUTPUTS: findex - Frequency Index 

nw = length(wfa);
fi = zeros(nw,1);
for n = 1:nw
   [A F] = pos_fft(wfa(n));
   hf = A(F>=hfr(1) & F<=hfr(2));
   lf = A(F>=lfr(1) & F<=lfr(2));
   fi(n,1) = log10(mean(hf)/mean(lf));
end

switch lower(op)
   case {'plot'} % plot linear event spacing (plot)
      x=get(wfa,'start');
      scatter(x,fi,4)
      ylabel('Frequency Index')
      dynamicDateTicks
      return
   case {'val'} % return frequency index values (no plot)
      return
 end