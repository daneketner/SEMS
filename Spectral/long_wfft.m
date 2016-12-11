function fft_array = long_wfft(w,N,nfr)

%%%%% Make Spectrogram %%%%

v = get(w,'data');
Fs = get(w,'freq');          % Sampling Rate
Ny = Fs/2;                   % Nyquist Freq
dt = 1/Fs;                   % Sampling Period
F_range = nfr*Ny;            % Frequency range to plot (Hz)
l_v = get(w,'data_length');  % Data Length
xT = dt:dt:dt*l_v;           % Vector of Time Instances (s from t_start)
station=get(w,'station'); % Station
channel=get(w,'channel'); % Channel
network=get(w,'network'); % Network 

warning off

n_bins = floor(length(v)/N);    % Number of bins in spectrogram matrix
fft_array = zeros(N/2, n_bins); % Spectrogram matrix
for n = 1:floor(length(v)/N)    % Assemble FFT columns into spectrogram 
    temp = v(n*N-(N-1):n*N);
    temp = temp - sum(temp)/N;
    fft_temp = fftshift(abs(fft(temp,N)));
    fft_temp = fft_temp(N/2+1:N);
    % fft_array(:,n)= fft_temp/max(fft_temp); % Normalize all columns
    fft_array(:,n)= fft_temp;           % Don't Normalize all columns
end
fft_array = fft_array(1:N/2*nfr(2),:); % Remove upper freqs

%%%%% Plot Spectrogram %%%%

imagesc(xT,F_range,fft_array);
colormap(bone)
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title([station,' ',channel,' ',network])
xlim([min(xT) max(xT)])	

warning on

