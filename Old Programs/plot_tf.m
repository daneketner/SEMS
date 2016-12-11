function plot_tf(wave,norm_freq_range)
%
%PLOT_TF: Plot Time-Frequency representation of wave
%
%PLANS FOR IMPROVEMENT: Mode input selecting different ways to display the
%TF data (only HHT, only SFFT, both, other options)
%
%INPUTS: wave - waveform object    
%        norm_freq_range - 1x2 array containing normalized frequency range
%        (i.e. [0 .5])   
%
%OUTPUTS: generates a figure, no output arguments

v = get(wave,'data');
Fs = get(wave,'freq');                % Sampling Rate
Ny_Fs = Fs/2;                         % Nyquist Frequency
dt = 1/Fs;                            % Sampling Period
T = get(wave,'timevector');           % Vector of Time Instances (Matlab Format)
l_v = get(wave,'data_length');        % Data Length
xT = dt:dt:dt*l_v;                    % Vector of Time Instances (Seconds from t_start)
F_range = norm_freq_range*Ny_Fs;      % Frequency range to plot

station=get(wave,'station');          % Station
channel=get(wave,'channel');          % Channel
network=get(wave,'network');          % Network 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Inst_Freq_Hz Inst_Amplitude] = hht(wave);

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
Smooth_g = gausswin(20);
im = conv2(im, Smooth_g);im = im';
im = conv2(im, Smooth_g);im = im';

%%%%% Plot Hilbert Spectrum %%%%

figure('Name','HHT vs. FFT','NumberTitle','off');
h = axes('Position',[0 0 1 1],'Visible','off');
M=max(max(im));
warning off
im = 10*log10(im/M);
warning on
inf = -20;
g(1)=axes('position',[.1  .1  .8  .35]);
imagesc(xT,F_range,im,[inf,0]);
ylabel('Frequency (Hz)')
xlabel(['Time in seconds, start ',get(wave,'start_str'),' (UTC)'])
%set(gca,'YDir','normal') 

xlim([min(xT) max(xT)])	
hold on

%%%%% Plot Seismic Wave %%%%

g(2)=axes('position',[.1  .45  .8  .1]);
plot(wave);
xlim([min(xT) max(xT)])	

%%%%% Make Spectrogram %%%%

w = .5*Fs;                      % 1/2 second bins(time axis)
n_bins = floor(length(v)/w);    % Number of bins in spectrogram matrix
fft_array = zeros(w/2, n_bins); % Spectrogram matrix

for n = 1:floor(length(v)/w)    % Loop assembles FFT columns into spectrogram matrix
    
    temp = v(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    fft_array(:,n)= fft_temp;
    
end
fft_array = fft_array(1:w/2*norm_freq_range(2),:); % Remove freqs above max(F_range)

%%%%% Plot Spectrogram %%%%

g(3)=axes('position',[.1  .55  .8  .35]);
imagesc(xT,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title(['[',station,' ',channel,' ',network,'] ',datestr(get(wave,'start'),'dd-mmm-yyyy')])
xlim([min(xT) max(xT)])	
set(gcf,'CurrentAxes',h)
set(g,'Visible','on')
set(g(2),'Visible','off')