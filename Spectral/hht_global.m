function [hht_g hht_f] = hht_global(varargin)
%
%HHT_GLOBAL: Globalized Hilbert-Huang transform (mimicks FFT)
% hht_global(wave)
% hht_global(wave,imf_rng)
%
%INPUTS: wave    - waveform object    
%        imf_rng - Subset of IMFs to use during globalization
%           
%OUTPUTS: hht_g - Globalized HHT Amplitude array
%         hht_f - Globalized HHT Frequency array

if nargin > 0
   if isa(varargin{1}, 'waveform')
      wave = varargin{1};
   else
       return
   end
end

[Inst_Freq_Hz Inst_Amplitude imf] = hht(wave);

if nargin == 1
   imf_rng = [1 size(imf,2)];
elseif nargin == 2
   imf_rng = varargin{2};
   if imf_rng(2)>size(imf,2)
      imf_rng(2)=size(imf,2);
   end
end

Fs = get(wave,'freq');                % Sampling Rate
Ny_Fs = Fs/2;                         % Nyquist Frequency
l_v = get(wave,'data_length');        % Data Length

Inst_Freq_Hz = Inst_Freq_Hz(:,imf_rng(1):imf_rng(2));
Inst_Amplitude = Inst_Amplitude(:,imf_rng(1):imf_rng(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%% HHT freq collector %%%%%%%%%%%%%%%%%%%%%%%%%%%%

hht_g = zeros(1,l_v-1);
hht_f = (1:l_v-1)/(l_v-1)*Ny_Fs;

for n = 1:min(size(Inst_Amplitude)) %Remove freqs above max(F_range)
    for m = 1:max(size(Inst_Amplitude))
         [C I] = min(abs(hht_f-Inst_Freq_Hz(m,n)));
         hht_g(I) = hht_g(I)+Inst_Amplitude(m,n);
    end
end

