%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Display IMFs and their HHT spectrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Fs = 50;                           %Sampling Frequency (Hz) [Station RDWB]
Ny_Fs = Fs/2;                      %Nyquist Frequency
Norm_freq_range = [0,5/25];           %Normalized Frequency range to plot
F_range = Norm_freq_range*Ny_Fs;   %Frequency range to plot
dt = 1/Fs;                         %Sample Time

startData = 400*Fs;                 %Defines start and end of 'partial'
endData = 700*Fs;

start_imf = 1;
end_imf = 10;
imf_numbers = (start_imf : end_imf);  %Number Array of IMF subset

partial = SeisData(startData : endData);       %Partial data set

L_total = length(SeisData);           % Length of total signal
L_part = length(partial);             % Length of partial signal

t_total = (1:L_total)*dt;             % Time vector of total
t_part = (startData:endData)*dt;      % Time vector of partial


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Plot Original and Partial Signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

subplot(2, 1, 1)
plot(t_total,SeisData);
xlim([1 L_total]/Fs)
%title('March 22, [16:20 UTC] Station RDWB');
%title('March 23, [08:14 UTC] Station RDWB');
%title('March 27, [01:18 UTC] Station RDWB');
xlabel('Time(s)')

subplot(2,1,2)
plot(t_part,partial);
xlabel('Time(s)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Empirical Mode Decomposition
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imf = eemd(partial,0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Plot all IMFs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

for n = 1:5

subplot(5,2,2*n-1)
plot(t_part,imf(:,n+1))

if n == 1
title('IMFs 1 through 5')
end
if n == 5
xlabel('Time (s)')
end

subplot(5,2,2*n)
plot(t_part,imf(:,n+6))

if n == 1
title('IMFs 6 through 10')
end
if n == 5
xlabel('Time (s)')
end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Plot individual IMFs and their HHT specrum
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for n = start_imf:end_imf      %Individual IMFs to plot
% 
% H = hilbert(imf(:,n));
% 
% omega = unwrap(angle(H));
% dwdt = (diff(omega));       %Radians/sec  
% dwdt(L_part,:) = dwdt(L_part-1,:);
% 
% Inst_Freq_Hz = abs(dwdt/(2*pi)*Fs);
% 
% Inst_Amplitude = abs(H);
% 
% [im,tt] = toimage(Inst_Amplitude',Inst_Freq_Hz'/(2*F_range(2)),t_part);
% 
% smooth_size = 30;
% smooth_array = gausswin(smooth_size);
% im = conv2(im, smooth_array);
% im = im';
% im = conv2(im, smooth_array);
% im = im';
% 
% figure
% 
% subplot(3,1,1)
% plot(t_part,imf(:,n))
% ylabel('Amplitude')
% xlabel('Time (s)')
% title(['IMF ',int2str(n)])
% 
% subplot(3,1,2)
% plot(t_part,Inst_Freq_Hz)        
% ylabel('Instantaneous Frequency Hz')
% xlabel('Time (s)')
% title(['IMF ',int2str(n)])
% 
% subplot(3,1,3)
% M=max(max(im));
% warning off
% im = 10*log10(im/M);
% warning on
% inf = -20;
% imagesc(t_part,F_range,im,[inf,0]);
% ylabel('Frequency (Hz)')
% set(gca,'YDir','normal') 
% xlabel('Time (s)')
% title(['Hilbert-Huang spectrum of IMF ',int2str(n)])
% 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Windowed Fourier Analysis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = 50;
n_bins = floor(length(partial)/w);
fft_array = zeros(w/2, n_bins);

for n = 1:floor(length(partial)/w) 
    
    temp = partial(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    
    fft_array(:,n)= fft_temp;
    
end

figure
subplot(2,1,1)
imagesc(t_part,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title('Windowed Fourier Spectrum')
xlim([startData/Fs endData/Fs])

% figure
% subplot(2,1,1)
% [SS,FF,TT]=spectrogram(partial,50,48,0:.1:F_range(2),Fs);
% SS = abs(SS);
% imagesc(t_part,F_range,SS);
% ylabel('Frequency (Hz)')
% set(gca,'YDir','normal') 
% title('Windowed Fourier Spectrum')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Plot HHT specrum of combined IMFs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imf_sub = imf(:,imf_numbers);     %Array of IMF subset to be plotted

H = hilbert(imf_sub);

omega = unwrap(angle(H));
dwdt = (diff(omega));       %Radians/sec  
dwdt(L_part,:) = dwdt(L_part-1,:);

Inst_Freq_Hz = abs(dwdt/(2*pi)*Fs);

Inst_Amplitude = abs(H);

[im,tt] = toimage(Inst_Amplitude',Inst_Freq_Hz'/(2*F_range(2)),t_part);

Smooth_g = gausswin(15);
im = conv2(im, Smooth_g);
im = im';
im = conv2(im, Smooth_g);
im = im';

subplot(2,1,2)
M=max(max(im));
warning off
im = 10*log10(im/M);
warning on
inf = -20;
imagesc(t_part,F_range,im,[inf,0]);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
xlabel('Time (s)')
title(['Hilbert Spectrum of IMF ',int2str(start_imf),' through ',int2str(end_imf)])
