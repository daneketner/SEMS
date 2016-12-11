function [] = hht_vs_fft(wave,nf_rng,imf_rng)
%
%HHT_VS_FFT: Plot waveform, HHT, & windowed FFT
%
%INPUTS: wave - waveform object    
%        nf_rng - 1x2 array containing normalized frequency range
%           (i.e. [0 .5])
%        imf_rng - 1x2 array containing IMF numbers to be plotted
%           (i.e. [1 14]), assuming that there are at least 14 IMFs
%
%OUTPUTS: none, creates a plot
%         

v = get(wave,'data');
Fs = get(wave,'freq');          % Sampling Rate
dt = 1/Fs;                      % Sampling Period
l_v = get(wave,'data_length');  % Data Length
xT = dt:dt:dt*l_v;              % Vector of Time Instances (s from t_start)
Ny_Fs = Fs/2;                   % Nyquist Frequency
station=get(wave,'station');    % Station
channel=get(wave,'channel');    % Channel
network=get(wave,'network');    % Network 

[Inst_Freq_Hz Inst_Amplitude imf] = hht(wave); % Hilbert-Huang TF

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
Smooth_g = gausswin(20,2.5);
im = conv2(im, Smooth_g);im = im';
im = conv2(im, Smooth_g);im = im';


%%%%% Plot Hilbert Spectrum %%%%

figure
h = axes('Position',[0 0 1 1],'Visible','off');
M=max(max(im));
warning off
im = 10*log10(im/M);
warning on
inf = -20;
g(1)=axes('position',[.1  .1  .8  .35]);
imagesc(xT,F_range,im,[inf,0]);
ylabel('Frequency (Hz)')
xlabel(['Time (seconds), start ',get(wave,'start_str'),' (UTC)'])
set(gca,'YDir','normal') 
xlim([min(xT) max(xT)])	
hold on

%%%%% Plot Seismic Wave %%%%

g(2)=axes('position',[.1  .45  .8  .1]);
plot(wave);
xlim([min(xT) max(xT)])	

%%%%% Make Spectrogram %%%%

warning off
w = Fs;                         % 1 second bins(time axis)
n_bins = floor(length(v)/w);    % Number of bins in spectrogram matrix
fft_array = zeros(w/2, n_bins); % Spectrogram matrix
for n = 1:floor(length(v)/w)    % Assemble FFT columns into spectrogram 
    temp = v(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    fft_array(:,n)= fft_temp;
end
fft_array = fft_array(1:w/2*nf_rng(2),:); % Remove freqs above max(F_range)

%%%%% Plot Spectrogram %%%%

g(3)=axes('position',[.1  .55  .8  .35]);
imagesc(xT,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title(['HHT vs. FFT [',station,' ',channel,' ',network,'] '])
xlim([min(xT) max(xT)])	
set(gcf,'CurrentAxes',h)
set(g,'Visible','on')
set(g(2),'Visible','off')
linkaxes(g,'x')
warning on
