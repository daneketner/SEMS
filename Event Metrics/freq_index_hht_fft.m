function findex = freq_index(e_wfa,lf_r,hf_r,op,tech)
%
%FREQ_INDEX: Frequency Index
%
%INPUTS: e_wfa  - event waveform array
%        lf_r   - low freq range
%        hf_r   - high freq range
%        op     - operation: 'val' returns values
%                            'plot' returns a plot
%        tech   - technique: 'fft'
%                            'hht'
%
%OUTPUTS: fi_hht - Frequency Index using Hilbert-Huang Transform
%         fi_fft - Frequency Index using Fast Fourier Transform

lf_c = [];      % Low frequency amplitudes collector
hf_c = [];      % High frequency amplitudes collector
E_l = length(e_wfa);

switch lower(tech)
   case {'fft'} % Fourier Transform definition of frequency
      fi = zeros(E_l,1);
      for n = 1:E_l
          [g f]=goertzelsft(e_wfa(n));
          for m = 1:length(f)
              if (f(m) >= lf_r(1))&&(f(m) <= lf_r(2))
                  lf_c = [lf_c g(m)];
              elseif (f(m) >= hf_r(1))&&(f(m) <= hf_r(2))
                  hf_c = [hf_c g(m)];
              end
          end
          fi(n,1) = log10(mean(hf_c)/mean(lf_c));
          lf_c = [];
          hf_c = [];
      end
   case {'hht'} % Hilbert-Huang Transform definition of frequency
      fi = zeros(E_l,1);
      for n = 1:E_l
         [Inst_Freq_Hz Inst_Amplitude imf] = hht(e_wfa(n));
         for m = 1:min(size(Inst_Amplitude)) 
            for q = 1:max(size(Inst_Amplitude))
               if (Inst_Freq_Hz(q,m) >= lf_r(1))&&...
                  (Inst_Freq_Hz(q,m) <= lf_r(2))
                  lf_c = [lf_c Inst_Amplitude(q,m)];
               elseif (Inst_Freq_Hz(q,m) >= hf_r(1))&&...
                      (Inst_Freq_Hz(q,m) <= hf_r(2))
                  hf_c = [hf_c Inst_Amplitude(q,m)]; 
               end
            end
         end
         fi(n,1) = log10(mean(hf_c)/mean(lf_c)); 
         lf_c = [];     
         hf_c = [];
      end
 end

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      x=get(e_wfa,'start');
      scatter(x,fi)
      ylabel(['Frequency Index (' tech ')'])
      dynamicDateTicks
      return
   case {'val'} % return frequency index values (no plot)
      findex = fi; 
      return
 end