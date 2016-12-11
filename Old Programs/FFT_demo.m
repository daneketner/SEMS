%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Demonstration of Fourier Transform
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = -1.5:.01:1.49;
f_t_1 = cos(2*pi*(1.5*t)).*exp(-pi*t.^2);
f_t_2 = cos(2*pi*(4*t)).*exp(-pi*t.^2);
f_t_3 = cos(2*pi*(9*t)).*exp(-pi*t.^2);

f_t_a = [f_t_1 f_t_2 f_t_3];
f_t_b = [f_t_2 f_t_3 f_t_1];

Fs = 100;% Hz
t_vec = .01:.01:length(t);
Hz_vec = (t_vec-4.5)*11;

figure

subplot(2,1,1)
plot(t_vec,f_t_a);
xlim([.001 9])
title('Signal x_1(t)')

subplot(2,1,2)
[SS,FF,TT]=spectrogram(f_t_a,200,195,0:.2:20,Fs);
SS = abs(SS);
imagesc(t_vec,F_range,SS);
ylabel('Frequency (Hz)')
xlabel('Time (seconds)')
set(gca,'YDir','normal') 
title('Windowed Fourier Spectrum')

% figure
% 
% subplot(2,3,1)
% plot(t_vec,f_t_a);
% xlim([.001 9])
% xlabel('Time (seconds)')
% title('Signal x_1(t)')
% 
% subplot(2,3,2)
% plot(Hz_vec,abs(fftshift(fft(f_t_a)))/50)
% set(gca,'XTick',[1.5 4 9])
% set(gca,'XTickLabel',{'1.5 Hz','4 Hz','9 Hz'})
% xlim([0 20]) 
% xlabel('Frequency (Hz)')
% title('Fourier Transform of Signal x_1(t)')
% 
% subplot(2,3,3)
% [SS,FF,TT]=spectrogram(f_t_a,20,15,0:.2:20,Fs);
% SS = abs(SS);
% imagesc(t,F_range,SS);
% ylabel('Frequency (Hz)')
% set(gca,'YDir','normal') 
% title('Windowed Fourier Spectrum')
% 
% subplot(2,3,4)
% plot(t_vec,f_t_b);
% xlim([.001 9])
% xlabel('Time (seconds)')
% title('Signal x_1(t)')
% 
% subplot(2,3,5)
% plot(Hz_vec,abs(fftshift(fft(f_t_b)))/50)
% set(gca,'XTick',[1.5 4 9])
% set(gca,'XTickLabel',{'1.5 Hz','4 Hz','9 Hz'})
% xlim([0 20]) 
% xlabel('Frequency (Hz)')
% title('Fourier Transform of Signal x_1(t)')
% 
% subplot(2,3,6)
% [SS,FF,TT]=spectrogram(f_t_b,20,15,0:.2:20,Fs);
% SS = abs(SS);
% imagesc(t,F_range,SS);
% ylabel('Frequency (Hz)')
% set(gca,'YDir','normal') 
% title('Windowed Fourier Spectrum')

