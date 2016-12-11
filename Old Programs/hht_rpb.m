%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Analysis of April 14 Explosion using various signal proccessing tools
%   Rolan Baguyos, Dane Ketner, Sunil Panthi
%   Last modified March 08, 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear,clc

load April4_Explosion_SeisData.mat

startData = 1;      % Defines start and end of 'partial'
endData = 10000;
Fs = 50;                               % Sampling frequency (Hz)
dt = 1/Fs;                             % Sample time
L = size(endData-startData+1);         % Length of partial signal
t = (0:L-1)*dt;                        % Time vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Plot Original and Partial Signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
subplot(2, 1, 1)
plot(SeisData,t);
title('April4_Explosion_SeisData(all data)');

partial = SeisData(startData : endData);        % partial data set

subplot(2,1,2)
plot(partial,t);
title('original data(partial)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Empirical mode decomposition
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

super(1:endData,1) = 0;
H = super;

emd = eemd(partial,0,1);

emd_sub = emd(:,3:10);                    % # of IMFs

figure(2)
plot(emd_sub)
title('IMFs of partial data')

s = size(emd_sub);
for i = 1 : s(2)
super = super + emd_sub(:,i);
end

figure(3)
plot(super)
title('superposition of IMFs')

figure(4)
for n = 1:8

subplot(8,1,n)
plot(emd_sub(:,n))
title('IMFs')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Hilbert Transform of partial signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



H = hilbert(emd_sub);

omega = unwrap(angle(H));
dwdt = diff(omega)/dt/2/pi;

dwdt(size(dwdt)+1,:) = 0;

Inst_Amplitude = abs(H);

figure(5)

plot(dwdt)
title('Hilbert freq Spectrum')
axis([0 endData 0 20]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Spectrogram 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6)
spectrogram(SeisData,256,250,256,50,'yaxis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requires m-files in 'package_emd' folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[im,tt] = toimage(Inst_Amplitude',dwdt',t);

figure(7)
disp_hhs(im)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Wavelet analysis
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t = (1:1024)./1024;
% 
% figure(8)
% 
% wave = MakeWavelet(4, 8, 'Haar', [], 'Mother', 1024);
% subplot(2,2,1);
% plot(t(300:800), wave(300:800)); title('Haar Wavelet');
% 
% wave = MakeWavelet(4,8,'Daubechies',4,'Mother',1024);
% subplot(2,2,2);
% plot(t(300:800),wave(300:800)); title(' D4 Wavelet ');
% 
% wave = MakeWavelet(4,8,'Coiflet',3,'Mother',1024);
% subplot(2,2,3);
% plot(t(300:800),wave(300:800)); title(' C3 Coiflet ');
% 
% wave = MakeWavelet(4,8,'Symmlet',8,'Mother',1024);
% subplot(2,2,4);
% plot(t(300:800),wave(300:800)); title(' S8 Symmlet ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  fourier transform 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(partial,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(9)
plot(partial,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of partial')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')



