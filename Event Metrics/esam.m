function esam_array = esam(w,varargin)

%% DEFAULT PROPERTIES
if (nargin >= 1) && isa(w,'waveform')
   d = get(w,'data');
   l = length(d{1});
   nfft = 2^(nextpow2(l));
   Ny = get(w,'freq')/2;
   nfr = [0 .5];
   smo = 4;
   tap = .02;
   plo = 1;
   clr = jet;
else
   error('esam: first argument must be a waveform')
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['esam: Arguments after wave must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nfft'    % Number of elements in Discrete Fourier Tansform
            nfft = val;
         case 'nfr'     % Normalized Frequency Range to return
            nfr = val;  %   [0 1] --> [0 Ny] Hz
         case 'smooth'  % Smooth resulting Amplitudes 
            smo = val;  %   using this window size (# of samples)     
         case 'taper'   % Taper using a Hanning window (0 to 1)
            tap = val;  %   smaller value makes for steeper edges         
         case 'plot'    % Generate plot or not
            plo = val;  %   (0 or 1)        
         case 'colormap'% Image colormap
            clr = val;  %   (0 or 1)       
         otherwise
            error('esam: Property name not recognized')
      end
   end
end

%% MAKE ESAM MATRIX
nw = numel(w);
for n = 1:nw
   d = get(demean(w(n)),'data');
   [A F] = pos_fft(w(n),'nfr',nfr,'nfft',nfft,'taper',tap,'smooth',smo);
   esam_array(:,n)= A/max(A);
end

%% PLOT IT
if plo
figure
M=max(max(esam_array));
warning off
esam_array = 10*log10(esam_array/M);
warning on
inf = -20;
imagesc(1:nw,F,esam_array,[inf,0]);
colormap(clr);
ylabel('Frequency (Hz)')
xlabel('Event Number')
set(gca,'YDir','normal') 
end
