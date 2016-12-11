function [] = stack_hht(wave,nf_rng,imf_rng)
%
%STACK_HHT: Plots Hilbert Spectrum Stack
%
% stack_hht(wave,nf_rng,imf_rng)
%
%INPUTS: wave - waveform object    
%        nf_rng - 1x2 array containing normalized frequency range
%           (i.e. [0 .5])
%        imf_rng - 1x2 array containing IMF numbers to be plotted
%           (i.e. [1 14]), assuming that there are at least 14 IMFs
%
%OUTPUTS: none, creates a plot
%         

for N = 1:numel(wave)
   Fs = get(wave(N),'freq');                % Sampling Rate
   dt = 1/Fs;                            % Sampling Period
   l_v = get(wave(N),'data_length');        % Data Length
   xT = dt:dt:dt*l_v;                    % Vector of Time Instances (Seconds from t_start)
   Ny_Fs = Fs/2;                         % Nyquist Frequency
   station=get(wave(N),'station');          % Station
   channel=get(wave(N),'channel');          % Channel
   network=get(wave(N),'network');          % Network

   [Inst_Freq_Hz Inst_Amplitude imf] = hht(wave(N)); % Hilbert-Huang TF

   %%%%% Handle Variable Input %%%%%

   if nargin == 1
      F_range = [0 1]*Ny_Fs;       % Freq range to plot (0 to Ny_Fs)
      imf_rng = [1,size(imf,2)];   % IMF range to plot (All IMFs)
   end

   if nargin == 2                  % User specifies freq range to plot
      F_range = nf_rng*Ny_Fs;      % Freq range to plot (nf_rng)
      imf_rng = [1,size(imf,2)];   % IMF range to plot (All IMFs)
   end

   if nargin == 3                  % User specifies IMF range to plot
      F_range = nf_rng*Ny_Fs;      % Freq range to plot (nf_rng)
      if imf_rng(1) > imf_rng(2)   % User swapped input order
         temp = imf_rng(1);
         imf_rng(1) = imf_rng(2);
         imf_rng(2) = temp;
      end
      if imf_rng(2) > size(imf,2)  % User assumed more IMFs exist
         imf_rng(2) = size(imf,2);
      end
   end

   imf = imf(:,imf_rng(1):imf_rng(2));
   Inst_Freq_Hz = Inst_Freq_Hz(:,imf_rng(1):imf_rng(2));
   Inst_Amplitude = Inst_Amplitude(:,imf_rng(1):imf_rng(2));

   %%%%% Remove freqs above max(F_range) %%%%%

   for n = 1:min(size(Inst_Amplitude))
      for m = 1:max(size(Inst_Amplitude))
         if Inst_Freq_Hz(m,n) > F_range(2)
            Inst_Amplitude(m,n) = 0;
         end
      end
   end

   %%%%% Make Hilbert Spectrum Image %%%%

   [im,tt] = toimage(Inst_Amplitude',Inst_Freq_Hz'/(2*F_range(2)),xT);
   if N==1
      IM = im;
   else
      try
      IM = IM+im;
      catch
      end
   end
   %Smooth_g = gausswin(10,2.5);
   %im = conv2(im, Smooth_g);im = im';
   %im = conv2(im, Smooth_g);im = im';
end

%%%%% Plot Hilbert Spectrum %%%%

figure
M=max(max(IM));
warning off
IM = 10*log10(IM/M);
warning on
inf = -20;
imagesc(xT,F_range,IM,[inf,0]);
ylabel('Frequency (Hz)')
xlabel(['Time (seconds), start ',get(wave(1),'start_str'),' (UTC)'])
title(['HHT [',station,' ',channel,' ',network,'] IMF ',...
       num2str(imf_rng(1)),' through ',num2str(imf_rng(2))])
set(gca,'YDir','normal') 
