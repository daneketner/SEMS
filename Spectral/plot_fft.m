function plot_fft(w,varargin)

%% DEFAULT PROPERTIES
if (nargin == 0) || ~isa(w,'waveform')
   error('plot_fft: first argument must be a waveform')
else
   nfft = 2^(nextpow2(get(w(1),'duration')*24*60*60*get(w(1),'freq')));
   nfr = [0 .5];    %   
   smo = 4;         %   
   tap = .02;       %   
   type = 'offset'; %
   scale = 1;       %
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
         case 'type'      % Plot type: 'stack' or 'offset'
            type = val;   %         
         case 'scale'     % Scale FFT wiggles by this val (normalized)
            scale = val;  %             
         otherwise
            error('plot_fft: Property name not recognized')
      end
   end
end

%% PLOT FFT
nw = numel(w);
figure
ax = axes;
hold on
for n = 1:nw
   [A F] = pos_fft(w(n),'nfft',nfft,'nfr',nfr,'smooth',smo,'taper',tap);
   A=A/max(A);
   switch type
      case{'offset'}
         plot(ax,F,A*scale+n*.5)
         ypos(n)=n*.5;
         ylab{n}=datestr(get(w(n),'start'));
         if n==nw
            set(ax,'YTick',ypos,'YTickLabel',ylab)
            YLim([0 n/2+1.5])
         end
      case{'stack'}
         plot(ax,F,A*scale)
         YLabel('Normalized Spectral Amplitude')
   end
end

XLabel('Frequency (Hz)')