function plot_power(varargin)
%
%PLOT_TF: Plot normalized power of wave using FFT &/or HHT
%
%plot_power(wave)
%plot_power(wave,nf_rng)
%plot_power(wave,nf_rng,'FFT')
%plot_power(wave,nf_rng,'HHT')
%plot_power(wave,nf_rng,'FFT','HHT')
%plot_power(wave,nf_rng,'HHT',imf_rng)
%plot_power(wave,nf_rng,'FFT','HHT',imf_rng)
%
%INPUTS: wave    - waveform object    
%        nf_rng  - 1x2 array containing normalized frequency range
%        tech    - Technique 'FFT' or 'HHT' or 'FFT','HHT'
%        imf_rng - IMF range, if 'HHT' is specified in tech
%
%OUTPUTS: generates a figure, no output arguments

if nargin > 0
   if isa(varargin{1}, 'waveform')
      wave = varargin{1};
   else
       return
   end
end
nf_rng = [0.001 1];
imf_rng = [1 20]; % probably out of bounds (reset to [1 end])
if nargin > 1
   if isa(varargin{2},'numeric')
      nf_rng = varargin{2};
   elseif isa(varargin{2},'char')
      tech = varargin{2};
   end
end
for n = 2:nargin
   if nargin > n-1
      if isa(varargin{n},'char')
         if ~exist('tech')
            tech = [];
         end
         tech = [tech;varargin{n}];
      elseif isa(varargin{n},'numeric')
         imf_rng = varargin{n};
      end
   end
end

if ~exist('tech')
   tech = 'FFT';
end

if nf_rng(1)<0.001
   nf_rng(1) = 0.001;
end
   

Fs = get(wave,'freq');                % Sampling Rate
station=get(wave,'station');          % Station
channel=get(wave,'channel');          % Channel
network=get(wave,'network');          % Network 
Ny_Fs = Fs/2;                         % Nyquist Frequency
F_range = Ny_Fs*nf_rng;

%%%%%%%%%%%%%%% Plot Power from FFT and/or globalized HHT %%%%%%%%%%%%%%%%%

figure('Name','Spectral Power','NumberTitle','off');
np = size(tech,1);
for n=1:np
   if strcmp(tech(n,:),'FFT')
      [go_pow go_freq] = goertzelsft(wave);
      go_pow = go_pow/sum(go_pow);
      subplot(np,1,n)
      plot(go_freq, go_pow)
      xlim(F_range)
      ylabel('Normalized Power from Fast Fourier Transform')
   elseif strcmp(tech(n,:),'HHT')
      [hht_g hht_f] = hht_global(wave,imf_rng);
      hht_pow = hht_g;
      hht_pow = hht_pow/sum(hht_pow);
      subplot(np,1,n)
      plot(hht_f,hht_pow)
      xlim(F_range)
      ylabel(['Normalized Power from Hilbert-Huang Transform (IMF ',...
               num2str(imf_rng(1)),' through ',num2str(imf_rng(2))])
   end
   if n==1
      title(['[',station,' ',channel,' ',network,']'])
   end
end
