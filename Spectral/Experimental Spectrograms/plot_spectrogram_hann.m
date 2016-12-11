function plot_spectrogram_hann(wave,nf_rng)
%
%PLOT_SPECTROGRAM_HANN: Sliding hanning windowed fft
%
%INPUTS: wave - waveform object    
%        nf_rng - 1x2 array containing normalized frequency range
%           (i.e. [0 .5])
%
%OUTPUTS: none, generates a plot

host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

station=get(wave,'station');          % Station
channel=get(wave,'channel');          % Channel
network=get(wave,'network');          % Network 
scnl = get(wave,'scnlobject');
Fs = get(wave,'freq');
dt = 1/Fs;
Ny_Fs = Fs/2;
F_range = nf_rng*Ny_Fs;      % Frequency range to plot

v_a = get(wave, 'data');
L_a = length(v_a);
xT = dt:dt:dt*L_a;           % Vector of Time Instances (Seconds from t1_a)

t1_a = get(wave, 'start');
t2_a = get(wave, 'end');
t1_b = t1_a-1/24/60/60;
t2_b = t2_a+1/24/60/60;
t1_b_str = datestr(t1_b,0);
t2_b_str = datestr(t2_b,0);

wave_b = waveform(ds,scnl,t1_b_str,t2_b_str); 
v_b = get(wave_b, 'data');
L_b = length(v_b);

f = 0:.01:Ny_Fs;
f_l = length(f);

pad = zeros(L_a,1);
warning off
for n = 1:L_a
    v_data = v_b(n:n+2*Fs);                 % Window captures 1 second either side of data point
    v_data = v_data - mean(v_data);         % Demean data
    v_data = v_data.*hann(length(v_data));  % Hanning window over data
    v_data = [pad; v_data; pad];            % Pad with zeros before and after (Fourier smoothing)
    v_fft = abs(fft(v_data));               % Fourier magic
    L_fft = length(v_fft);                  % Length of FFT
    v_fft = v_fft(1:floor(L_fft/2));        % FFT from 0 to Ny_Fs
    L_fft = length(v_fft);                  % Length of truncated FFT
    v_fft = v_fft(1:L_fft*nf_rng(2));       % FFT from 0 to F_range(2)
    L_fft = length(v_fft);                  % Length of truncated FFT
    fft_array(:,n) = v_fft;
end
warning on
f_lin = linspace(F_range(1),F_range(2),L_fft);
figure
imagesc(xT,F_range,fft_array);
ylabel('Frequency (Hz)')
xlabel(['Time (seconds), start ',get(wave,'start_str'),' (UTC)'])
set(gca,'YDir','normal') 
title(['Improved FFT [',station,' ',channel,' ',network,'] '])
xlim([min(xT) max(xT)])











