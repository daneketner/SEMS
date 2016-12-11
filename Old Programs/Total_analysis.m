%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Analysis of SeisData using HHT Analysis
%   Rolan Baguyos, Dane Ketner, Sunil Panthi
%   Last modified March 10, 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear,clc
% 
% load RDN_EHZ_R.mat

Fs = 50;                               % Sampling frequency (Hz)
dt = 1/Fs;                             % Sample time

startData = 47500;        % Defines start and end of 'partial'
endData = 50000;

partial = SeisData(startData : endData);        % partial data set

L_total = length(SeisData);           % Length of total signal
L_part = length(partial);             % Length of partial signal

t_total = (1:L_total)*dt;             % Time vector of total
t_part = (startData:endData)*dt;      % Time vector of partial

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Plot Original and Partial Signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

subplot(2, 1, 1)
plot(t_total,SeisData);
title('Seismic Data Set');
xlabel('Time[s]')

subplot(2,1,2)
plot(t_part,partial);
title('Partial Data Set')
xlabel('Time[s]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Empirical mode decomposition
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

super(1:L_part,1) = 0;

imf_set = [4 5 6 7 8 9 10 11];
emd = eemd(partial,0,1);
emd_sub = emd(:,imf_set);                    % # of IMFs

figure
plot(t_part,emd_sub)
title('IMFs of partial data')
xlabel('Time[s]')

s = size(emd_sub);
for i = 1 : s(2)
super = super + emd_sub(:,i);
end

figure
plot(t_part,super)
title('superposition of IMFs')
xlabel('Time[s]')
ylabel('Amplitude')

figure

for n = 1:max(size(imf_set))

subplot(max(size(imf_set)),1,n)
plot(t_part,emd_sub(:,n))
title(['IMF ',int2str(imf_set(n))])

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Hilbert Transform of partial signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = hilbert(emd_sub);

omega = unwrap(angle(H));
dwdt = diff(omega);

dwdt(L_part,:) = dwdt(L_part-1,:);  % Stuff an extra row

Inst_Amplitude = abs(H);

figure
plot(t_part,dwdt*(2*pi)*Fs)
title('Hilbert Frequency Spectrum')
axis([startData*dt endData*dt 0 20]);
xlabel('Time[s]')
ylabel('Frequency[Hz]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Spectrogram 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(2,1,1)
spectrogram(SeisData,256,250,256,50,'yaxis');
title('Spectrogram of Full Data Set')
subplot(2,1,2)
spectrogram(partial,256,250,256,50,'yaxis');
title('Spectrogram of Partial Data Set')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Requires m-files in 'package_emd' folder
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[im,tt] = toimage(Inst_Amplitude',dwdt',t_part);

im = smoothts(im, 'g',100,50);
im = im';
im = smoothts(im, 'g',100,50);
im = im';

figure
M=max(max(im));
warning off
im = 10*log10(im/M);
warning on
inf = -20;
imagesc(t_part,[0,0.5*Fs],im,[inf,0]);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
xlabel('Time (s)')
title('Hilbert-Huang spectrum of IMFs')

