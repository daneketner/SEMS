function [A F] = pos_fft(w,varargin)

%POS_FFT: Returns real-positive amplitudes and frequencies (Hz) for inputed
%         waveform (w).
%
%USAGE: [A F] = pos_fft(w)
%       [A F] = pos_fft(w,prop_name, prop_val)
%
%STATIC INPUTS: w - waveform object
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nfft'  --> (1x1)-[numeric]-[default: 2^(nextpow2(L))]
%  'fr'    --> (1x2)-[numeric]-[default: [0 Nyquist]]
%  'nfr'   --> (1x2)-[numeric]-[default: [0 1]]
%  'smooth'--> (1x1)-[numeric]-[default: 0]
%  'taper' --> (1x1)-[numeric]-[default: 0]
%  'norm'  --> (1x1)-[numeric]-[default: 0]
%
%OUTPUTS: A - Real/Pos amplitudes
%         F - Frequencies (Hz)

%% DEFAULT PROPERTIES
if (nargin >= 1) && isa(w,'waveform')
   Ny = get(w(1),'freq')/2;
   d = double(demean(w));
   clear w
   [y, x] = size(d);
   nfft = 2^(nextpow2(y));
   fr = [0 Ny];
   smo = 0;
   tap = 0;
   norm = 0;
else
   error('pos_fft: first argument must be a waveform')
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['pos_fft: Arguments after wave must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nfft'     % Number of elements in Discrete Fourier Tansform
            nfft = val;  %
         case 'fr'       % Frequency Range to return
            fr = val;    %   [fr1 fr2] Hz            
         case 'nfr'      % Normalized Frequency Range to return
            fr = val*Ny; %   [0 1] --> [0 Ny] Hz
         case 'smooth'   % Smooth resulting Amplitudes 
            smo = val;   %   using this window size (# of samples)     
         case 'taper'    % Taper using a Hanning window (0 to 1)
            tap = val;   %   smaller value makes for steeper edges  
         case 'norm'     % Normalize FFT output per trace
            norm = val;  %   smaller value makes for steeper edges              
         otherwise
            error('pos_fft: Property name not recognized')
      end
   end
end

%% FFT
X = fftshift(abs(fft(d,nfft)));
if rem(nfft,2)==0 % vector is even
   A = X(nfft/2:end,:);
   S = size(A,1);
   f1 = Ny/((S-1)*2+1);
   F = linspace(f1,Ny,S)';
elseif rem(nfft,2)==1 % vector is odd
   A = X(ceil(nfft/2):end); % 0 Hz not returned
   S = size(A,1);
   f1 = Ny/S;
   F = linspace(f1,Ny,S)';
end

%% SMOOTH/TAPER/NORMALIZE (IF REQUESTED)
for k = 1:x
   if smo > 0
      A(:,k) = fastsmooth(A(:,k),smo);
   end
   if tap > 0
      A(:,k) = A(:,k).*tukeywin(S,tap);
   end
   if norm > 0
      A(:,k) = A(:,k)/max(A(:,k));
   end
end

%% RETURN ONLY FREQS SPECIFIED BY 'nfr'
range = find((F>=fr(1))&(F<=fr(2)));
A = A(range,:);
F = F(range,:);