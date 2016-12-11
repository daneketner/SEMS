function  peakfreq = peak_freq(events,op,tech)
%
%PEAK_FREQ: Returns peak frequency for each waveform in 'events'
%
%INPUTS: events - waveform seismic events
%        op     - operation: 'val', 'plot'
%        tech   - technique: 'fft' uses Fast Fourier Transform
%                            'hht' uses Hilbert-Huang Transform
%
%OUTPUTS: peakfreq - array of peak frequency
%         

E_l = length(events);

switch lower(tech)
   case {'fft'} % Fast Fourier Transform definition of frequency
      pf = zeros(1,E_l);
      for n = 1:E_l
          Fs = get(events(n),'freq');
          fftvec = fftshift(abs(fft(get(events(n),'data'))));
          fftvec = fftvec(ceil(length(fftvec)/2):end);
          [C I] = max(fftvec);
          pf(1,n) = I/length(fftvec)*Fs;
      end
   case {'hht'} % Hilbert-Huang Transform definition of frequency
      pf = zeros(1,E_l);
      for n = 1:E_l
         [a f] = hht_global(events(n)); % Amplitude & Frequency
         [C I] = max(a);
         pf(1,n) = f(I);
      end
 end

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(events,'start'); 
      scatter(x,pf)
      dynamicDateTicks
      ylabel(['Peak Frequency (Hz) using (' tech ')'])
      peakfreq = [];
      return
   case {'val'} % return frequency index values (no plot)
      peakfreq = pf; 
      return
 end