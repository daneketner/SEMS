function [A F] = fft_stack(w,varargin)

%% DEFAULT PROPERTIES
if (nargin == 0) || ~isa(w,'waveform')
   error('fft_stack: first argument must be a waveform')
else
   nfft = 2^(nextpow2(get(w(1),'duration')*24*60*60*get(w(1),'freq')));
   nfr = [0 1];     %   
   smo = 4;         %   
   tap = .02;       %   
   norm = 0;
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['plot_fft: Arguments after wave must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nfft'      % Number of elements in Discrete Fourier Tansform
            nfft = val;
         case 'nfr'       % Normalized Frequency Range to return
            nfr = val;    %   [0 1] --> [0 Ny] Hz
         case 'smooth'    % Smooth resulting Amplitudes 
            smo = val;    %   using this window size (# of samples)     
         case 'taper'     % Taper using a Hanning window (0 to 1)
            tap = val;    %   smaller value makes for steeper edges           
         case 'norm'      % Normalize Spectra from each event (1:yes, 0:no)
            norm = val;  %            
         otherwise
            error('fft_stack: Property name not recognized')
      end
   end
end

%% PLOT FFT
nw = numel(w);
for n = 1:nw
   [AA F] = pos_fft(w(n),'nfft',nfft,'nfr',nfr,'smooth',smo,'taper',tap);
   if norm == 1
      AA=AA/max(AA);
   end
   if exist('A')
    A = A+AA;
   else
      A = AA;
   end
end